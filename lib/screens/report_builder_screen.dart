import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../models/industry_module.dart';
import '../models/report.dart';
import '../providers/connectivity_providers.dart';
import '../providers/core_providers.dart';
import '../providers/reference_data_providers.dart';
import '../providers/reports_providers.dart';
import '../providers/session_providers.dart';
import '../theme/app_theme.dart';
import '../widgets/dynamic_field.dart';

const _uuid = Uuid();

/// The one screen that has to work fully offline once report types are cached
/// (FLUTTER_BUILD_PROMPT.md): drafting/editing goes through the local-first
/// ReportsRepository regardless of connectivity, and only "Submit for review" is gated
/// on being online - disabled outright rather than silently queued, so the user is never
/// misled into thinking an offline submit went through.
class ReportBuilderScreen extends ConsumerStatefulWidget {
  const ReportBuilderScreen({super.key, required this.existingReportId});

  final String? existingReportId;

  @override
  ConsumerState<ReportBuilderScreen> createState() => _ReportBuilderScreenState();
}

class _ReportBuilderScreenState extends ConsumerState<ReportBuilderScreen> {
  late final String reportId = widget.existingReportId ?? _uuid.v4();
  bool get isEditing => widget.existingReportId != null;

  String? _typeCode;
  Map<String, dynamic> _formData = {};
  bool _loadedExisting = false;
  String? _error;
  _Status _status = _Status.idle;

  @override
  Widget build(BuildContext context) {
    final moduleCode = ref.watch(siteIndustryModuleCodeProvider);
    if (moduleCode == null) {
      return const Center(child: Text('Loading report types…', style: TextStyle(fontSize: 12, color: AppColors.sub)));
    }

    final reportTypesAsync = ref.watch(reportTypesProvider(moduleCode));
    final reportTypes = reportTypesAsync.valueOrNull ?? const <ReportTypeDefinition>[];

    if (isEditing && !_loadedExisting) {
      final existing = ref.watch(reportByIdProvider(reportId)).valueOrNull;
      if (existing != null) {
        _loadedExisting = true;
        _typeCode = existing.reportTypeCode;
        _formData = Map<String, dynamic>.from(existing.data);
      }
    }

    if (reportTypes.isEmpty) {
      return const Center(child: Text('Loading report types…', style: TextStyle(fontSize: 12, color: AppColors.sub)));
    }
    _typeCode ??= reportTypes.first.code;

    final activeType = reportTypes.firstWhere((rt) => rt.code == _typeCode, orElse: () => reportTypes.first);
    final missingRequired = activeType.fields.where((f) {
      final value = _formData[f.name];
      return f.required && (value == null || (value is String && value.isEmpty));
    }).length;

    final isOnline = ref.watch(isOnlineProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(isEditing ? 'Edit report' : 'New report', style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w600)),
            const Text('Fields update to match the report type', style: TextStyle(fontSize: 11.5, color: AppColors.sub)),
          ],
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 8,
          children: reportTypes
              .map((rt) => ChoiceChip(
                    label: Text(rt.name),
                    selected: rt.code == _typeCode,
                    onSelected: (_) => setState(() {
                      _typeCode = rt.code;
                      _formData = {};
                    }),
                  ))
              .toList(),
        ),
        const SizedBox(height: 16),
        Text(activeType.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        Expanded(
          child: SingleChildScrollView(
            child: GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 4.2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 14,
              children: [
                for (final field in activeType.fields)
                  DynamicFieldInput(
                    field: field,
                    value: _formData[field.name],
                    onChanged: (value) => setState(() => _formData = {..._formData, field.name: value}),
                  ),
              ],
            ),
          ),
        ),
        if (_error != null)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(color: AppColors.redBg, borderRadius: BorderRadius.circular(6)),
            child: Text(_error!, style: const TextStyle(fontSize: 11.5, color: AppColors.red)),
          ),
        Container(
          padding: const EdgeInsets.only(top: 14),
          decoration: const BoxDecoration(border: Border(top: BorderSide(color: AppColors.border))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                !isOnline
                    ? 'Offline — draft saves locally, submit once back online'
                    : (missingRequired > 0 ? '$missingRequired field${missingRequired > 1 ? 's' : ''} required' : 'Ready to submit'),
                style: const TextStyle(fontSize: 11, color: AppColors.sub),
              ),
              Row(
                children: [
                  OutlinedButton(
                    onPressed: _status == _Status.idle ? _handleSaveDraft : null,
                    child: Text(_status == _Status.saving ? 'Saving…' : 'Save draft'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: (_status == _Status.idle && missingRequired == 0 && isOnline) ? _handleSubmit : null,
                    child: Text(_status == _Status.submitting ? 'Submitting…' : 'Submit for review'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _handleSaveDraft() async {
    setState(() {
      _error = null;
      _status = _Status.saving;
    });
    try {
      await _saveDraft();
    } catch (_) {
      setState(() => _error = "Couldn't save draft. Check your connection and try again.");
    } finally {
      if (mounted) setState(() => _status = _Status.idle);
    }
  }

  Future<void> _handleSubmit() async {
    setState(() {
      _error = null;
      _status = _Status.submitting;
    });
    try {
      await _saveDraft();
      await ref.read(reportEditorControllerProvider.notifier).submit(reportId);
      if (mounted) context.go('/reports');
    } catch (_) {
      if (mounted) {
        setState(() {
          _error = "Couldn't submit this report. Check your connection and try again.";
          _status = _Status.idle;
        });
      }
    }
  }

  Future<void> _saveDraft() async {
    final user = ref.read(authSessionProvider).user!;
    final siteId = ref.read(selectedSiteIdProvider)!;
    final moduleCode = ref.read(siteIndustryModuleCodeProvider)!;

    await ref.read(reportEditorControllerProvider.notifier).saveDraft(
          id: reportId,
          payload: ReportDraftPayload(
            organizationId: user.organizationId,
            siteId: siteId,
            industryModuleCode: moduleCode,
            reportTypeCode: _typeCode!,
            data: _formData,
            clientCreatedAt: DateTime.now(),
          ),
        );
  }
}

enum _Status { idle, saving, submitting }
