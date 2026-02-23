import 'package:bin_management_system/core/controllers/auth_controller/auth_controller.dart';
import 'package:bin_management_system/views/assigned_sites_view/assigned_sites_view.dart';
import 'package:bin_management_system/views/auth_views/login_view/login_view.dart';
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashController extends GetxController {
  final RxDouble opacity = 0.0.obs;
  final RxBool isVisible = false.obs;
  final AuthController authController = Get.put(AuthController());

  @override
  void onInit() {
    super.onInit();
    _startAnimations();
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 200));
    opacity.value = 1.0;
    isVisible.value = true;

    await Future.delayed(const Duration(milliseconds: 2800));
    checkLogin();
  }

  // void checkLogin() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();

  //   var token = prefs.getString("token");
  //   if (token == null || token.isEmpty || JwtDecoder.isExpired(token)) {
  //     Get.offAll(() => LoginScreen());
  //   } else {
  //     Get.offAll(() => AssignedSitesView());
  //   }
  // }

  void checkLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final token = prefs.getString("token");
    final rememberMe = prefs.getBool("rememberMe") ?? false;

    // No token at all → go to login
    if (token == null || token.isEmpty) {
      Get.offAll(() => LoginScreen());
      return;
    }

    // Token is valid → go to home
    if (!JwtDecoder.isExpired(token)) {
      Get.offAll(() => AssignedSitesView());
      return;
    }

    // Token is expired → check rememberMe
    if (rememberMe) {
      try {
        await authController.refreshToken();
        Get.offAll(() => AssignedSitesView());
      } catch (e) {
        // Refresh failed → clear saved data and go to login
        await prefs.remove("token");
        await prefs.remove("rememberMe");
        Get.offAll(() => LoginScreen());
      }
    } else {
      // rememberMe is false → clear token and go to login
      await prefs.remove("token");
      Get.offAll(() => LoginScreen());
    }
  }
}
