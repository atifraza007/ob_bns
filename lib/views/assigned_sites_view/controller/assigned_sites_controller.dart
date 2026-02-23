import 'package:bin_management_system/core/controllers/auth_controller/auth_controller.dart';
import 'package:bin_management_system/models/login_model.dart';
import 'package:get/get.dart';

class AssignedSitesController extends GetxController {
  final RxBool isLoading = false.obs;

  /// Pulled directly from AuthController's loginModel — no dummy data.
  RxList<AssignedSites> get sites {
    final authController = Get.find<AuthController>();
    final assignedSites =
        authController.loginModel.value.user?.assignedSites ?? [];
    return assignedSites.obs;
  }
}