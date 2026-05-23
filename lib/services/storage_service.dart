import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:taskflow/constants/app_constants.dart';
import 'package:taskflow/models/user_model.dart';

class StorageService {
  static final StorageService _instance =
      StorageService._internal();

  factory StorageService() => _instance;

  StorageService._internal();

  final FlutterSecureStorage _storage =
      const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  // ==============================
  // TOKEN
  // ==============================

  Future<void> saveToken(String token) async {
    await _storage.write(
      key: AppConstants.tokenKey,
      value: token,
    );
  }

  Future<String?> getToken() async {
    return await _storage.read(
      key: AppConstants.tokenKey,
    );
  }

  Future<void> deleteToken() async {
    await _storage.delete(
      key: AppConstants.tokenKey,
    );
  }

  Future<bool> hasToken() async {
    final token = await getToken();

    return token != null &&
        token.isNotEmpty;
  }

  // ==============================
  // USER
  // ==============================

  Future<void> saveUser(
    UserModel user,
  ) async {
    await _storage.write(
      key: AppConstants.userKey,
      value: jsonEncode(user.toJson()),
    );
  }

  Future<UserModel?> getUser() async {
    final userString = await _storage.read(
      key: AppConstants.userKey,
    );

    if (userString == null) {
      return null;
    }

    try {
      return UserModel.fromJson(
        jsonDecode(userString),
      );
    } catch (e) {
      return null;
    }
  }

  // ==============================
  // CLEAR STORAGE
  // ==============================

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}