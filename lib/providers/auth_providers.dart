import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core_providers.dart';

/// Attempts a silent refresh-token resume exactly once on cold start. The root widget
/// watches this to decide whether to show a splash before routing to login/dashboard -
/// see FLUTTER_BUILD_PROMPT.md: a 14-day refresh token means most cold starts should
/// land the user straight back in, not force a fresh login.
final authBootstrapProvider = FutureProvider<void>((ref) async {
  await ref.watch(authRepositoryProvider).tryResume();
});

class LoginController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => ref.read(authRepositoryProvider).login(email, password));
  }
}

final loginControllerProvider = AsyncNotifierProvider<LoginController, void>(LoginController.new);
