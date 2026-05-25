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

import 'package:taskflow/screens/tasks/task_detail_screen.dart';
import 'package:taskflow/screens/tasks/tasks_screen.dart';
import 'package:taskflow/screens/create_task/create_task_screen.dart';
import 'package:taskflow/theme/app_theme.dart';
import 'package:taskflow/screens/create_task/create_task_screen.dart';
import 'package:taskflow/controllers/create_task_controller.dart';
import 'package:taskflow/screens/profile/profile_screen.dart';
import 'package:taskflow/controllers/user_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // CONTROLLERS

  Get.put(
    AuthController(),
  );

  Get.put(
    TaskController(),
  );

  Get.put(
    ProjectController(),
  );

  Get.put(
    DashboardController(),
  );
  Get.put(
    CreateTaskController(),
  );
  Get.put(
    UserController(),
  );

  runApp(
    const TaskFlowApp(),
  );
}

class TaskFlowApp extends StatelessWidget {
  const TaskFlowApp({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
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
        GetPage(
          name: '/login',
          page: () => const LoginScreen(),
        ),
        GetPage(
          name: '/register',
          page: () => const RegisterScreen(),
        ),
        GetPage(
          name: '/dashboard',
          page: () => const HomeScreen(),
        ),
        GetPage(
          name: '/tasks',
          page: () => const TasksScreen(),
        ),
        GetPage(
          name: '/task-detail',
          page: () => const TaskDetailScreen(),
        ),
        GetPage(
          name: '/create-task',
          page: () => const CreateTaskScreen(),
        ),
        GetPage(
          name: '/profile',
          page: () => const ProfileScreen(),
        ),
      ],
    );
  }
}
