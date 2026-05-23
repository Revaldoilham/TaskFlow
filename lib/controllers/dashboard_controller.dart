// lib/modules/dashboard/dashboard_controller.dart
import 'package:get/get.dart';

import 'package:taskflow/controllers/task_controller.dart';
import 'package:taskflow/controllers/project_controller.dart';
import 'package:taskflow/controllers/auth_controller.dart';

class DashboardController extends GetxController {
  final RxInt currentIndex = 0.obs;
  
  late final TaskController taskController;
  late final ProjectController projectController;
  late final AuthController authController;

  @override
  void onInit() {
    super.onInit();
    taskController = Get.find<TaskController>();
    projectController = Get.find<ProjectController>();
    authController = Get.find<AuthController>();
  }

  void changeTab(int index) => currentIndex.value = index;

  String get greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }
  
  String get userName => authController.currentUser.value?.name.split(' ').first ?? 'User';
}