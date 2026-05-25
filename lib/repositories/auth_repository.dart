// lib/data/repositories/auth_repository.dart
import '../models/user_model.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class AuthRepository {
  final ApiService _api = ApiService();
  final StorageService _storage = StorageService();

  Future<Map<String, dynamic>> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      throw Exception('Email dan password harus diisi');
    }

    final response = await _api.post('/auth/login', {
      'email': email,
      'password': password,
    });

    if (!response.success) {
      throw Exception(response.message ??
          'Login gagal. Silakan periksa kembali email & password Anda.');
    }

    final data = response.data;
    if (data == null) {
      throw Exception('Format respon server tidak valid.');
    }

    final payload = data['data'] ?? data;
    final token = payload['token'];
    final userData = payload['user'];

    if (token == null || userData == null) {
      throw Exception('Data autentikasi dari server tidak lengkap.');
    }

    final user = UserModel.fromJson(userData);

    await _storage.saveToken(token);
    await _storage.saveUser(user);

    return {'token': token, 'user': user.toJson()};
  }

  Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
  ) async {
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      throw Exception('Semua field wajib diisi');
    }

    final response = await _api.post('/auth/register', {
      'name': name,
      'email': email,
      'password': password,
    });

    if (!response.success) {
      throw Exception(
          response.message ?? 'Pendaftaran gagal. Silakan coba lagi.');
    }

    final data = response.data;
    if (data == null) {
      throw Exception('Format respon server tidak valid.');
    }

    final payload = data['data'] ?? data;
    final token = payload['token'];
    final userData = payload['user'];

    if (token == null || userData == null) {
      throw Exception('Data autentikasi dari server tidak lengkap.');
    }

    final user = UserModel.fromJson(userData);

    await _storage.saveToken(token);
    await _storage.saveUser(user);

    return {'token': token, 'user': user.toJson()};
  }

  Future<void> logout() async {
    try {
      final response = await _api.post('/auth/logout', {}, requireAuth: true);
      if (!response.success) {
        print('Server logout response error: ${response.message}');
      }
    } catch (e) {
      print('Network logout error: $e');
    } finally {
      await _storage.clearAll();
    }
  }

  Future<bool> isLoggedIn() async {
    return await _storage.hasToken();
  }

  Future<UserModel?> getCurrentUser() async {
    return await _storage.getUser();
  }
}
