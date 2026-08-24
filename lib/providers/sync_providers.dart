import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/sync_service.dart';
import 'core_providers.dart';

class SyncState {
  const SyncState({this.isSyncing = false, this.lastResult, this.lastSyncedAt, this.error, this.pendingCount = 0});

  final bool isSyncing;
  final SyncResult? lastResult;
  final DateTime? lastSyncedAt;
  final String? error;
  final int pendingCount;

  SyncState copyWith({
    bool? isSyncing,
    SyncResult? lastResult,
    DateTime? lastSyncedAt,
    String? error,
    bool clearError = false,
    int? pendingCount,
  }) =>
      SyncState(
        isSyncing: isSyncing ?? this.isSyncing,
        lastResult: lastResult ?? this.lastResult,
        lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
        error: clearError ? null : (error ?? this.error),
        pendingCount: pendingCount ?? this.pendingCount,
      );
}

/// Drives the "sync on reconnect" behaviour: watches connectivity and fires a push+pull
/// cycle the moment the device transitions from offline back to online, plus exposes a
/// manual `syncNow()` for the UI's "sync now" affordance (FLUTTER_BUILD_PROMPT.md).
class SyncController extends Notifier<SyncState> {
  StreamSubscription<List<ConnectivityResult>>? _connectivitySub;
  bool _wasOffline = false;

  @override
  SyncState build() {
    ref.onDispose(() => _connectivitySub?.cancel());
    _connectivitySub = Connectivity().onConnectivityChanged.listen(_onConnectivityChanged);
    unawaited(refreshPendingCount());
    return const SyncState();
  }

  void _onConnectivityChanged(List<ConnectivityResult> results) {
    final isOnline = results.any((r) => r != ConnectivityResult.none);
    if (isOnline && _wasOffline) {
      unawaited(syncNow());
    }
    _wasOffline = !isOnline;
  }

  Future<void> refreshPendingCount() async {
    final count = await ref.read(syncServiceProvider).pendingOutboxCount();
    state = state.copyWith(pendingCount: count);
  }

  Future<void> syncNow() async {
    final user = ref.read(authSessionProvider).user;
    if (user == null || state.isSyncing) return;

    state = state.copyWith(isSyncing: true, clearError: true);
    try {
      final result = await ref
          .read(syncServiceProvider)
          .syncNow(organizationId: user.organizationId, actorUserId: user.id);
      final pending = await ref.read(syncServiceProvider).pendingOutboxCount();
      state = state.copyWith(isSyncing: false, lastResult: result, lastSyncedAt: DateTime.now(), pendingCount: pending);
    } catch (e) {
      state = state.copyWith(isSyncing: false, error: e.toString());
    }
  }
}

final syncControllerProvider = NotifierProvider<SyncController, SyncState>(SyncController.new);
