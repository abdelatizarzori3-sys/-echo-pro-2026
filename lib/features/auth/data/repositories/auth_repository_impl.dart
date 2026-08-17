import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/services/storage_service.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final Dio _dio;
  final StorageService _storage;

  AuthRepositoryImpl(this._dio, this._storage);

  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    try {
      final response = await _dio.post(ApiConstants.login, data: {
        'email': email,
        'password': password,
      });
      final user = UserModel.fromJson(response.data['data']['user']);
      await _storage.setToken(user.token);
      return Right(user);
    } on DioException catch (e) {
      return Left(ServerFailure(e.response?.data?['error'] ?? 'Login failed'));
    }
  }

  @override
  Future<Either<Failure, User>> register(String email, String password, String? name) async {
    try {
      final response = await _dio.post(ApiConstants.register, data: {
        'email': email,
        'password': password,
        'name': name,
      });
      final user = UserModel.fromJson(response.data['data']['user']);
      await _storage.setToken(user.token);
      return Right(user);
    } on DioException catch (e) {
      return Left(ServerFailure(e.response?.data?['error'] ?? 'Registration failed'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    await _storage.deleteToken();
    return const Right(null);
  }

  @override
  Future<Either<Failure, User?>> checkAuth() async {
    final token = await _storage.getToken();
    if (token == null) return const Right(null);
    // TODO: Validate token with backend
    return const Right(null);
  }
}
