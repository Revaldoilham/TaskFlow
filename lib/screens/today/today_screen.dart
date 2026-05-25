// today screen
// lib/models/local_task_model.dart

import '/models/subtask_model.dart';

class LocalTaskModel {

final String id;

final String title;

final String description;

final String priority;

final String status;

final String? categoryId;

final String? categoryName;

final DateTime? startDate;

final DateTime? deadline;

final String? startTime;

final String? endTime;

final bool reminderEnabled;

final String repeat;

final List<SubtaskModel> subtasks;

final DateTime createdAt;

final DateTime? updatedAt;

LocalTaskModel({
required this.id,
required this.title,
this.description = '',
this.priority = 'medium',
this.status = 'todo',
this.categoryId,
this.categoryName,
this.startDate,
this.deadline,
this.startTime,
this.endTime,
this.reminderEnabled = false,
this.repeat = 'none',
this.subtasks = const [],
required this.createdAt,
this.updatedAt,
});

// ─────────────────────────────────────
// FROM MAP
// ─────────────────────────────────────

factory LocalTaskModel.fromMap(
Map<String, dynamic> map, {
List<SubtaskModel> subtasks =
const [],
}) {


return LocalTaskModel(
  id: map['id'] ?? '',

  title: map['title'] ?? '',

  description:
      map['description'] ?? '',

  priority:
      map['priority'] ?? 'medium',

  status:
      map['status'] ?? 'todo',

  categoryId:
      map['category_id'],

  categoryName:
      map['category_name'],

  startDate:
      map['start_date'] != null
          ? DateTime.parse(
              map['start_date'],
            )
          : null,

  deadline:
      map['deadline'] != null
          ? DateTime.parse(
              map['deadline'],
            )
          : null,

  startTime:
      map['start_time'],

  endTime:
      map['end_time'],

  reminderEnabled:
      (map['reminder_enabled'] ??
              0) ==
          1,

  repeat:
      map['repeat'] ?? 'none',

  subtasks: subtasks,

  createdAt:
      DateTime.parse(
    map['created_at'],
  ),

  updatedAt:
      map['updated_at'] != null
          ? DateTime.parse(
              map['updated_at'],
            )
          : null,
);


}

// ─────────────────────────────────────
// TO MAP
// ─────────────────────────────────────

Map<String, dynamic> toMap() {


return {
  'id': id,

  'title': title,

  'description': description,

  'priority': priority,

  'status': status,

  'category_id': categoryId,

  'category_name': categoryName,

  'start_date':
      startDate?.toIso8601String(),

  'deadline':
      deadline?.toIso8601String(),

  'start_time': startTime,

  'end_time': endTime,

  'reminder_enabled':
      reminderEnabled ? 1 : 0,

  'repeat': repeat,

  'created_at':
      createdAt.toIso8601String(),

  'updated_at':
      updatedAt?.toIso8601String(),
};


}

// ─────────────────────────────────────
// COPY WITH
// ─────────────────────────────────────

LocalTaskModel copyWith({
String? title,
String? description,
String? priority,
String? status,
String? categoryId,
String? categoryName,
DateTime? startDate,
DateTime? deadline,
String? startTime,
String? endTime,
bool? reminderEnabled,
String? repeat,
List<SubtaskModel>? subtasks,
}) {


return LocalTaskModel(
  id: id,

  title:
      title ?? this.title,

  description:
      description ??
          this.description,

  priority:
      priority ??
          this.priority,

  status:
      status ?? this.status,

  categoryId:
      categoryId ??
          this.categoryId,

  categoryName:
      categoryName ??
          this.categoryName,

  startDate:
      startDate ??
          this.startDate,

  deadline:
      deadline ??
          this.deadline,

  startTime:
      startTime ??
          this.startTime,

  endTime:
      endTime ??
          this.endTime,

  reminderEnabled:
      reminderEnabled ??
          this.reminderEnabled,

  repeat:
      repeat ?? this.repeat,

  subtasks:
      subtasks ??
          this.subtasks,

  createdAt:
      createdAt,

  updatedAt:
      DateTime.now(),
);


}

// ─────────────────────────────────────
// HELPERS
// ─────────────────────────────────────

bool get isDone =>
status == 'done';

bool get isOverdue {


if (deadline == null) {
  return false;
}

if (isDone) {
  return false;
}

return deadline!.isBefore(
  DateTime.now(),
);


}

bool get isRisk {


if (deadline == null) {
  return false;
}

if (isDone) {
  return false;
}

final diff =
    deadline!.difference(
  DateTime.now(),
);

return diff.inHours <= 24;


}

int get subtaskDone {


return subtasks.where(
  (subtask) =>
      subtask.isDone,
).length;


}

double get subtaskProgress {


if (subtasks.isEmpty) {
  return 0.0;
}

return subtaskDone /
    subtasks.length;


}
}
