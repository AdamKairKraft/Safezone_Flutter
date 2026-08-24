import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:drift/drift.dart';

import '../local_db/database.dart';
import '../models/report.dart';
import '../network/api_client.dart';

/// Sentinel for `ReportsCache.version` meaning "created locally, never confirmed by the
/// server yet" - distinct from a real server version (which starts at 0), so the push
/// mutation knows to send `baseVersion: null` (brand-new) rather than a stale 0.
const unsyncedVersion = -1;

/// Local-first CRUD for reports, the one entity that's actually offline-syncable
/// (FLUTTER_BUILD_PROMPT.md). Every write goes to the local drift cache first and marks
/// the row dirty + queues (or updates) one outbox mutation; SyncService is what actually
/// talks to the server. Submitting is the one exception - explicitly online-only, so it
/// calls the backend directly rather than going through the outbox (see [submitReport]).
class ReportsRepository {
  ReportsRepository({required this.db, required this.dio});

  final AppDatabase db;
  final Dio dio;

  Stream<List<Report>> watchBySite(String siteId) {
    final query = db.select(db.reportsCache)..where((t) => t.siteId.equals(siteId));
    return query.watch().map((rows) => rows.map(_toModel).toList());
  }

  Future<Report?> getById(String id) async {
    final row = await (db.select(db.reportsCache)..where((t) => t.id.equals(id))).getSingleOrNull();
    return row == null ? null : _toModel(row);
  }

  /// Creates or updates a draft locally, then queues it for the next sync push. Callers
  /// pass the same client-generated id both for a brand-new report and for editing an
  /// existing one - matching the backend's PUT /api/reports/{id} semantics.
  Future<Report> saveDraft({required String id, required ReportDraftPayload payload}) async {
    final existing = await getById(id);
    final version = existing?.version ?? unsyncedVersion;

    await db.into(db.reportsCache).insertOnConflictUpdate(
          ReportsCacheCompanion.insert(
            id: id,
            organizationId: payload.organizationId,
            siteId: payload.siteId,
            industryModuleCode: payload.industryModuleCode,
            reportTypeCode: payload.reportTypeCode,
            status: existing?.status.wireValue ?? ReportStatus.draft.wireValue,
            dataJson: jsonEncode(payload.data),
            submittedBy: Value(existing?.submittedBy),
            clientCreatedAt: Value(payload.clientCreatedAt ?? existing?.clientCreatedAt),
            serverReceivedAt: existing?.serverReceivedAt ?? DateTime.now(),
            version: version,
            dirty: const Value(true),
          ),
        );

    await _enqueueOutboxEntry(entityId: id, payload: payload, baseVersion: version == unsyncedVersion ? null : version);

    return (await getById(id))!;
  }

  Future<void> _enqueueOutboxEntry({
    required String entityId,
    required ReportDraftPayload payload,
    required int? baseVersion,
  }) {
    // Deterministic outbox row id (not a fresh uuid per save) so repeated edits before
    // the next sync collapse into one pending mutation carrying the latest content,
    // rather than piling up a queue of superseded drafts.
    final outboxId = 'report:$entityId';
    return db.into(db.mutationOutbox).insertOnConflictUpdate(
          MutationOutboxCompanion.insert(
            id: outboxId,
            entityType: 'report',
            entityId: entityId,
            payloadJson: jsonEncode(payload.toJson()),
            baseVersion: Value(baseVersion),
            createdAt: DateTime.now(),
          ),
        );
  }

  /// Online-only: directly PUTs the latest local content (bypassing the outbox, since
  /// this whole flow requires connectivity anyway) then POSTs the submit action. On
  /// success, clears this report's dirty flag and outbox entry - there's nothing left to
  /// sync, the server now has exactly what was just submitted.
  Future<Report> submitReport(String id) async {
    final local = await getById(id);
    if (local == null) {
      throw StateError('Cannot submit report $id: no local draft found');
    }

    await dio.put('/api/reports/$id', data: {
      'organizationId': local.organizationId,
      'siteId': local.siteId,
      'industryModuleCode': local.industryModuleCode,
      'reportTypeCode': local.reportTypeCode,
      'data': local.data,
      if (local.clientCreatedAt != null) 'clientCreatedAt': local.clientCreatedAt!.toUtc().toIso8601String(),
    });

    final submitResponse = await dio.post(
      '/api/reports/$id/submit',
      options: Options(headers: {'Idempotency-Key': newIdempotencyKey()}),
    );
    final submitted = Report.fromJson(submitResponse.data as Map<String, dynamic>);

    await _applyServerState(submitted);
    await (db.delete(db.mutationOutbox)..where((t) => t.id.equals('report:$id'))).go();
    return submitted;
  }

  /// Overwrites the local cache with server-confirmed state (used by both submit and the
  /// sync push/pull cycle) and clears dirty, since this row now matches the server.
  Future<void> _applyServerState(Report report) async {
    await db.into(db.reportsCache).insertOnConflictUpdate(
          ReportsCacheCompanion.insert(
            id: report.id,
            organizationId: report.organizationId,
            siteId: report.siteId,
            industryModuleCode: report.industryModuleCode,
            reportTypeCode: report.reportTypeCode,
            status: report.status.wireValue,
            dataJson: jsonEncode(report.data),
            submittedBy: Value(report.submittedBy),
            clientCreatedAt: Value(report.clientCreatedAt),
            serverReceivedAt: report.serverReceivedAt,
            version: report.version,
            dirty: const Value(false),
          ),
        );
  }

  /// Used by SyncService after a successful push/pull to reconcile local state -
  /// public so the sync layer (a separate class, to keep push/pull orchestration out of
  /// this CRUD-focused repository) can call it.
  Future<void> applyServerState(Report report) => _applyServerState(report);

  Future<List<Report>> listDirty() async {
    final rows = await (db.select(db.reportsCache)..where((t) => t.dirty.equals(true))).get();
    return rows.map(_toModel).toList();
  }

  Report _toModel(ReportsCacheData row) => Report(
        id: row.id,
        organizationId: row.organizationId,
        siteId: row.siteId,
        industryModuleCode: row.industryModuleCode,
        reportTypeCode: row.reportTypeCode,
        status: ReportStatus.fromWire(row.status),
        data: Map<String, dynamic>.from(jsonDecode(row.dataJson) as Map),
        submittedBy: row.submittedBy,
        clientCreatedAt: row.clientCreatedAt,
        serverReceivedAt: row.serverReceivedAt,
        version: row.version,
      );
}
