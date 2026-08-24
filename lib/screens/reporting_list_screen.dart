import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../models/report.dart';
import '../providers/reference_data_providers.dart';
import '../providers/reports_providers.dart';
import '../theme/app_theme.dart';
import '../utils/format.dart';
import '../utils/status_styles.dart';
import '../widgets/pill.dart';

String _typeBadge(String code) {
  final letters = code.split('_').where((w) => w.isNotEmpty).map((w) => w[0]).join();
  return letters.length > 2 ? letters.substring(0, 2).toUpperCase() : letters.toUpperCase();
}

class ReportingListScreen extends ConsumerStatefulWidget {
  const ReportingListScreen({super.key});

  @override
  ConsumerState<ReportingListScreen> createState() => _ReportingListScreenState();
}

class _ReportingListScreenState extends ConsumerState<ReportingListScreen> {
  String _typeFilter = 'ALL';
  String _statusFilter = 'ALL';

  @override
  Widget build(BuildContext context) {
    final reports = ref.watch(reportsForSiteProvider).valueOrNull ?? const <Report>[];
    final users = ref.watch(usersProvider).valueOrNull ?? const [];
    final usersById = {for (final u in users) u.id: u.fullName};

    final moduleCode = reports.isNotEmpty ? reports.first.industryModuleCode : null;
    final reportTypes = moduleCode == null ? const [] : (ref.watch(reportTypesProvider(moduleCode)).valueOrNull ?? const []);

    final filtered = reports.where((r) {
      final typeOk = _typeFilter == 'ALL' || r.reportTypeCode == _typeFilter;
      final statusOk = _statusFilter == 'ALL' || r.status.wireValue == _statusFilter;
      return typeOk && statusOk;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Reporting', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600)),
            ElevatedButton(onPressed: () => context.go('/reports/new'), child: const Text('+ New report')),
          ],
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _FilterChip(label: 'All', selected: _typeFilter == 'ALL', onTap: () => setState(() => _typeFilter = 'ALL')),
              for (final rt in reportTypes)
                _FilterChip(label: rt.name, selected: _typeFilter == rt.code, onTap: () => setState(() => _typeFilter = rt.code)),
            ],
          ),
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (final s in const [('ALL', 'All'), ('DRAFT', 'Draft'), ('SUBMITTED', 'Submitted'), ('UNDER_REVIEW', 'Under Review'), ('CLOSED', 'Closed')])
                _FilterChip(label: s.$2, selected: _statusFilter == s.$1, small: true, onTap: () => setState(() => _statusFilter = s.$1)),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: filtered.isEmpty
              ? const Center(child: Text('No reports match these filters.', style: TextStyle(color: AppColors.sub, fontSize: 12)))
              : ListView.separated(
                  itemCount: filtered.length,
                  separatorBuilder: (_, _) => const Divider(),
                  itemBuilder: (context, index) {
                    final report = filtered[index];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Container(
                        width: 26,
                        height: 20,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(color: AppColors.greyBg, borderRadius: BorderRadius.circular(4)),
                        child: Text(_typeBadge(report.reportTypeCode), style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF475569))),
                      ),
                      title: Text(reportSummary(report.reportTypeCode, report.data), style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                      subtitle: Text(humanize(report.reportTypeCode), style: const TextStyle(fontSize: 10.5, color: AppColors.sub)),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(report.submittedBy != null ? (usersById[report.submittedBy] ?? '—') : '—',
                              style: const TextStyle(fontSize: 11, color: AppColors.sub)),
                          const SizedBox(width: 12),
                          Text(formatDate(report.serverReceivedAt), style: const TextStyle(fontSize: 11, color: AppColors.sub)),
                          const SizedBox(width: 12),
                          Pill(label: humanize(report.status.wireValue), variant: reportStatusVariant[report.status]!),
                        ],
                      ),
                      onTap: () => context.go('/reports/${report.id}/edit'),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label, required this.selected, required this.onTap, this.small = false});

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool small;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: ChoiceChip(
        label: Text(label, style: TextStyle(fontSize: small ? 11 : 12)),
        selected: selected,
        visualDensity: small ? VisualDensity.compact : VisualDensity.standard,
        onSelected: (_) => onTap(),
      ),
    );
  }
}
