import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../models/compliance_status.dart';
import '../models/report.dart';
import '../models/she_file.dart';
import '../providers/core_providers.dart';
import '../providers/reference_data_providers.dart';
import '../providers/reports_providers.dart';
import '../theme/app_theme.dart';
import '../utils/format.dart';
import '../utils/status_styles.dart';
import '../widgets/cards.dart';
import '../widgets/pill.dart';
import '../widgets/progress_bar.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authSessionProvider).user;
    if (user == null) return const SizedBox.shrink();

    final reportsAsync = ref.watch(reportsForSiteProvider);
    final complianceAsync = ref.watch(complianceStatusProvider);
    final sheFilesAsync = ref.watch(sheFilesProvider);

    final reports = reportsAsync.valueOrNull ?? const <Report>[];
    final compliance = complianceAsync.valueOrNull ?? const <ComplianceStatus>[];
    final sheFiles = sheFilesAsync.valueOrNull ?? const <SheFile>[];

    final openReports = reports.where((r) => r.status != ReportStatus.closed).toList();
    final reportTypeCount = reports.map((r) => r.reportTypeCode).toSet().length;
    final overdue = compliance.where((c) => c.state == ComplianceState.overdue).toList();
    final dueSoon = compliance.where((c) => c.state == ComplianceState.dueSoon).toList();
    final complianceScore = compliance.isEmpty
        ? null
        : ((compliance.where((c) => c.state == ComplianceState.ok).length / compliance.length) * 100).round();
    final expiringFiles =
        sheFiles.where((f) => f.status == SheFileStatus.expiringSoon || f.status == SheFileStatus.expired).toList();

    final byCategory = <String, List<ComplianceStatus>>{};
    for (final item in compliance) {
      byCategory.putIfAbsent(item.categoryCode, () => []).add(item);
    }

    final recentReports = [...reports]..sort((a, b) => b.serverReceivedAt.compareTo(a.serverReceivedAt));
    final recent = recentReports.take(5).toList();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Dashboard', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600)),
              Text(formatDateLong(DateTime.now()), style: const TextStyle(fontSize: 11.5, color: AppColors.sub)),
            ],
          ),
          const SizedBox(height: 4),
          Text('Good day, ${user.fullName.split(' ').first}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          const Text("Here's what's outstanding across your site right now.", style: TextStyle(fontSize: 12, color: AppColors.sub)),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            childAspectRatio: 1.6,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            children: [
              StatCard(label: 'Open reports', value: '${openReports.length}', sub: '$reportTypeCount report types'),
              StatCard(label: 'Overdue actions', value: '${overdue.length}', sub: 'needs attention', valueColor: AppColors.red),
              StatCard(label: 'Due soon', value: '${dueSoon.length}', sub: 'across compliance'),
              StatCard(
                label: 'Compliance score',
                value: complianceScore == null ? '—' : '$complianceScore%',
                sub: 'this site',
                valueColor: AppColors.green,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Panel(
                  title: 'Outstanding items',
                  trailing: '${overdue.length + dueSoon.length + expiringFiles.length} open',
                  child: (overdue.length + dueSoon.length + expiringFiles.length) == 0
                      ? const EmptyHint('Nothing outstanding right now.')
                      : Column(
                          children: [
                            for (final item in [...overdue, ...dueSoon])
                              _OutstandingRow(
                                title: humanize(item.reportTypeCode),
                                subtitle: humanize(item.categoryCode),
                                pillLabel: complianceStateLabel[item.state]!,
                                variant: complianceStateVariant[item.state]!,
                              ),
                            for (final file in expiringFiles)
                              _OutstandingRow(
                                title: file.title,
                                subtitle: 'SHE File · expires ${formatDate(file.expiryDate)}',
                                pillLabel: file.status == SheFileStatus.expired ? 'Expired' : 'Expiring soon',
                                variant: sheFileStatusVariant[file.status]!,
                              ),
                          ],
                        ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                flex: 2,
                child: Panel(
                  title: 'Compliance status',
                  trailing: complianceScore == null ? null : '$complianceScore%',
                  child: byCategory.isEmpty
                      ? const EmptyHint('No compliance requirements for this site.')
                      : Column(
                          children: byCategory.entries.map((entry) {
                            final percent =
                                ((entry.value.where((i) => i.state == ComplianceState.ok).length / entry.value.length) * 100)
                                    .round();
                            return LabeledProgressBar(label: humanize(entry.key), percent: percent);
                          }).toList(),
                        ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Panel(
                  title: 'Recent reports',
                  child: recent.isEmpty
                      ? const EmptyHint('No reports yet for this site.')
                      : Column(
                          children: recent
                              .map((report) => Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 6),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text.rich(
                                            TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: reportSummary(report.reportTypeCode, report.data),
                                                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                                                ),
                                                TextSpan(
                                                  text: '  ${formatDate(report.serverReceivedAt)}',
                                                  style: const TextStyle(fontSize: 11, color: AppColors.sub),
                                                ),
                                              ],
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Pill(label: humanize(report.status.wireValue), variant: reportStatusVariant[report.status]!),
                                      ],
                                    ),
                                  ))
                              .toList(),
                        ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                flex: 2,
                child: Panel(
                  title: 'Quick actions',
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(onPressed: () => context.go('/reports/new'), child: const Text('+ New report')),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(onPressed: () => context.go('/she-files'), child: const Text('Upload SHE file')),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(onPressed: () => context.go('/compliance'), child: const Text('View compliance tracker')),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OutstandingRow extends StatelessWidget {
  const _OutstandingRow({required this.title, required this.subtitle, required this.pillLabel, required this.variant});

  final String title;
  final String subtitle;
  final String pillLabel;
  final PillVariant variant;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.greyBg))),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12.5), overflow: TextOverflow.ellipsis),
                Text(subtitle, style: const TextStyle(fontSize: 11, color: AppColors.sub)),
              ],
            ),
          ),
          Pill(label: pillLabel, variant: variant),
        ],
      ),
    );
  }
}
