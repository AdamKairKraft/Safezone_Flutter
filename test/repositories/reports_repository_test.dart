import 'package:dio/dio.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:safezone_tablet/local_db/database.dart';
import 'package:safezone_tablet/models/report.dart';
import 'package:safezone_tablet/repositories/reports_repository.dart';

void main() {
  late AppDatabase db;
  late ReportsRepository repository;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    // dio here is unused by saveDraft/getById/listDirty (only submitReport hits the
    // network) - a bare Dio with no adapter wired up is fine for those tests.
    repository = ReportsRepository(db: db, dio: Dio());
  });

  tearDown(() => db.close());

  ReportDraftPayload payload({String topic = 'Ladder safety'}) => ReportDraftPayload(
        organizationId: 'org-1',
        siteId: 'site-1',
        industryModuleCode: 'CONSTRUCTION',
        reportTypeCode: 'TOOLBOX_TALK',
        data: {'topic': topic, 'attendees': '9'},
        clientCreatedAt: DateTime.utc(2026, 8, 24),
      );

  group('saveDraft', () {
    test('creates a new report locally with the unsynced-version sentinel', () async {
      final report = await repository.saveDraft(id: 'report-1', payload: payload());

      expect(report.id, 'report-1');
      expect(report.status, ReportStatus.draft);
      expect(report.version, unsyncedVersion);
      expect(report.data['topic'], 'Ladder safety');
    });

    test('queues exactly one outbox mutation, with baseVersion null for a brand-new report', () async {
      await repository.saveDraft(id: 'report-1', payload: payload());

      final outboxRows = await db.select(db.mutationOutbox).get();
      expect(outboxRows, hasLength(1));
      expect(outboxRows.single.entityId, 'report-1');
      expect(outboxRows.single.baseVersion, isNull);
    });

    test('re-saving the same draft before it syncs collapses into one outbox entry with the latest payload', () async {
      await repository.saveDraft(id: 'report-1', payload: payload(topic: 'First draft'));
      await repository.saveDraft(id: 'report-1', payload: payload(topic: 'Second draft'));

      final outboxRows = await db.select(db.mutationOutbox).get();
      expect(outboxRows, hasLength(1));
      expect(outboxRows.single.payloadJson, contains('Second draft'));

      final stored = await repository.getById('report-1');
      expect(stored!.data['topic'], 'Second draft');
    });

    test('preserves the last-known server version (not the sentinel) across a local edit after a sync', () async {
      await repository.saveDraft(id: 'report-1', payload: payload());
      await repository.applyServerState(
        Report(
          id: 'report-1',
          organizationId: 'org-1',
          siteId: 'site-1',
          industryModuleCode: 'CONSTRUCTION',
          reportTypeCode: 'TOOLBOX_TALK',
          status: ReportStatus.draft,
          data: {'topic': 'Ladder safety', 'attendees': '9'},
          submittedBy: null,
          clientCreatedAt: null,
          serverReceivedAt: DateTime.utc(2026, 8, 24),
          version: 0,
        ),
      );

      await repository.saveDraft(id: 'report-1', payload: payload(topic: 'Edited after sync'));

      final outboxRows = await db.select(db.mutationOutbox).get();
      expect(outboxRows.single.baseVersion, 0);
    });
  });

  group('applyServerState', () {
    test('marks the row clean (not dirty) - used after a successful sync or submit', () async {
      await repository.saveDraft(id: 'report-1', payload: payload());
      expect(await repository.listDirty(), hasLength(1));

      await repository.applyServerState(
        Report(
          id: 'report-1',
          organizationId: 'org-1',
          siteId: 'site-1',
          industryModuleCode: 'CONSTRUCTION',
          reportTypeCode: 'TOOLBOX_TALK',
          status: ReportStatus.submitted,
          data: {'topic': 'Ladder safety', 'attendees': '9'},
          submittedBy: 'user-1',
          clientCreatedAt: null,
          serverReceivedAt: DateTime.utc(2026, 8, 24),
          version: 1,
        ),
      );

      expect(await repository.listDirty(), isEmpty);
      final stored = await repository.getById('report-1');
      expect(stored!.status, ReportStatus.submitted);
      expect(stored.version, 1);
    });
  });

  group('watchBySite', () {
    test('emits updated results reactively as reports are saved', () async {
      // drift's watch() emits the current (initially empty) state as soon as something
      // subscribes, then again on every write - skip that first snapshot to await the
      // one triggered by saveDraft below.
      final afterSave = repository.watchBySite('site-1').skip(1).first;

      await repository.saveDraft(id: 'report-1', payload: payload());

      final result = await afterSave;
      expect(result, hasLength(1));
      expect(result.single.id, 'report-1');
    });
  });
}
