import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../models/she_file.dart';
import '../providers/core_providers.dart';
import '../providers/reference_data_providers.dart';
import '../providers/session_providers.dart';
import '../theme/app_theme.dart';
import '../utils/format.dart';
import '../utils/status_styles.dart';
import '../widgets/cards.dart';
import '../widgets/pill.dart';

const _uuid = Uuid();

class SheFilesScreen extends ConsumerStatefulWidget {
  const SheFilesScreen({super.key});

  @override
  ConsumerState<SheFilesScreen> createState() => _SheFilesScreenState();
}

class _SheFilesScreenState extends ConsumerState<SheFilesScreen> {
  SheFileCategory? _categoryFilter;

  @override
  Widget build(BuildContext context) {
    final filesAsync = ref.watch(sheFilesProvider);
    final files = filesAsync.valueOrNull ?? const <SheFile>[];
    final filtered = _categoryFilter == null ? files : files.where((f) => f.category == _categoryFilter).toList();

    final validCount = files.where((f) => f.status == SheFileStatus.valid).length;
    final expiringCount = files.where((f) => f.status == SheFileStatus.expiringSoon).length;
    final expiredCount = files.where((f) => f.status == SheFileStatus.expired).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('SHE Files', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600)),
            ElevatedButton(onPressed: () => _showUploadDialog(context), child: const Text('Upload file')),
          ],
        ),
        const SizedBox(height: 12),
        const NoteBanner(
          child: Text(
            'The compliance register: legal appointments, policies, training certs, equipment certs and permits, '
            "with expiry tracking. (Uploads record file metadata only — there's no binary storage endpoint yet, "
            'so no file content is actually stored.)',
          ),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(child: StatCard(label: 'Valid', value: '$validCount', valueColor: AppColors.green)),
            const SizedBox(width: 12),
            Expanded(child: StatCard(label: 'Expiring soon', value: '$expiringCount', valueColor: AppColors.amber)),
            const SizedBox(width: 12),
            Expanded(child: StatCard(label: 'Expired', value: '$expiredCount', valueColor: AppColors.red)),
          ],
        ),
        const SizedBox(height: 14),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ChoiceChip(label: const Text('All'), selected: _categoryFilter == null, onSelected: (_) => setState(() => _categoryFilter = null)),
              const SizedBox(width: 6),
              for (final c in SheFileCategory.values)
                Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: ChoiceChip(label: Text(c.label), selected: _categoryFilter == c, onSelected: (_) => setState(() => _categoryFilter = c)),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: filtered.isEmpty
              ? const Center(child: Text('No files in this category.', style: TextStyle(color: AppColors.sub, fontSize: 12)))
              : ListView.separated(
                  itemCount: filtered.length,
                  separatorBuilder: (_, _) => const Divider(),
                  itemBuilder: (context, index) {
                    final file = filtered[index];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(file.title, style: const TextStyle(fontSize: 13)),
                      subtitle: Text('${file.category.label} · expires ${formatDateLong(file.expiryDate)}', style: const TextStyle(fontSize: 11, color: AppColors.sub)),
                      trailing: Pill(label: file.status.label, variant: sheFileStatusVariant[file.status]!),
                    );
                  },
                ),
        ),
      ],
    );
  }

  void _showUploadDialog(BuildContext context) {
    final titleController = TextEditingController();
    final fileNameController = TextEditingController();
    var category = SheFileCategory.values.first;
    DateTime? expiryDate;

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) => AlertDialog(
          title: const Text('Upload SHE file'),
          content: SizedBox(
            width: 360,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('TITLE', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                TextField(controller: titleController),
                const SizedBox(height: 12),
                const Text('CATEGORY', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                DropdownButtonFormField<SheFileCategory>(
                  initialValue: category,
                  items: SheFileCategory.values.map((c) => DropdownMenuItem(value: c, child: Text(c.label))).toList(),
                  onChanged: (value) => setDialogState(() => category = value!),
                ),
                const SizedBox(height: 12),
                const Text('EXPIRY DATE (optional)', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                OutlinedButton(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: dialogContext,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 3650)),
                    );
                    if (picked != null) setDialogState(() => expiryDate = picked);
                  },
                  child: Text(expiryDate == null ? 'Pick a date' : formatDateLong(expiryDate)),
                ),
                const SizedBox(height: 12),
                const Text('FILE NAME (placeholder - no real upload yet)', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                TextField(controller: fileNameController),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(dialogContext).pop(), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                final user = ref.read(authSessionProvider).user;
                final siteId = ref.read(selectedSiteIdProvider);
                if (user == null || titleController.text.trim().isEmpty) return;
                final id = _uuid.v4();
                final fileName = fileNameController.text.trim().isEmpty ? 'untitled' : fileNameController.text.trim();
                await ref.read(referenceDataRepositoryProvider).registerSheFile(
                      id: id,
                      organizationId: user.organizationId,
                      siteId: siteId,
                      category: category,
                      title: titleController.text.trim(),
                      ownerUserId: user.id,
                      storageKey: 'tablet-upload/$id/$fileName',
                      expiryDate: expiryDate,
                    );
                ref.invalidate(sheFilesProvider);
                if (dialogContext.mounted) Navigator.of(dialogContext).pop();
              },
              child: const Text('Upload'),
            ),
          ],
        ),
      ),
    );
  }
}
