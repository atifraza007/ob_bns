import 'dart:convert';

import 'package:bin_management_system/core/app_constants/api_urls.dart';
import 'package:bin_management_system/core/network/api_services/api_service.dart';
import 'package:bin_management_system/core/utils/app_snackbar/app_snackbar.dart';
import 'package:bin_management_system/models/login_model.dart';
import 'package:bin_management_system/views/assigned_sites_view/assigned_sites_view.dart';
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  final ApiService _apiService = ApiService();
  RxString _token = ''.obs;

  RxString get token => _token;

  // ── SharedPreferences keys ────────────────────────────────────────────────
  static const String _tokenKey        = 'token';
  static const String _rememberMeKey   = 'rememberMe';
  static const String _assignedSitesKey = 'assignedSites';

  // Data
  Rx<LoginModel> loginModel = LoginModel().obs;

  // ── Token helpers ─────────────────────────────────────────────────────────

  Future<bool> _isTokenExpired(String token) async {
    return JwtDecoder.isExpired(token);
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    _token.value = token;
  }

  Future<String?> _getTokenFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<bool> isRememberChecked() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_rememberMeKey) ?? false;
  }

  // ── Assigned Sites — persist & restore ───────────────────────────────────

  /// Serialises the assignedSites list to JSON and stores it locally.
  Future<void> _saveAssignedSites(List<AssignedSites> sites) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(sites.map((s) => s.toJson()).toList());
    await prefs.setString(_assignedSitesKey, encoded);
  }

  /// Loads assignedSites from SharedPreferences and injects them into
  /// [loginModel] so the UI can read from a single source of truth.
  Future<void> loadAssignedSitesFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_assignedSitesKey);
    if (raw == null || raw.isEmpty) return;

    try {
      final List<dynamic> decoded = jsonDecode(raw);
      final sites =
          decoded.map((e) => AssignedSites.fromJson(e)).toList();

      // Patch loginModel so the View always reads from loginModel only.
      final currentUser = loginModel.value.user ?? User();
      currentUser.assignedSites = sites;
      loginModel.value = LoginModel(
        user: currentUser,
        auth: loginModel.value.auth,
      );
      // Trigger Rx update
      loginModel.refresh();
    } catch (e) {
      print('loadAssignedSitesFromLocal error: $e');
    }
  }

  // ── Auth API calls ────────────────────────────────────────────────────────

  Future<void> login(String email, String password, bool rememberMe) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final response = await _apiService.post(
        APIURLs.login,
        body: {'email': email, 'password': password},
      );
      print("Login Response: $response");

      // Save token
      await _saveToken(response['auth']['token']);
      await prefs.setBool(_rememberMeKey, rememberMe);

      // Parse model
      loginModel.value = LoginModel.fromJson(response);
      print("LoginModel: ${loginModel.value.toJson()}");

      // ── Persist assignedSites locally right after login ──────────────
      final sites = loginModel.value.user?.assignedSites ?? [];
      await _saveAssignedSites(sites);

      CustomSnackbar.showCustomSnackBar(
        Get.context!,
        "Login Successful",
        success: true,
      );

      Get.offAll(() => AssignedSitesView());
    } catch (e) {
      print("LoginException: $e");
      rethrow;
    }
  }

  Future<void> forgotPassword(String email) async {
    try {
      await _apiService.post('/forgot-password', body: {'email': email});
    } catch (e) {
      throw Exception("Forgot Password failed: $e");
    }
  }

  Future<void> resetPassword(
    String token,
    String password,
    String confirmPassword,
  ) async {
    try {
      await _apiService.post(
        '/reset-password',
        body: {
          'token': token,
          'password': password,
          'confirmPassword': confirmPassword,
        },
      );
    } catch (e) {
      throw Exception("Reset Password failed: $e");
    }
  }

  Future<void> refreshToken() async {
    final token = await _getTokenFromStorage();
    if (token == null) throw Exception("No token found.");

    try {
      final response = await _apiService.get(
        APIURLs.refreshToken,
        requiresAuth: true,
      );
      await _saveToken(response['token']);
    } catch (e) {
      throw Exception("Refresh Token failed: $e");
    }
  }

  /// Called on app start from main.dart / SplashController.
  /// Checks token validity AND restores local sites into loginModel.
  Future<void> checkTokenOnStart() async {
    final token = await _getTokenFromStorage();
    if (token == null) {
      _token.value = '';
      return;
    }

    if (await _isTokenExpired(token)) {
      await refreshToken();
    } else {
      _token.value = token;
    }

    // Restore sites so the UI has data immediately without an API call
    await loadAssignedSitesFromLocal();
  }
}