import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/report.dart';
import 'core_providers.dart';
import 'session_providers.dart';
import 'sync_providers.dart';

/// Local-first: reads straight from the drift cache, which is always up to date with
/// whatever's been saved locally (dirty or not) - never blocked on connectivity.
final reportsForSiteProvider = StreamProvider<List<Report>>((ref) {
  final siteId = ref.watch(selectedSiteIdProvider);
  if (siteId == null) return const Stream.empty();
  return ref.watch(reportsRepositoryProvider).watchBySite(siteId);
});

final reportByIdProvider = FutureProvider.family<Report?, String>((ref, id) {
  return ref.watch(reportsRepositoryProvider).getById(id);
});

class ReportEditorController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> saveDraft({required String id, required ReportDraftPayload payload}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(reportsRepositoryProvider).saveDraft(id: id, payload: payload);
      await ref.read(syncControllerProvider.notifier).refreshPendingCount();
    });
  }

  /// Online-only - callers must gate this on `isOnlineProvider` themselves and disable
  /// the submit action while offline (FLUTTER_BUILD_PROMPT.md's chosen UX approach:
  /// submit is unavailable offline rather than silently queued, so the user is never
  /// misled into thinking an offline submit succeeded).
  Future<void> submit(String id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => ref.read(reportsRepositoryProvider).submitReport(id));
  }
}

final reportEditorControllerProvider = AsyncNotifierProvider<ReportEditorController, void>(ReportEditorController.new);
