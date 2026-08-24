import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';

import '../repositories/auth_repository.dart';
import 'auth_session.dart';

const _uuid = Uuid();

String newIdempotencyKey() => _uuid.v4();

/// The Dio instance every repository except AuthRepository uses: attaches the bearer
/// token on every request, and on a 401 (not from an /api/auth/* call, which manages its
/// own retry via AuthRepository) silently refreshes once and retries - mirrors
/// safezone-web's src/api/client.ts interceptor pair exactly.
class ApiClient {
  ApiClient({required String baseUrl, required AuthSession session, required AuthRepository authRepository})
      : dio = Dio(BaseOptions(baseUrl: baseUrl, connectTimeout: const Duration(seconds: 10))) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = session.accessToken;
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          final request = error.requestOptions;
          final isAuthEndpoint = request.path.startsWith('/api/auth/');
          final alreadyRetried = request.extra['retried'] == true;

          if (error.response?.statusCode == 401 && !isAuthEndpoint && !alreadyRetried) {
            final newToken = await authRepository.refreshAccessToken();
            if (newToken != null) {
              request.extra['retried'] = true;
              request.headers['Authorization'] = 'Bearer $newToken';
              try {
                final response = await dio.fetch(request);
                handler.resolve(response);
                return;
              } on DioException catch (retryError) {
                handler.next(retryError);
                return;
              }
            }
          }
          handler.next(error);
        },
      ),
    );
  }

  final Dio dio;
}
