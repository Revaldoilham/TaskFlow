// lib/models/subtask_model.dart

class SubtaskModel {

final String id;

final String taskId;

final String title;

final bool isDone;

final int sortOrder;

SubtaskModel({
required this.id,
required this.taskId,
required this.title,
this.isDone = false,
this.sortOrder = 0,
});

factory SubtaskModel.fromMap(
Map<String, dynamic> map,
) {


return SubtaskModel(
  id: map['id'] ?? '',

  taskId:
      map['task_id'] ?? '',

  title:
      map['title'] ?? '',

  isDone:
      (map['is_done'] ?? 0) == 1,

  sortOrder:
      map['sort_order'] ?? 0,
);


}

Map<String, dynamic> toMap() {


return {
  'id': id,

  'task_id': taskId,

  'title': title,

  'is_done':
      isDone ? 1 : 0,

  'sort_order':
      sortOrder,
};


}

SubtaskModel copyWith({
String? title,
bool? isDone,
}) {


return SubtaskModel(
  id: id,

  taskId: taskId,

  title:
      title ?? this.title,

  isDone:
      isDone ?? this.isDone,

  sortOrder: sortOrder,
);


}
}
