import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../local_db/database.dart';
import '../network/api_client.dart';
import '../network/api_config.dart';
import '../network/auth_session.dart';
import '../repositories/auth_repository.dart';
import '../repositories/reference_data_repository.dart';
import '../repositories/reports_repository.dart';
import '../repositories/sync_service.dart';
import '../storage/secure_storage.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final apiBaseUrlProvider = Provider<String>((ref) => resolveApiBaseUrl());

final authSessionProvider = ChangeNotifierProvider<AuthSession>((ref) => AuthSession());

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    baseUrl: ref.watch(apiBaseUrlProvider),
    session: ref.watch(authSessionProvider),
    secureStorage: SecureStorage.instance,
  );
});

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(
    baseUrl: ref.watch(apiBaseUrlProvider),
    session: ref.watch(authSessionProvider),
    authRepository: ref.watch(authRepositoryProvider),
  );
});

final referenceDataRepositoryProvider = Provider<ReferenceDataRepository>((ref) {
  return ReferenceDataRepository(dio: ref.watch(apiClientProvider).dio, db: ref.watch(databaseProvider));
});

final reportsRepositoryProvider = Provider<ReportsRepository>((ref) {
  return ReportsRepository(db: ref.watch(databaseProvider), dio: ref.watch(apiClientProvider).dio);
});

final syncServiceProvider = Provider<SyncService>((ref) {
  return SyncService(
    db: ref.watch(databaseProvider),
    dio: ref.watch(apiClientProvider).dio,
    reportsRepository: ref.watch(reportsRepositoryProvider),
  );
});
