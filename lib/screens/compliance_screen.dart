import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/compliance_status.dart';
import '../providers/reference_data_providers.dart';
import '../theme/app_theme.dart';
import '../utils/format.dart';
import '../utils/status_styles.dart';
import '../widgets/cards.dart';
import '../widgets/pill.dart';
import '../widgets/progress_bar.dart';

const _stateOrder = {ComplianceState.overdue: 0, ComplianceState.dueSoon: 1, ComplianceState.ok: 2};

/// Mirrors safezone-web's CompliancePage.tsx nextDueLabel(), which itself mirrors the
/// backend's ComplianceRequirement.deriveState() - display-only approximation.
String _nextDueLabel(ComplianceStatus item) {
  if (item.frequency == ComplianceFrequency.asNeeded) return 'As needed';
  if (item.lastCompletedAt == null) return 'Never completed';
  final intervalDays = item.frequency == ComplianceFrequency.weekly ? 7 : 30;
  final nextDue = item.lastCompletedAt!.add(Duration(days: intervalDays));
  final daysRemaining = nextDue.difference(DateTime.now()).inDays;
  if (daysRemaining < 0) {
    final overdue = -daysRemaining;
    return '$overdue day${overdue == 1 ? '' : 's'} overdue';
  }
  if (daysRemaining == 0) return 'Due today';
  return 'Due in $daysRemaining day${daysRemaining == 1 ? '' : 's'}';
}

String _frequencyLabel(ComplianceFrequency frequency) =>
    frequency == ComplianceFrequency.asNeeded ? 'As needed' : humanize(frequency.wireValue);

class ComplianceScreen extends ConsumerWidget {
  const ComplianceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(complianceStatusProvider).valueOrNull ?? const <ComplianceStatus>[];
    final sorted = [...items]..sort((a, b) => _stateOrder[a.state]!.compareTo(_stateOrder[b.state]!));

    final byCategory = <String, List<ComplianceStatus>>{};
    for (final item in items) {
      byCategory.putIfAbsent(item.categoryCode, () => []).add(item);
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Compliance Tracker', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Panel(
                  title: 'Upcoming & overdue',
                  child: sorted.isEmpty
                      ? const EmptyHint('No compliance requirements for this site yet.')
                      : Column(
                          children: sorted
                              .map((item) => Container(
                                    padding: const EdgeInsets.symmetric(vertical: 9),
                                    decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.greyBg))),
                                    child: Row(
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.only(right: 10),
                                          width: 6,
                                          height: 6,
                                          decoration: const BoxDecoration(color: Color(0xFFD1D5DB), shape: BoxShape.circle),
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(humanize(item.reportTypeCode), style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12), overflow: TextOverflow.ellipsis),
                                              Text('${humanize(item.categoryCode)} · ${_frequencyLabel(item.frequency)}',
                                                  style: const TextStyle(fontSize: 10.5, color: AppColors.sub)),
                                            ],
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Pill(label: complianceStateLabel[item.state]!, variant: complianceStateVariant[item.state]!),
                                            const SizedBox(height: 3),
                                            Text(_nextDueLabel(item), style: const TextStyle(fontSize: 10, color: AppColors.sub)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ))
                              .toList(),
                        ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Panel(
                  title: 'Compliance by category',
                  child: byCategory.isEmpty
                      ? const EmptyHint('No compliance requirements for this site yet.')
                      : Column(
                          children: byCategory.entries.map((entry) {
                            final percent = ((entry.value.where((i) => i.state == ComplianceState.ok).length / entry.value.length) * 100).round();
                            return LabeledProgressBar(label: humanize(entry.key), percent: percent);
                          }).toList(),
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
