// lib/data/repositories/task_repository.dart
import '../models/task_model.dart';
import '../providers/mock_data_provider.dart';

class TaskRepository {
  static final List<TaskModel> _tasks = List.from(MockDataProvider.tasks);

  Future<List<TaskModel>> getTasks() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return List.from(_tasks);
  }

  Future<TaskModel?> getTaskById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _tasks.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<TaskModel> createTask(TaskModel task) async {
    await Future.delayed(const Duration(milliseconds: 600));
    _tasks.insert(0, task);
    return task;
  }

  Future<TaskModel> updateTask(TaskModel task) async {
    await Future.delayed(const Duration(milliseconds: 600));
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
    }
    return task;
  }

  Future<void> deleteTask(String id) async {
    await Future.delayed(const Duration(milliseconds: 400));
    _tasks.removeWhere((t) => t.id == id);
  }

  Future<TaskModel> updateStatus(String id, String status) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      final updated = _tasks[index].copyWith(status: status);
      _tasks[index] = updated;
      return updated;
    }
    throw Exception('Task not found');
  }

  Future<List<TaskModel>> searchTasks(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _tasks.where((t) =>
      t.title.toLowerCase().contains(query.toLowerCase()) ||
      t.description.toLowerCase().contains(query.toLowerCase()) ||
      (t.projectName?.toLowerCase().contains(query.toLowerCase()) ?? false),
    ).toList();
  }

  Future<List<TaskModel>> filterTasks({String? status, String? priority, String? projectId}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _tasks.where((t) {
      if (status != null && status != 'All' && t.status != status) return false;
      if (priority != null && priority != 'All' && t.priority != priority) return false;
      if (projectId != null && t.projectId != projectId) return false;
      return true;
    }).toList();
  }

  Map<String, int> getStats() {
    return {
      'total': _tasks.length,
      'todo': _tasks.where((t) => t.status == 'Todo').length,
      'inProgress': _tasks.where((t) => t.status == 'In Progress').length,
      'review': _tasks.where((t) => t.status == 'Review').length,
      'done': _tasks.where((t) => t.status == 'Done').length,
      'overdue': _tasks.where((t) => t.isOverdue).length,
    };
  }
}