import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class DioClient {
  late final Dio _dio;
  final Logger _logger = Logger();

  DioClient() {
    _dio = Dio(BaseOptions(
      baseUrl: 'https://echo-api.up.railway.app/api',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {'Content-Type': 'application/json'},
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        _logger.i('➡️ ${options.method} ${options.path}');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        _logger.i('⬅️ ${response.statusCode} ${response.requestOptions.path}');
        return handler.next(response);
      },
      onError: (error, handler) {
        _logger.e('❌ ${error.response?.statusCode} ${error.requestOptions.path}: ${error.message}');
        return handler.next(error);
      },
    ));
  }

  Dio get dio => _dio;
}
