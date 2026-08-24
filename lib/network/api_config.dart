import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;

/// Base URL per FLUTTER_BUILD_PROMPT.md: the Android emulator can't reach the host
/// machine via `localhost` (that resolves to the emulator itself), so it needs the
/// special `10.0.2.2` alias instead. Every other target (web, iOS simulator, desktop)
/// uses `localhost` directly.
String resolveApiBaseUrl() {
  const override = String.fromEnvironment('API_BASE_URL');
  if (override.isNotEmpty) return override;

  if (!kIsWeb && Platform.isAndroid) {
    return 'http://10.0.2.2:8080';
  }
  return 'http://localhost:8080';
}
