import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final connectivityStreamProvider = StreamProvider<List<ConnectivityResult>>((ref) {
  return Connectivity().onConnectivityChanged;
});

/// Optimistically online until the first connectivity event arrives, so the app doesn't
/// flash an "offline" banner during the first frame on a device that's actually online.
final isOnlineProvider = Provider<bool>((ref) {
  final results = ref.watch(connectivityStreamProvider).valueOrNull;
  if (results == null) return true;
  return results.any((r) => r != ConnectivityResult.none);
});
