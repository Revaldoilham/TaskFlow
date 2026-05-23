import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:taskflow/constants/app_constants.dart';

import 'package:taskflow/controllers/auth_controller.dart';
import 'package:taskflow/controllers/dashboard_controller.dart';
import 'package:taskflow/controllers/project_controller.dart';
import 'package:taskflow/controllers/task_controller.dart';

import 'package:taskflow/screens/auth/login_screen.dart';
import 'package:taskflow/screens/auth/register_screen.dart';
import 'package:taskflow/screens/dashboard/splash_screen.dart';

import 'package:taskflow/screens/dashboard/home_screen.dart';

import 'package:taskflow/screens/tasks/tasks_screen.dart';
import 'package:taskflow/screens/tasks/task_detail_screen.dart';

import 'package:taskflow/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Register Controllers
  Get.put(AuthController());
  Get.put(TaskController());
  Get.put(ProjectController());

  // Dashboard terakhir
  Get.put(DashboardController());

  runApp(const TaskFlowApp());
}

class TaskFlowApp extends StatelessWidget {
  const TaskFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppConstants.appName,
      theme: AppTheme.lightTheme,
      initialRoute: '/splash',
      getPages: [
        GetPage(
          name: '/splash',
          page: () => const SplashScreen(),
        ),

        // LOGIN
        GetPage(
          name: '/login',
          page: () => const LoginScreen(),
        ),

        // REGISTER
        GetPage(
          name: '/register',
          page: () => const RegisterScreen(),
        ),

        // DASHBOARD
        GetPage(
          name: '/dashboard',
          page: () => const HomeScreen(),
        ),

        // TASKS
        GetPage(
          name: '/tasks',
          page: () => const TasksScreen(),
        ),

        // TASK DETAIL
        GetPage(
          name: '/task-detail',
          page: () => const TaskDetailScreen(),
        ),
      ],
    );
  }
}
