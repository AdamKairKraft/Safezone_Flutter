import 'dart:convert';

import 'package:dio/dio.dart';

import '../local_db/database.dart';
import '../models/compliance_status.dart';
import '../models/industry_module.dart';
import '../models/organization.dart';
import '../models/role_type.dart';
import '../models/she_file.dart';
import '../models/sync.dart';
import '../models/user.dart';
import '../network/api_client.dart';

/// Thrown when there's no cached copy for something and the device is offline - the UI
/// should show a clear "unavailable offline" state for this, never a generic error
/// screen (FLUTTER_BUILD_PROMPT.md).
class OfflineUnavailableException implements Exception {
  const OfflineUnavailableException(this.what);
  final String what;

  @override
  String toString() => '$what is not available offline (no cached copy yet)';
}

/// All read/cache-only reference data: organizations, sites, users, industry modules,
/// report-type definitions, the roles/responsibilities/required-reports catalog,
/// compliance status, SHE files, and pending conflicts. None of these are part of the
/// offline sync protocol (that's SyncRepository, for reports only) - they're fetched
/// opportunistically when online and served from cache otherwise.
class ReferenceDataRepository {
  ReferenceDataRepository({required this.dio, required this.db});

  final Dio dio;
  final AppDatabase db;

  Future<T> _cached<T>({
    required String key,
    required Future<dynamic> Function() fetchRaw,
    required T Function(dynamic json) decode,
    required String what,
  }) async {
    try {
      final raw = await fetchRaw();
      await _writeCache(key, raw);
      return decode(raw);
    } on DioException {
      final cached = await _readCache(key);
      if (cached == null) throw OfflineUnavailableException(what);
      return decode(cached);
    }
  }

  Future<void> _writeCache(String key, dynamic value) async {
    await db.into(db.cacheEntries).insertOnConflictUpdate(
          CacheEntriesCompanion.insert(key: key, valueJson: jsonEncode(value), updatedAt: DateTime.now()),
        );
  }

  Future<dynamic> _readCache(String key) async {
    final row = await (db.select(db.cacheEntries)..where((t) => t.key.equals(key))).getSingleOrNull();
    if (row == null) return null;
    return jsonDecode(row.valueJson);
  }

  Future<Organization> getOrganization(String id) => _cached(
        key: 'organization:$id',
        fetchRaw: () async => (await dio.get('/api/organizations/$id')).data,
        decode: (json) => Organization.fromJson(json as Map<String, dynamic>),
        what: 'This organization',
      );

  Future<List<Site>> listSites(String organizationId) => _cached(
        key: 'sites:$organizationId',
        fetchRaw: () async => (await dio.get('/api/sites', queryParameters: {'organizationId': organizationId})).data,
        decode: (json) => (json as List).map((e) => Site.fromJson(e as Map<String, dynamic>)).toList(),
        what: 'The site list',
      );

  Future<AppUser> getMe() => _cached(
        key: 'user:me',
        fetchRaw: () async => (await dio.get('/api/users/me')).data,
        decode: (json) => AppUser.fromJson(json as Map<String, dynamic>),
        what: 'Your profile',
      );

  Future<List<AppUser>> listUsers(String organizationId) => _cached(
        key: 'users:$organizationId',
        fetchRaw: () async => (await dio.get('/api/users', queryParameters: {'organizationId': organizationId})).data,
        decode: (json) => (json as List).map((e) => AppUser.fromJson(e as Map<String, dynamic>)).toList(),
        what: 'The user list',
      );

  Future<List<IndustryModule>> listIndustryModules() => _cached(
        key: 'industry-modules',
        fetchRaw: () async => (await dio.get('/api/industry-modules')).data,
        decode: (json) => (json as List).map((e) => IndustryModule.fromJson(e as Map<String, dynamic>)).toList(),
        what: 'The industry module catalog',
      );

  /// Cached aggressively per FLUTTER_BUILD_PROMPT.md: the report builder needs
  /// formSchema to render its dynamic form fully offline.
  Future<List<ReportTypeDefinition>> listReportTypes(String industryModuleCode) => _cached(
        key: 'report-types:$industryModuleCode',
        fetchRaw: () async => (await dio.get('/api/industry-modules/$industryModuleCode/report-types')).data,
        decode: (json) =>
            (json as List).map((e) => ReportTypeDefinition.fromJson(e as Map<String, dynamic>)).toList(),
        what: 'Report types for this industry module',
      );

