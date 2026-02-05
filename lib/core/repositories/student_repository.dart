import 'dart:convert';
import '../models/user_model.dart';
import '../models/dashboard_model.dart';
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

    final userData = response['data'] ?? response['user'] ?? response;
    final user = UserModel.fromJson(userData);

    // Merge logic: Prioritize fresh API data, fallback to cache for missing fields
    final cachedData = await getCachedProfile();
    final updatedUser = cachedData != null 
        ? cachedData.copyWith(
            id: user.id.isNotEmpty ? user.id : cachedData.id,
            name: user.name.isNotEmpty ? user.name : cachedData.name,
            nameAr: user.nameAr ?? cachedData.nameAr,
            nameEn: user.nameEn ?? cachedData.nameEn,
            email: user.email.isNotEmpty ? user.email : cachedData.email,
            phone: user.phone ?? cachedData.phone,
            studentId: user.studentId ?? cachedData.studentId,
            major: user.major ?? cachedData.major,
            year: user.year ?? cachedData.year,
            gpa: (user.gpa != null && user.gpa! > 0) ? user.gpa : (cachedData.gpa ?? 0.0),
            completedCreditHours: (user.completedCreditHours != null && user.completedCreditHours! > 0) 
                ? user.completedCreditHours 
                : cachedData.completedCreditHours,
            remainingCreditHours: (user.remainingCreditHours != null && user.remainingCreditHours! > 0)
                ? user.remainingCreditHours
                : cachedData.remainingCreditHours,
            totalCreditHours: user.totalCreditHours ?? cachedData.totalCreditHours,
            overallProgress: (user.overallProgress != null && user.overallProgress! > 0)
                ? user.overallProgress
                : cachedData.overallProgress,
          )
        : user;

    await _preferences.saveUserData(jsonEncode(updatedUser.toJson()));
    return updatedUser;
  }

  /// Get dashboard info from API
  Future<UserModel> getDashboard() async {
    final response = await _apiClient.get(
      ApiConstants.dashboard,
      requiresAuth: true,
    );

    final userData = response['data'] ?? response['user'] ?? response;
    final dashboard = DashboardModel.fromJson(userData);

    // Merge Logic: Connect backend Dashboard data to the unified UserModel
    final cachedData = await getCachedProfile();
    final updatedUser = cachedData != null 
        ? cachedData.copyWith(
            nameAr: dashboard.nameAr.isNotEmpty ? dashboard.nameAr : cachedData.nameAr,
            nameEn: dashboard.nameEn.isNotEmpty ? dashboard.nameEn : cachedData.nameEn,
            gpa: dashboard.gpa > 0 ? dashboard.gpa : cachedData.gpa,
            completedCreditHours: dashboard.completedCreditHours > 0 ? dashboard.completedCreditHours : cachedData.completedCreditHours,
            remainingCreditHours: dashboard.remainingCreditHours > 0 ? dashboard.remainingCreditHours : cachedData.remainingCreditHours,
            overallProgress: dashboard.overallProgress > 0 ? dashboard.overallProgress : cachedData.overallProgress,
            studentId: dashboard.studentID.isNotEmpty ? dashboard.studentID : cachedData.studentId,
          )
        : UserModel(
            id: dashboard.studentID,
            name: dashboard.nameEn.isNotEmpty ? dashboard.nameEn : (dashboard.nameAr.isNotEmpty ? dashboard.nameAr : 'Student'),
            nameAr: dashboard.nameAr,
            nameEn: dashboard.nameEn,
            email: '', 
            studentId: dashboard.studentID,
            gpa: dashboard.gpa,
            completedCreditHours: dashboard.completedCreditHours,
            remainingCreditHours: dashboard.remainingCreditHours,
            overallProgress: dashboard.overallProgress,
          );

    await _preferences.saveUserData(jsonEncode(updatedUser.toJson()));
    return updatedUser;
  }

  /// Get cached profile tracker (Offline Support)
  Future<UserModel?> getCachedProfile() async {
    final userData = await _preferences.getUserData();
    if (userData != null && userData.isNotEmpty) {
      try {
        return UserModel.fromJson(jsonDecode(userData));
      } catch (e) {
        return null;
      }
    }
    return null;
  }
}
