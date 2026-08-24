import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/compliance_status.dart';
import '../models/industry_module.dart';
import '../models/role_type.dart';
import '../models/she_file.dart';
import '../models/sync.dart';
import 'core_providers.dart';
import 'session_providers.dart';

final industryModulesProvider = FutureProvider<List<IndustryModule>>((ref) {
  return ref.watch(referenceDataRepositoryProvider).listIndustryModules();
});

final reportTypesProvider = FutureProvider.family<List<ReportTypeDefinition>, String>((ref, industryModuleCode) {
  return ref.watch(referenceDataRepositoryProvider).listReportTypes(industryModuleCode);
});

final rolesForModuleProvider = FutureProvider.family<List<RoleType>, String>((ref, industryModuleCode) {
  return ref.watch(referenceDataRepositoryProvider).listRolesForModule(industryModuleCode);
});

typedef ModuleRole = ({String moduleCode, RoleType role});

final responsibilitiesProvider = FutureProvider.family<List<RoleResponsibility>, ModuleRole>((ref, key) {
  return ref.watch(referenceDataRepositoryProvider).listResponsibilities(key.moduleCode, key.role);
});

final requiredReportsProvider = FutureProvider.family<List<RoleRequiredReport>, ModuleRole>((ref, key) {
  return ref.watch(referenceDataRepositoryProvider).listRequiredReports(key.moduleCode, key.role);
});

final complianceStatusProvider = FutureProvider<List<ComplianceStatus>>((ref) {
  final siteId = ref.watch(selectedSiteIdProvider);
  if (siteId == null) return Future.value(const []);
  return ref.watch(referenceDataRepositoryProvider).listComplianceStatus(siteId);
});

final sheFilesProvider = FutureProvider<List<SheFile>>((ref) {
  final user = ref.watch(authSessionProvider).user;
  if (user == null) return Future.value(const []);
  return ref.watch(referenceDataRepositoryProvider).listSheFiles(user.organizationId);
});

final usersProvider = FutureProvider<List<AppUserSummary>>((ref) async {
  final user = ref.watch(authSessionProvider).user;
  if (user == null) return const [];
  final users = await ref.watch(referenceDataRepositoryProvider).listUsers(user.organizationId);
  return users.map((u) => (id: u.id, fullName: u.fullName)).toList();
});

/// Just what the UI needs for "submitted by" lookups - avoids pulling the full AppUser
/// model (with roles etc.) through a provider that only ever renders a name.
typedef AppUserSummary = ({String id, String fullName});

final pendingConflictsProvider = FutureProvider<List<SyncConflict>>((ref) {
  return ref.watch(referenceDataRepositoryProvider).listPendingConflicts();
});
