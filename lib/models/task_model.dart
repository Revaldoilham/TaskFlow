// lib/data/models/task_model.dart
class TaskModel {
  final String id;
  final String title;
  final String description;
  final String priority; // Low, Medium, High, Urgent
  final String status;   // Todo, In Progress, Review, Done
  final DateTime? deadline;
  final String? assignedTo;
  final String? assignedName;
  final String? projectId;
  final String? projectName;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final List<String> tags;

  TaskModel({
    required this.id,
    required this.title,
    this.description = '',
    this.priority = 'Medium',
    this.status = 'Todo',
    this.deadline,
    this.assignedTo,
    this.assignedName,
    this.projectId,
    this.projectName,
    required this.createdAt,
    this.updatedAt,
    this.tags = const [],
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) => TaskModel(
    id: json['id'] ?? '',
    title: json['title'] ?? '',
    description: json['description'] ?? '',
    priority: json['priority'] ?? 'Medium',
    status: json['status'] ?? 'Todo',
    deadline: json['deadline'] != null ? DateTime.parse(json['deadline']) : null,
    assignedTo: json['assignedTo'],
    assignedName: json['assignedName'],
    projectId: json['projectId'],
    projectName: json['projectName'],
    createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
    updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    tags: (json['tags'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
  );

  Map<String, dynamic> toJson() => {
    'id': id, 'title': title, 'description': description,
    'priority': priority, 'status': status,
    'deadline': deadline?.toIso8601String(),
    'assignedTo': assignedTo, 'assignedName': assignedName,
    'projectId': projectId, 'projectName': projectName,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
    'tags': tags,
  };

  TaskModel copyWith({
    String? title, String? description, String? priority,
    String? status, DateTime? deadline, String? assignedTo,
    String? assignedName, String? projectId, String? projectName,
    List<String>? tags,
  }) => TaskModel(
    id: id,
    title: title ?? this.title,
    description: description ?? this.description,
    priority: priority ?? this.priority,
    status: status ?? this.status,
    deadline: deadline ?? this.deadline,
    assignedTo: assignedTo ?? this.assignedTo,
    assignedName: assignedName ?? this.assignedName,
    projectId: projectId ?? this.projectId,
    projectName: projectName ?? this.projectName,
    createdAt: createdAt,
    updatedAt: DateTime.now(),
    tags: tags ?? this.tags,
  );

  bool get isOverdue => deadline != null && deadline!.isBefore(DateTime.now()) && status != 'Done';
  bool get isDone => status == 'Done';
}