// lib/constants/app_constants.dart

class AppConstants {

// ─────────────────────────────────────
// APP INFO
// ─────────────────────────────────────

static const String appName =
'TaskFlow';

static const String appSlogan =
'Manage Your Productivity Smarter';

static const String baseUrl =
'https://k6f90jg9-3000.asse.devtunnels.ms/api';

// ─────────────────────────────────────
// STORAGE KEYS
// ─────────────────────────────────────

static const String tokenKey =
'auth_token';

static const String userKey =
'user_data';

static const String rememberMeKey =
'remember_me';

// ─────────────────────────────────────
// OLD ROUTES
// ─────────────────────────────────────

static const String splashRoute =
'/splash';

static const String loginRoute =
'/login';

static const String registerRoute =
'/register';

static const String dashboardRoute =
'/dashboard';

static const String tasksRoute =
'/tasks';

static const String taskDetailRoute =
'/task-detail';

static const String addTaskRoute =
'/add-task';

static const String editTaskRoute =
'/edit-task';

static const String projectsRoute =
'/projects';

static const String projectDetailRoute =
'/project-detail';

static const String profileRoute =
'/profile';

// ─────────────────────────────────────
// NEW ROUTES
// ─────────────────────────────────────

static const String todayRoute =
'/today';

static const String categoriesRoute =
'/categories';

static const String categoryDetailRoute =
'/category-detail';

static const String createTaskRoute =
'/create-task';

static const String editLocalTaskRoute =
'/edit-local-task';

// ─────────────────────────────────────
// OLD PRIORITIES
// ─────────────────────────────────────

static const List<String>
priorities = [
'Low',
'Medium',
'High',
'Urgent',
];

static const List<String>
statuses = [
'Todo',
'In Progress',
'Review',
'Done',
];

// ─────────────────────────────────────
// LOCAL PRIORITIES
// ─────────────────────────────────────

static const List<String>
localPriorities = [
'low',
'medium',
'high',
];

static const List<String>
localStatuses = [
'todo',
'in_progress',
'done',
];

static const List<String>
repeatOptions = [
'none',
'daily',
'weekly',
'monthly',
];

// ─────────────────────────────────────
// PRIORITY LABELS
// ─────────────────────────────────────

static const Map<String, String>
priorityLabels = {


'low': 'Low',

'medium': 'Medium',

'high': 'High',


};

// ─────────────────────────────────────
// STATUS LABELS
// ─────────────────────────────────────

static const Map<String, String>
statusLabels = {


'todo': 'Todo',

'in_progress':
    'In Progress',

'done': 'Done',


};

// ─────────────────────────────────────
// REPEAT LABELS
// ─────────────────────────────────────

static const Map<String, String>
repeatLabels = {


'none':
    'Tidak Berulang',

'daily':
    'Setiap Hari',

'weekly':
    'Setiap Minggu',

'monthly':
    'Setiap Bulan',


};
}
