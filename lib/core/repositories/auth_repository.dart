/**
 * Auth Repository Interface and Implementation
 */

abstract class AuthRepository {
  Future<void> login(String email, String password);
  Future<void> register(String email, String password, String name);
  Future<void> logout();
  Future<String?> getToken();
}

class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<void> login(String email, String password) async {
    // TODO: Implement using ApiService
    throw UnimplementedError();
  }

  @override
  Future<void> register(String email, String password, String name) async {
    // TODO: Implement using ApiService
    throw UnimplementedError();
  }

  @override
  Future<void> logout() async {
    // TODO: Implement using ApiService
    throw UnimplementedError();
  }

  @override
  Future<String?> getToken() async {
    // TODO: Get from secure storage
    throw UnimplementedError();
  }
}
