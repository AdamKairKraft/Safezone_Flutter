import 'package:dio/dio.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:safezone_tablet/local_db/database.dart';
import 'package:safezone_tablet/models/report.dart';
import 'package:safezone_tablet/repositories/reports_repository.dart';
import 'package:safezone_tablet/repositories/sync_service.dart';

import '../support/fake_http_adapter.dart';

Map<String, dynamic> _reportPayload({String status = 'DRAFT'}) => {
      'organizationId': 'org-1',
      'siteId': 'site-1',
      'industryModuleCode': 'CONSTRUCTION',
      'reportTypeCode': 'TOOLBOX_TALK',
      'status': status,
      'data': {'topic': 'Ladder safety', 'attendees': '9'},
      'clientCreatedAt': null,
      'submittedBy': null,
    };

void main() {
  late AppDatabase db;
  late Dio dio;
  late FakeHttpClientAdapter adapter;
  late ReportsRepository reportsRepository;
  late SyncService syncService;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    adapter = FakeHttpClientAdapter();
    dio = Dio()..httpClientAdapter = adapter;
    reportsRepository = ReportsRepository(db: db, dio: dio);
    syncService = SyncService(db: db, dio: dio, reportsRepository: reportsRepository);
  });

  tearDown(() => db.close());

  group('push', () {
    test('an APPLIED result clears the outbox entry and the dirty flag', () async {
      await reportsRepository.saveDraft(
        id: 'report-1',
        payload: ReportDraftPayload(
          organizationId: 'org-1',
          siteId: 'site-1',
          industryModuleCode: 'CONSTRUCTION',
          reportTypeCode: 'TOOLBOX_TALK',
          data: {'topic': 'Ladder safety', 'attendees': '9'},
        ),
      );

      adapter.on('POST', '/api/sync/push', (options) => (
            statusCode: 200,
            body: [
              {
                'entityType': 'report',
                'entityId': 'report-1',
                'status': 'APPLIED',
                'currentVersion': 0,
                'currentPayload': _reportPayload(),
              }
            ],
          ));
      adapter.on('GET', '/api/sync/pull', (options) => (statusCode: 200, body: <String, dynamic>{}));

      final result = await syncService.syncNow(organizationId: 'org-1', actorUserId: 'user-1');

      expect(result.pushedCount, 1);
      expect(result.conflictCount, 0);
      expect(await reportsRepository.listDirty(), isEmpty);
      final stored = await reportsRepository.getById('report-1');
      expect(stored!.version, 0);
    });

    test('a CONFLICT result still applies the server payload (last-write-wins already happened server-side)', () async {
      await reportsRepository.saveDraft(
        id: 'report-1',
        payload: ReportDraftPayload(
          organizationId: 'org-1',
          siteId: 'site-1',
          industryModuleCode: 'CONSTRUCTION',
          reportTypeCode: 'TOOLBOX_TALK',
          data: {'topic': 'My local edit', 'attendees': '9'},
        ),
      );

      adapter.on('POST', '/api/sync/push', (options) => (
            statusCode: 200,
            body: [
              {
                'entityType': 'report',
                'entityId': 'report-1',
                'status': 'CONFLICT',
                'currentVersion': 3,
                'currentPayload': _reportPayload()..['data'] = {'topic': 'My local edit', 'attendees': '9'},
                'conflictId': 'conflict-1',
              }
            ],
          ));
      adapter.on('GET', '/api/sync/pull', (options) => (statusCode: 200, body: <String, dynamic>{}));

      final result = await syncService.syncNow(organizationId: 'org-1', actorUserId: 'user-1');

      expect(result.pushedCount, 0);
      expect(result.conflictCount, 1);
      expect(result.hadConflicts, isTrue);
      // The push's own payload won server-side, so the local row is reconciled to the
      // server's version/state and is no longer dirty - the conflict record (not tested
      // here, that's ReferenceDataRepository's job) is what preserves the losing side.
      expect(await reportsRepository.listDirty(), isEmpty);
      final stored = await reportsRepository.getById('report-1');
      expect(stored!.version, 3);
    });

    test('an empty outbox never calls push at all', () async {
      adapter.on('GET', '/api/sync/pull', (options) => (statusCode: 200, body: <String, dynamic>{}));

      final result = await syncService.syncNow(organizationId: 'org-1', actorUserId: 'user-1');

      expect(result.pushedCount, 0);
      expect(adapter.capturedRequests.where((r) => r.path == '/api/sync/push'), isEmpty);
    });
  });

  group('pull', () {
    test('applies pulled reports to the local cache and advances the cursor to the latest updatedAt', () async {
      adapter.on('GET', '/api/sync/pull', (options) => (
            statusCode: 200,
            body: {
              'report': [
                {
                  'id': 'report-remote-1',
                  'version': 2,
                  'payload': _reportPayload(),
                  'updatedAt': '2026-08-20T10:00:00Z',
                },
                {
                  'id': 'report-remote-2',
                  'version': 0,
                  'payload': _reportPayload(),
                  'updatedAt': '2026-08-22T10:00:00Z',
                },
              ],
            },
          ));

      final result = await syncService.syncNow(organizationId: 'org-1', actorUserId: 'user-1');

      expect(result.pulledCount, 2);
      expect(await reportsRepository.getById('report-remote-1'), isNotNull);
      expect(await reportsRepository.getById('report-remote-2'), isNotNull);

      // Second sync should send the advanced cursor (max updatedAt from the first pull),
      // not the original 1970 epoch default.
      String? sentSince;
      adapter.on('GET', '/api/sync/pull', (options) {
        sentSince = options.queryParameters['since'] as String?;
        return (statusCode: 200, body: <String, dynamic>{});
      });
      await syncService.syncNow(organizationId: 'org-1', actorUserId: 'user-1');

      expect(sentSince, '2026-08-22T10:00:00.000Z');
    });

    test('leaves the cursor unchanged when nothing new is pulled', () async {
      var callCount = 0;
      final sentSinceValues = <String?>[];
      adapter.on('GET', '/api/sync/pull', (options) {
        callCount++;
        sentSinceValues.add(options.queryParameters['since'] as String?);
        return (statusCode: 200, body: <String, dynamic>{});
      });

      await syncService.syncNow(organizationId: 'org-1', actorUserId: 'user-1');
      await syncService.syncNow(organizationId: 'org-1', actorUserId: 'user-1');

      expect(callCount, 2);
      expect(sentSinceValues[0], sentSinceValues[1]);
    });
  });
}
