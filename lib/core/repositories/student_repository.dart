import 'dart:convert';
import '../models/user_model.dart';
import '../network/api_client.dart';
import '../network/api_constants.dart';
import '../utils/app_preferences.dart';

/// Repository for student/profile operations
class StudentRepository {
  final ApiClient _apiClient;
  final AppPreferences _preferences;

  StudentRepository({ApiClient? apiClient, AppPreferences? preferences})
      : _apiClient = apiClient ?? ApiClient(),
        _preferences = preferences ?? AppPreferences();

  /// Get student profile from API
  Future<UserModel> getProfile() async {
    final response = await _apiClient.get(
      ApiConstants.studentProfile,
      requiresAuth: true,
    );

    // Handle different response formats
    final userData = response['data'] ?? response['user'] ?? response;
    final user = UserModel.fromJson(userData);

    // Cache user data
    await _preferences.saveUserData(jsonEncode(user.toJson()));

    return user;
  }

  /// Get cached profile data (for offline support)
  Future<UserModel?> getCachedProfile() async {
    final userData = await _preferences.getUserData();
    if (userData != null && userData.isNotEmpty) {
      return UserModel.fromJson(jsonDecode(userData));
    }
    return null;
  }
}
