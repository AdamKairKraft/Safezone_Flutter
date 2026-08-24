import 'package:drift/drift.dart';

/// The one entity that's actually offline-syncable (FLUTTER_BUILD_PROMPT.md). `dirty`
/// marks a row with local edits not yet pushed; `baseVersion` is the last version this
/// client knows the server had, sent as `sync/push`'s baseVersion so the server can
/// detect a conflict. `dataJson` is the report-type-specific form payload, stored as raw
/// JSON text (sqlite has no native JSON column).
class ReportsCache extends Table {
  TextColumn get id => text()();
  TextColumn get organizationId => text()();
  TextColumn get siteId => text()();
  TextColumn get industryModuleCode => text()();
  TextColumn get reportTypeCode => text()();
  TextColumn get status => text()();
  TextColumn get dataJson => text()();
  TextColumn get submittedBy => text().nullable()();
  DateTimeColumn get clientCreatedAt => dateTime().nullable()();
  DateTimeColumn get serverReceivedAt => dateTime()();
  IntColumn get version => integer()();
  BoolColumn get dirty => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Queued local mutations waiting for connectivity. One row per report create/edit made
/// offline (or made online but that failed to reach the server); flushed in one batched
/// `POST /api/sync/push` call on reconnect rather than one request per mutation.
class MutationOutbox extends Table {
  TextColumn get id => text()(); // outbox row id, not the entity's id
  TextColumn get entityType => text()();
  TextColumn get entityId => text()();
  TextColumn get payloadJson => text()();
  IntColumn get baseVersion => integer().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Generic read-when-online/view-when-offline cache for every reference data list the
/// app fetches but never edits locally: organizations, sites, users, industry modules,
/// report-type definitions per module, the roles/responsibilities/required-reports
/// catalog, compliance status per site, SHE files per org, pending conflicts, and the
/// per-organization sync cursor. All of these share the same access pattern - "fetch the
/// whole list when online, cache it, filter/render client-side, show it (possibly stale)
/// when offline" - so one key/value JSON-blob table covers them instead of eight
/// near-identical tables. `key` encodes what it is, e.g. "sites:orgId",
/// "report-types:moduleCode", "sync-cursor:orgId".
class CacheEntries extends Table {
  TextColumn get key => text()();
  TextColumn get valueJson => text()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {key};
}
