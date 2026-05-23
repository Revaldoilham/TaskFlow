// lib/data/repositories/auth_repository.dart
import '../models/user_model.dart';
import '../providers/mock_data_provider.dart';
import '/services/api_service.dart';
import '/services/storage_service.dart';

class AuthRepository {
  final ApiService _api = ApiService();
  final StorageService _storage = StorageService();

  // Use mock data - replace with real API calls later
  Future<Map<String, dynamic>> login(String email, String password) async {
    // Mock: Simulate API delay
    await Future.delayed(const Duration(milliseconds: 1500));
    
    // Mock validation
    if (email.isEmpty || password.isEmpty) {
      throw Exception('Email and password are required');
    }
    if (!email.contains('@')) {
      throw Exception('Invalid email format');
    }
    if (password.length < 6) {
      throw Exception('Password must be at least 6 characters');
    }

    // Mock success - simulate any valid credentials
    const mockToken = 'mock_jwt_token_taskflow_2024';
    final user = MockDataProvider.currentUser;
    
    await _storage.saveToken(mockToken);
    await _storage.saveUser(user);
    
    return {'token': mockToken, 'user': user.toJson()};

    // Real API integration (future):
    // final response = await _api.post('/auth/login', {'email': email, 'password': password});
    // if (!response.success) throw Exception(response.message);
    // await _storage.saveToken(response.data!['token']);
    // final user = UserModel.fromJson(response.data!['user']);
    // await _storage.saveUser(user);
    // return response.data!;
  }

  Future<Map<String, dynamic>> register(
    String name, String email, String password,
  ) async {
    await Future.delayed(const Duration(milliseconds: 1500));

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      throw Exception('All fields are required');
    }
    if (!email.contains('@')) throw Exception('Invalid email format');
    if (password.length < 6) throw Exception('Password must be at least 6 characters');

    const mockToken = 'mock_jwt_token_taskflow_2024';
    final user = UserModel(
      id: '1', name: name, email: email, role: 'Member',
    );

    await _storage.saveToken(mockToken);
    await _storage.saveUser(user);

    return {'token': mockToken, 'user': user.toJson()};
  }

  Future<void> logout() async {
    await _storage.clearAll();
  }

  Future<bool> isLoggedIn() async {
    return await _storage.hasToken();
  }

  Future<UserModel?> getCurrentUser() async {
    return await _storage.getUser();
  }
}