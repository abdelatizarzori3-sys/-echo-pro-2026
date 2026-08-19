/**
 * API Service for Flutter
 * Handles all HTTP requests to backend
 */

import 'package:dio/dio.js';
import 'package:flutter_secure_storage/flutter_secure_storage.js';

class ApiService {
  final Dio dio;
  final FlutterSecureStorage secureStorage;
  final String baseUrl;

  ApiService({
    required this.dio,
    required this.secureStorage,
    required this.baseUrl,
  }) {
    dio.options.baseUrl = baseUrl;
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await secureStorage.read(key: 'auth_token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (error, handler) {
        if (error.response?.statusCode == 401) {
          // Token expired, refresh or logout
        }
        return handler.next(error);
      },
    ));
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await dio.post(
        '/api/auth/login',
        data: {'email': email, 'password': password},
      );
      
      final token = response.data['token'];
      await secureStorage.write(key: 'auth_token', value: token);
      
      return response.data;
    } on DioError catch (e) {
      throw Exception(e.response?.data['error'] ?? 'Login failed');
    }
  }

  Future<Map<String, dynamic>> register(
    String email,
    String password,
    String name,
  ) async {
    try {
      final response = await dio.post(
        '/api/auth/register',
        data: {'email': email, 'password': password, 'name': name},
      );
      
      final token = response.data['token'];
      await secureStorage.write(key: 'auth_token', value: token);
      
      return response.data;
    } on DioError catch (e) {
      throw Exception(e.response?.data['error'] ?? 'Registration failed');
    }
  }

  Future<Map<String, dynamic>> sendMessage(String message) async {
    try {
      final response = await dio.post(
        '/api/messages/send',
        data: {'content': message},
      );
      return response.data;
    } on DioError catch (e) {
      throw Exception(e.response?.data['error'] ?? 'Failed to send message');
    }
  }

  Future<List<Map<String, dynamic>>> getMessages(String conversationId) async {
    try {
      final response = await dio.get(
        '/api/messages/history/$conversationId',
      );
      return List<Map<String, dynamic>>.from(response.data['messages']);
    } on DioError catch (e) {
      throw Exception(e.response?.data['error'] ?? 'Failed to fetch messages');
    }
  }

  Future<void> logout() async {
    await secureStorage.delete(key: 'auth_token');
  }
}
