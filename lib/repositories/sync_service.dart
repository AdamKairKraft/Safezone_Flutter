import 'dart:convert';

import 'package:dio/dio.dart';

import '../local_db/database.dart';
import '../models/report.dart';
import '../models/sync.dart';
import 'reports_repository.dart';

/// Result of one sync cycle, for the UI's sync-status indicator - never hidden from the
/// user per FLUTTER_BUILD_PROMPT.md ("don't hide sync status, this is the whole point").
class SyncResult {
  const SyncResult({required this.pushedCount, required this.conflictCount, required this.pulledCount});

  final int pushedCount;
  final int conflictCount;
  final int pulledCount;

  bool get hadConflicts => conflictCount > 0;
}

/// Orchestrates the offline sync protocol exactly as specified server-side: batch every
/// queued outbox mutation into one `POST /api/sync/push`, then `GET /api/sync/pull` for
/// anything newer than the last cursor. Reports-only today (the only registered
/// syncable entity type) - reference data has its own simpler cache-when-online repo.
class SyncService {
  SyncService({required this.db, required this.dio, required this.reportsRepository});

  final AppDatabase db;
  final Dio dio;
  final ReportsRepository reportsRepository;

  Future<SyncResult> syncNow({required String organizationId, required String actorUserId}) async {
    final pushedCount = await _push(actorUserId);
    final pulledCount = await _pull(organizationId);
    return SyncResult(
      pushedCount: pushedCount.applied,
      conflictCount: pushedCount.conflicts,
      pulledCount: pulledCount,
    );
  }

  Future<({int applied, int conflicts})> _push(String actorUserId) async {
    final outboxRows = await db.select(db.mutationOutbox).get();
    if (outboxRows.isEmpty) return (applied: 0, conflicts: 0);

    final mutations = outboxRows
        .map((row) => {
              'entityType': row.entityType,
              'entityId': row.entityId,
              'payload': jsonDecode(row.payloadJson),
              'baseVersion': row.baseVersion,
            })
        .toList();

    final response = await dio.post(
      '/api/sync/push',
      data: {'mutations': mutations},
      options: Options(headers: {'X-User-Id': actorUserId}),
    );

    final results = (response.data as List<dynamic>)
        .map((e) => SyncMutationResult.fromJson(e as Map<String, dynamic>))
        .toList();

    var applied = 0;
    var conflicts = 0;
    for (final result in results) {
      if (result.entityType != 'report') continue; // only registered syncable type today

      // Both APPLIED and CONFLICT mean the push's payload is now the server's current
      // state (last-write-wins already happened server-side for CONFLICT - see
      // FLUTTER_BUILD_PROMPT.md); the only difference is a SyncConflict record also
      // exists to recover what got overwritten. Either way, this row's local edits have
      // been durably applied, so it's no longer dirty and its outbox entry is done.
      final report = _reportFromWirePayload(
        id: result.entityId,
        version: result.currentVersion,
        payload: result.currentPayload,
      );
      await reportsRepository.applyServerState(report);
      await (db.delete(db.mutationOutbox)..where((t) => t.entityId.equals(result.entityId))).go();

      if (result.status == SyncMutationStatus.applied) {
        applied++;
      } else {
        conflicts++;
      }
    }
    return (applied: applied, conflicts: conflicts);
  }

  Future<int> _pull(String organizationId) async {
    final cursor = await _readCursor(organizationId);
    final response = await dio.get(
      '/api/sync/pull',
      queryParameters: {'since': cursor.toUtc().toIso8601String()},
      options: Options(headers: {'X-Organization-Id': organizationId}),
    );

    final data = response.data as Map<String, dynamic>;
    final reportRecords = (data['report'] as List<dynamic>? ?? [])
        .map((e) => SyncPullRecord.fromJson(e as Map<String, dynamic>))
        .toList();

    for (final record in reportRecords) {
      final report = _reportFromWirePayload(id: record.id, version: record.version, payload: record.payload);
      await reportsRepository.applyServerState(report);
    }

    if (reportRecords.isNotEmpty) {
      final latest = reportRecords.map((r) => r.updatedAt).reduce((a, b) => a.isAfter(b) ? a : b);
      await _writeCursor(organizationId, latest);
    }
    return reportRecords.length;
  }

  Report _reportFromWirePayload({required String id, required int version, required Map<String, dynamic> payload}) {
    return Report(
      id: id,
      organizationId: payload['organizationId'] as String,
      siteId: payload['siteId'] as String,
      industryModuleCode: payload['industryModuleCode'] as String,
      reportTypeCode: payload['reportTypeCode'] as String,
      status: ReportStatus.fromWire(payload['status'] as String? ?? 'DRAFT'),
      data: Map<String, dynamic>.from(payload['data'] as Map),
      submittedBy: payload['submittedBy'] as String?,
      clientCreatedAt: payload['clientCreatedAt'] == null ? null : DateTime.parse(payload['clientCreatedAt'] as String),
      serverReceivedAt: DateTime.now(),
      version: version,
    );
  }

  String _cursorKey(String organizationId) => 'sync-cursor:$organizationId';

  Future<DateTime> _readCursor(String organizationId) async {
    final row =
        await (db.select(db.cacheEntries)..where((t) => t.key.equals(_cursorKey(organizationId)))).getSingleOrNull();
    if (row == null) return DateTime.utc(1970, 1, 1);
    return DateTime.parse(jsonDecode(row.valueJson) as String);
  }

  Future<void> _writeCursor(String organizationId, DateTime since) async {
    await db.into(db.cacheEntries).insertOnConflictUpdate(
          CacheEntriesCompanion.insert(
            key: _cursorKey(organizationId),
            valueJson: jsonEncode(since.toUtc().toIso8601String()),
            updatedAt: DateTime.now(),
          ),
        );
  }

  Future<int> pendingOutboxCount() async {
    final rows = await db.select(db.mutationOutbox).get();
    return rows.length;
  }
}
