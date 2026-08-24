import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/connectivity_providers.dart';
import '../providers/sync_providers.dart';
import '../theme/app_theme.dart';

/// Persistent online/offline + pending-changes indicator. Deliberately always visible
/// (not hidden behind a menu) - FLUTTER_BUILD_PROMPT.md: "don't hide sync status from
/// the user, this is the whole point of the app."
class SyncStatusIndicator extends ConsumerWidget {
  const SyncStatusIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOnline = ref.watch(isOnlineProvider);
    final sync = ref.watch(syncControllerProvider);

    final Color dotColor;
    final String label;
    if (!isOnline) {
      dotColor = AppColors.red;
      label = sync.pendingCount > 0 ? 'Offline · ${sync.pendingCount} pending' : 'Offline';
    } else if (sync.isSyncing) {
      dotColor = AppColors.amber;
      label = 'Syncing…';
    } else if (sync.pendingCount > 0) {
      dotColor = AppColors.amber;
      label = '${sync.pendingCount} pending';
    } else {
      dotColor = AppColors.green;
      label = 'Synced';
    }

    return Tooltip(
      message: sync.lastSyncedAt == null
          ? 'No sync yet this session'
          : 'Last synced ${TimeOfDay.fromDateTime(sync.lastSyncedAt!).format(context)}',
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: isOnline && !sync.isSyncing ? () => ref.read(syncControllerProvider.notifier).syncNow() : null,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.navyHover,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (sync.isSyncing)
                const SizedBox(
                  width: 10,
                  height: 10,
                  child: CircularProgressIndicator(strokeWidth: 1.5, color: Colors.white),
                )
              else
                Container(width: 8, height: 8, decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle)),
              const SizedBox(width: 6),
              Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFFC4C9D4), fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}
