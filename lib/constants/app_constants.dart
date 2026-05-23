// lib/core/constants/app_constants.dart
class AppConstants {
  static const String appName = 'TaskFlow';
  static const String appSlogan = 'Manage Your Productivity Smarter';
  static const String baseUrl = 'http://localhost:3000/api';
  
  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String rememberMeKey = 'remember_me';
  
  // Routes
  static const String splashRoute = '/splash';
  static const String loginRoute = '/login';
  static const String registerRoute = '/register';
  static const String dashboardRoute = '/dashboard';
  static const String tasksRoute = '/tasks';
  static const String taskDetailRoute = '/task-detail';
  static const String addTaskRoute = '/add-task';
  static const String editTaskRoute = '/edit-task';
  static const String projectsRoute = '/projects';
  static const String projectDetailRoute = '/project-detail';
  static const String profileRoute = '/profile';
  
  // Priorities
  static const List<String> priorities = ['Low', 'Medium', 'High', 'Urgent'];
  static const List<String> statuses = ['Todo', 'In Progress', 'Review', 'Done'];
}