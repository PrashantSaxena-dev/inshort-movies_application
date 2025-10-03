import 'package:dio/dio.dart';
import '../constants.dart';

class DioClient {
  static Dio create() {
    final dio = Dio(
      BaseOptions(
        baseUrl: TMDB_BASE_URL,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    // Interceptor to attach API key automatically
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.queryParameters['api_key'] = TMDB_API_KEY;
          return handler.next(options);
        },
        onError: (e, handler) {
          print("Dio error: ${e.message}");
          return handler.next(e);
        },
      ),
    );

    return dio;
  }
}
