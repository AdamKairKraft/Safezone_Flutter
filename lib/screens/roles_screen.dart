import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/compliance_status.dart';
import '../models/report.dart';
import '../models/role_type.dart';
import '../providers/reference_data_providers.dart';
import '../providers/reports_providers.dart';
import '../theme/app_theme.dart';
import '../utils/status_styles.dart';
import '../widgets/cards.dart';
import '../widgets/pill.dart';

/// Sites/organizations have no formal industry-module assignment in the backend - each
/// report just carries its own industryModuleCode. Inferring "this site's module" from
/// its most common report type is a best-effort read (documented backend gap, not
/// invented data), mirroring safezone-web's RolesPage.tsx exactly.
String? _inferIndustryModuleCode(List<Report> reports) {
  if (reports.isEmpty) return null;
  final counts = <String, int>{};
  for (final report in reports) {
    counts[report.industryModuleCode] = (counts[report.industryModuleCode] ?? 0) + 1;
  }
  return counts.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
}

class RolesScreen extends ConsumerStatefulWidget {
  const RolesScreen({super.key});

  @override
  ConsumerState<RolesScreen> createState() => _RolesScreenState();
}

class _RolesScreenState extends ConsumerState<RolesScreen> {
  RoleType? _selectedRole;

  @override
  Widget build(BuildContext context) {
    final reports = ref.watch(reportsForSiteProvider).valueOrNull ?? const [];
    final moduleCode = _inferIndustryModuleCode(reports);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Roles & Responsibilities', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          const Text('What each role is responsible for, and what they need to report.',
              style: TextStyle(fontSize: 12, color: AppColors.sub)),
          const SizedBox(height: 16),
          if (moduleCode == null)
            const NoteBanner(
              child: Text(
                "This site doesn't have any reports yet, so we can't tell which industry module it belongs to. "
                'Submit a report to populate this view.',
              ),
            )
          else
            _RolesBody(moduleCode: moduleCode, selectedRole: _selectedRole, onRoleSelected: (r) => setState(() => _selectedRole = r)),
        ],
      ),
    );
  }
}

class _RolesBody extends ConsumerWidget {
  const _RolesBody({required this.moduleCode, required this.selectedRole, required this.onRoleSelected});

  final String moduleCode;
  final RoleType? selectedRole;
  final ValueChanged<RoleType> onRoleSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rolesAsync = ref.watch(rolesForModuleProvider(moduleCode));
    final roles = rolesAsync.valueOrNull ?? const <RoleType>[];

    if (rolesAsync.isLoading) return const Center(child: Padding(padding: EdgeInsets.all(24), child: CircularProgressIndicator()));
    if (roles.isEmpty) {
      return const NoteBanner(child: Text("No roles & responsibilities catalog exists for this site's industry module yet."));
    }

    final activeRole = (selectedRole != null && roles.contains(selectedRole)) ? selectedRole! : roles.first;
    final complianceAsync = ref.watch(complianceStatusProvider);
    final complianceByType = {
      for (final c in complianceAsync.valueOrNull ?? const <ComplianceStatus>[]) c.reportTypeCode: c,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          children: roles
              .map((role) => ChoiceChip(
                    label: Text(role.label),
                    selected: role == activeRole,
                    onSelected: (_) => onRoleSelected(role),
                  ))
              .toList(),
        ),
        const SizedBox(height: 14),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _ResponsibilitiesPanel(moduleCode: moduleCode, role: activeRole)),
            const SizedBox(width: 14),
            Expanded(
              child: _RequiredReportsPanel(moduleCode: moduleCode, role: activeRole, complianceByType: complianceByType),
            ),
          ],
        ),
      ],
    );
  }
}

class _ResponsibilitiesPanel extends ConsumerWidget {
  const _ResponsibilitiesPanel({required this.moduleCode, required this.role});
  final String moduleCode;
  final RoleType role;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(responsibilitiesProvider((moduleCode: moduleCode, role: role))).valueOrNull ?? const [];
    return Panel(
      title: 'Responsibilities',
      child: items.isEmpty
          ? const EmptyHint('No responsibilities listed.')
          : Column(
              children: items
                  .map((item) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 5, right: 8),
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(border: Border.all(color: const Color(0xFFD1D5DB)), borderRadius: BorderRadius.circular(1)),
                            ),
                            Expanded(child: Text(item.description, style: const TextStyle(fontSize: 12.5))),
                          ],
                        ),
                      ))
                  .toList(),
            ),
    );
  }
}

class _RequiredReportsPanel extends ConsumerWidget {
  const _RequiredReportsPanel({required this.moduleCode, required this.role, required this.complianceByType});
  final String moduleCode;
  final RoleType role;
  final Map<String, ComplianceStatus> complianceByType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(requiredReportsProvider((moduleCode: moduleCode, role: role))).valueOrNull ?? const [];
    return Panel(
      title: 'Required reporting',
      child: items.isEmpty
          ? const EmptyHint('No required reports listed.')
          : Column(
              children: items.map((item) {
                final compliance = complianceByType[item.reportTypeCode];
                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.greyBg))),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.reportTypeName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                            Text(item.frequencyLabel, style: const TextStyle(fontSize: 10.5, color: AppColors.sub)),
                          ],
                        ),
                      ),
                      if (compliance != null)
                        Pill(label: complianceStateLabel[compliance.state]!, variant: complianceStateVariant[compliance.state]!)
                      else
                        const Pill(label: 'Not tracked here', variant: PillVariant.grey),
                    ],
                  ),
                );
              }).toList(),
            ),
    );
  }
}
