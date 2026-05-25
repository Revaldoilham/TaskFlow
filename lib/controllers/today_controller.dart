// today controller
// lib/controllers/today_controller.dart

import 'package:get/get.dart';

import '../models/local_task_model.dart';
import '../repositories/local_task_repository.dart';

class TodayController extends GetxController {

final LocalTaskRepository _repo =
LocalTaskRepository();

// ─────────────────────────────────────
// STATE
// ─────────────────────────────────────

final RxBool isLoading = false.obs;

final RxList<LocalTaskModel> todayTasks = <LocalTaskModel>[].obs;

final RxList<LocalTaskModel> focusTasks = <LocalTaskModel>[].obs;

final RxList<LocalTaskModel> riskTasks = <LocalTaskModel>[].obs;

final RxInt totalToday = 0.obs;

final RxInt completedToday = 0.obs;

final RxInt pendingToday = 0.obs;

// ─────────────────────────────────────
// LIFECYCLE
// ─────────────────────────────────────

@override
void onInit() {
super.onInit();


loadToday();


}

// ─────────────────────────────────────
// LOAD TODAY DATA
// ─────────────────────────────────────

Future<void> loadToday() async {
isLoading.value = true;


try {
  final tasks =
      await _repo.getToday();

  todayTasks.assignAll(tasks);

  _calculateStatistics(tasks);

  _loadFocusTasks(tasks);

  _loadRiskTasks(tasks);

} catch (e) {
  Get.snackbar(
    'Error',
    e.toString(),
  );
} finally {
  isLoading.value = false;
}


}

// ─────────────────────────────────────
// TOGGLE TASK STATUS
// ─────────────────────────────────────

Future<void> toggleTaskDone(
LocalTaskModel task,
) async {


final newStatus =
    task.isDone ? 'todo' : 'done';

await _repo.updateStatus(
  task.id,
  newStatus,
);

await loadToday();


}

// ─────────────────────────────────────
// STATISTICS
// ─────────────────────────────────────

void _calculateStatistics(
List<LocalTaskModel> tasks,
) {


totalToday.value =
    tasks.length;

completedToday.value =
    tasks.where(
      (task) => task.isDone,
    ).length;

pendingToday.value =
    tasks.where(
      (task) => !task.isDone,
    ).length;


}

// ─────────────────────────────────────
// FOCUS TASKS
// ─────────────────────────────────────

void _loadFocusTasks(
List<LocalTaskModel> tasks,
) {


final focus =
    tasks.where(
      (task) => !task.isDone,
    ).toList();

focus.sort(
  (a, b) =>
      _priorityWeight(
        b.priority,
      ).compareTo(
        _priorityWeight(
          a.priority,
        ),
      ),
);

focusTasks.assignAll(
  focus.take(3).toList(),
);


}

// ─────────────────────────────────────
// RISK TASKS
// ─────────────────────────────────────

void _loadRiskTasks(
List<LocalTaskModel> tasks,
) {


riskTasks.assignAll(
  tasks.where(
    (task) =>
        task.isRisk &&
        !task.isDone,
  ),
);


}

// ─────────────────────────────────────
// DAILY PROGRESS
// ─────────────────────────────────────

double get dailyProgress {


if (totalToday.value == 0) {
  return 0.0;
}

return completedToday.value /
    totalToday.value;


}

// ─────────────────────────────────────
// TIMELINE TASKS
// ─────────────────────────────────────

List<LocalTaskModel>
get timelineTasks {


final tasks =
    todayTasks.where(
  (task) =>
      task.startTime != null ||
      task.endTime != null,
).toList();

tasks.sort(
  (a, b) =>
      (a.startTime ?? '')
          .compareTo(
    b.startTime ?? '',
  ),
);

return tasks;


}

// ─────────────────────────────────────
// PRIORITY HELPER
// ─────────────────────────────────────

int _priorityWeight(
String priority,
) {


switch (priority) {

  case 'high':
    return 3;

  case 'medium':
    return 2;

  case 'low':
    return 1;

  default:
    return 0;
}


}
}
