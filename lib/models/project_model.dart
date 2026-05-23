// lib/data/models/project_model.dart
class ProjectModel {
  final String id;
  final String name;
  final String description;
  final String color;
  final double progress;
  final int totalTasks;
  final int completedTasks;
  final List<String> members;
  final List<String> memberNames;
  final DateTime? deadline;
  final DateTime createdAt;
  final String status; // Active, On Hold, Completed

  ProjectModel({
    required this.id,
    required this.name,
    this.description = '',
    this.color = '#2563EB',
    this.progress = 0.0,
    this.totalTasks = 0,
    this.completedTasks = 0,
    this.members = const [],
    this.memberNames = const [],
    this.deadline,
    required this.createdAt,
    this.status = 'Active',
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) => ProjectModel(
    id: json['id'] ?? '',
    name: json['name'] ?? '',
    description: json['description'] ?? '',
    color: json['color'] ?? '#2563EB',
    progress: (json['progress'] ?? 0.0).toDouble(),
    totalTasks: json['totalTasks'] ?? 0,
    completedTasks: json['completedTasks'] ?? 0,
    members: (json['members'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
    memberNames: (json['memberNames'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
    deadline: json['deadline'] != null ? DateTime.parse(json['deadline']) : null,
    createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
    status: json['status'] ?? 'Active',
  );

  Map<String, dynamic> toJson() => {
    'id': id, 'name': name, 'description': description,
    'color': color, 'progress': progress,
    'totalTasks': totalTasks, 'completedTasks': completedTasks,
    'members': members, 'memberNames': memberNames,
    'deadline': deadline?.toIso8601String(),
    'createdAt': createdAt.toIso8601String(),
    'status': status,
  };

  double get calculatedProgress => totalTasks > 0 ? completedTasks / totalTasks : 0.0;
}