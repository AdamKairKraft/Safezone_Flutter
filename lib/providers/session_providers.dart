import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/organization.dart';
import 'core_providers.dart';
import 'reference_data_providers.dart';
import 'reports_providers.dart';

/// The site the whole app is currently scoped to - mirrors safezone-web's AppShell,
/// which auto-selects the org's first site and offers a switcher when there's more
/// than one. In-memory only for now (resets on app restart to "first site again"),
/// which is an acceptable simplification for a single-site-per-tablet deployment.
final selectedSiteIdProvider = StateProvider<String?>((ref) => null);

final sitesProvider = FutureProvider<List<Site>>((ref) async {
  final user = ref.watch(authSessionProvider).user;
  if (user == null) return const [];

  final sites = await ref.watch(referenceDataRepositoryProvider).listSites(user.organizationId);

  final siteNotifier = ref.read(selectedSiteIdProvider.notifier);
  if (siteNotifier.state == null && sites.isNotEmpty) {
    siteNotifier.state = sites.first.id;
  }
  return sites;
});

/// Best-effort "which industry module is this site in", inferred from its most common
/// existing report type - falling back to the first module in the catalog if the site
/// has no reports yet, so report creation still works for a brand-new site. Mirrors
/// safezone-web's useSiteIndustryModuleCode.ts exactly (including the fallback, which
/// the stricter Roles-screen inference deliberately omits - see roles_screen.dart).
final siteIndustryModuleCodeProvider = Provider<String?>((ref) {
  final reports = ref.watch(reportsForSiteProvider).valueOrNull ?? const [];
  if (reports.isNotEmpty) {
    final counts = <String, int>{};
    for (final report in reports) {
      counts[report.industryModuleCode] = (counts[report.industryModuleCode] ?? 0) + 1;
    }
    return counts.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
  }
  final modules = ref.watch(industryModulesProvider).valueOrNull ?? const [];
  return modules.isEmpty ? null : modules.first.code;
});