  /// Only CONSTRUCTION has seeded catalog data today; other modules legitimately return
  /// empty lists - callers should render an empty state, not treat that as an error.
  Future<List<RoleType>> listRolesForModule(String industryModuleCode) => _cached(
        key: 'roles:$industryModuleCode',
        fetchRaw: () async => (await dio.get('/api/industry-modules/$industryModuleCode/roles')).data,
        decode: (json) => (json as List).map((e) => RoleType.fromWire(e as String)).toList(),
        what: 'The role catalog for this industry module',
      );

  Future<List<RoleResponsibility>> listResponsibilities(String industryModuleCode, RoleType role) => _cached(
        key: 'responsibilities:$industryModuleCode:${role.wireValue}',
        fetchRaw: () async =>
            (await dio.get('/api/industry-modules/$industryModuleCode/roles/${role.wireValue}/responsibilities'))
                .data,
        decode: (json) =>
            (json as List).map((e) => RoleResponsibility.fromJson(e as Map<String, dynamic>)).toList(),
        what: 'Responsibilities for this role',
      );

  Future<List<RoleRequiredReport>> listRequiredReports(String industryModuleCode, RoleType role) => _cached(
        key: 'required-reports:$industryModuleCode:${role.wireValue}',
        fetchRaw: () async =>
            (await dio.get('/api/industry-modules/$industryModuleCode/roles/${role.wireValue}/required-reports'))
                .data,
        decode: (json) =>
            (json as List).map((e) => RoleRequiredReport.fromJson(e as Map<String, dynamic>)).toList(),
        what: 'Required reports for this role',
      );

  Future<List<ComplianceStatus>> listComplianceStatus(String siteId) => _cached(
        key: 'compliance:$siteId',
        fetchRaw: () async => (await dio.get('/api/compliance/status', queryParameters: {'siteId': siteId})).data,
        decode: (json) => (json as List).map((e) => ComplianceStatus.fromJson(e as Map<String, dynamic>)).toList(),
        what: 'Compliance status for this site',
      );

  Future<List<SheFile>> listSheFiles(String organizationId) => _cached(
        key: 'she-files:$organizationId',
        fetchRaw: () async =>
            (await dio.get('/api/she-files', queryParameters: {'organizationId': organizationId})).data,
        decode: (json) => (json as List).map((e) => SheFile.fromJson(e as Map<String, dynamic>)).toList(),
        what: 'The SHE file register',
      );

  /// Metadata-only registration: the backend has no binary upload endpoint yet, so this
  /// records a placeholder storageKey rather than actually storing file content - same
  /// simplification safezone-web makes, surfaced to the user in the UI, not hidden.
  Future<SheFile> registerSheFile({
    required String id,
    required String organizationId,
    required String? siteId,
    required SheFileCategory category,
    required String title,
    required String? ownerUserId,
    required String storageKey,
    required DateTime? expiryDate,
  }) async {
    final response = await dio.post('/api/she-files', data: {
      'id': id,
      'organizationId': organizationId,
      'siteId': siteId,
      'category': category.wireValue,
      'title': title,
      'ownerUserId': ownerUserId,
      'storageKey': storageKey,
      'expiryDate': expiryDate?.toIso8601String().split('T').first,
    });
    return SheFile.fromJson(response.data as Map<String, dynamic>);
  }

  Future<List<SyncConflict>> listPendingConflicts() => _cached(
        key: 'conflicts:pending',
        fetchRaw: () async => (await dio.get('/api/conflicts')).data,
        decode: (json) => (json as List).map((e) => SyncConflict.fromJson(e as Map<String, dynamic>)).toList(),
        what: 'Pending sync conflicts',
      );

  /// Online-only, like everything conflict-resolution related - a conflict can only be
  /// reviewed and resolved once connectivity is back anyway (its data comes from the
  /// server, and the resolution needs to be recorded there).
  Future<SyncConflict> resolveConflict({
    required String conflictId,
    required ConflictResolution resolution,
    Map<String, dynamic>? mergedPayload,
  }) async {
    final response = await dio.post(
      '/api/conflicts/$conflictId/resolve',
      data: {'resolution': resolution.wireValue, 'mergedPayload': mergedPayload},
      options: Options(headers: {'Idempotency-Key': newIdempotencyKey()}),
    );
    return SyncConflict.fromJson(response.data as Map<String, dynamic>);
  }
}
