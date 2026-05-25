// category model
// lib/models/category_model.dart

class CategoryModel {

final String id;

final String name;

final String description;

final String color;

final int taskCount;

final int completedCount;

final DateTime createdAt;

CategoryModel({
required this.id,
required this.name,
this.description = '',
this.color = '#2563EB',
this.taskCount = 0,
this.completedCount = 0,
required this.createdAt,
});

// ─────────────────────────────────────
// FROM MAP
// ─────────────────────────────────────

factory CategoryModel.fromMap(
Map<String, dynamic> map,
) {


return CategoryModel(
  id: map['id'] ?? '',

  name: map['name'] ?? '',

  description:
      map['description'] ?? '',

  color:
      map['color'] ?? '#2563EB',

  taskCount:
      map['task_count'] ?? 0,

  completedCount:
      map['completed_count'] ?? 0,

  createdAt:
      DateTime.parse(
    map['created_at'],
  ),
);


}

// ─────────────────────────────────────
// TO MAP
// ─────────────────────────────────────

Map<String, dynamic> toMap() {


return {
  'id': id,

  'name': name,

  'description': description,

  'color': color,

  'created_at':
      createdAt.toIso8601String(),
};


}

// ─────────────────────────────────────
// COPY WITH
// ─────────────────────────────────────

CategoryModel copyWith({
String? name,
String? description,
String? color,
int? taskCount,
int? completedCount,
}) {


return CategoryModel(
  id: id,

  name: name ?? this.name,

  description:
      description ??
          this.description,

  color:
      color ?? this.color,

  taskCount:
      taskCount ?? this.taskCount,

  completedCount:
      completedCount ??
          this.completedCount,

  createdAt: createdAt,
);


}

// ─────────────────────────────────────
// PROGRESS
// ─────────────────────────────────────

double get progress {


if (taskCount == 0) {
  return 0.0;
}

return completedCount / taskCount;


}
}
