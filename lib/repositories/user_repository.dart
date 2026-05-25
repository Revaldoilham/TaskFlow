import '../models/user_model.dart';
import '../services/api_service.dart';

class UserRepository {
  final ApiService _api = ApiService();

  // 1. GET /api/users/profile
  Future<UserModel> getProfile() async {
    final response = await _api.get('/users/profile');

    if (!response.success) {
      throw Exception(response.message ?? 'Gagal mengambil profil pengguna.');
    }

    final data = response.data;
    if (data == null) {
      throw Exception('Format respons server tidak valid.');
    }

    final payload = data['data'] ?? data;
    final userData = payload['user'] ?? payload;
    return UserModel.fromJson(userData);
  }

  // 2. PUT /api/users/profile
  Future<UserModel> updateProfile({
    String? name,
    String? password,
    String? avatarUrl,
  }) async {
    final Map<String, dynamic> body = {};
    if (name != null && name.trim().isNotEmpty) body['name'] = name.trim();
    if (password != null && password.isNotEmpty) body['password'] = password;
    if (avatarUrl != null && avatarUrl.trim().isNotEmpty) body['avatar_url'] = avatarUrl.trim();

    final response = await _api.put('/users/profile', body);

    if (!response.success) {
      throw Exception(response.message ?? 'Gagal memperbarui profil.');
    }

    final data = response.data;
    if (data == null) {
      throw Exception('Format respons server tidak valid.');
    }

    final payload = data['data'] ?? data;
    final userData = payload['user'] ?? payload;
    return UserModel.fromJson(userData);
  }

  // 3. GET /api/users/statistics
  Future<Map<String, dynamic>> getStatistics() async {
    final response = await _api.get('/users/statistics');

    if (!response.success) {
      throw Exception(response.message ?? 'Gagal mengambil data statistik.');
    }

    final data = response.data;
    if (data == null) {
      throw Exception('Format respons server tidak valid.');
    }

    final payload = data['data'] ?? data;
    return Map<String, dynamic>.from(payload);
  }

  // 4. GET /api/users/activities
  Future<List<Map<String, dynamic>>> getActivities() async {
    final response = await _api.get('/users/activities');

    if (!response.success) {
      throw Exception(response.message ?? 'Gagal mengambil log aktivitas.');
    }

    final data = response.data;
    if (data == null) {
      return [];
    }

    final dynamic payload = data['data'] ?? data;
    if (payload is List) {
      return List<Map<String, dynamic>>.from(
        payload.map((item) => Map<String, dynamic>.from(item)),
      );
    }
    return [];
  }
}
