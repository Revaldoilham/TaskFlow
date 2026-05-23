// lib/modules/tasks/task_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '/models/task_model.dart';
import '/repositories/task_repository.dart';
import '/constants/app_constants.dart';

class TaskController extends GetxController {
  final TaskRepository _repo = TaskRepository();
  final _uuid = const Uuid();

  final RxList<TaskModel> tasks = <TaskModel>[].obs;
  final RxList<TaskModel> filteredTasks = <TaskModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isSubmitting = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString selectedStatus = 'All'.obs;
  final RxString selectedPriority = 'All'.obs;
  final RxString searchQuery = ''.obs;
  final Rx<Map<String, int>> stats = Rx<Map<String, int>>({});

  // Form fields
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final Rx<String> formPriority = 'Medium'.obs;
  final Rx<String> formStatus = 'Todo'.obs;
  final Rx<DateTime?> formDeadline = Rx<DateTime?>(null);
  final Rx<String?> formProjectId = Rx<String?>(null);

  @override
  void onInit() {
    super.onInit();
    loadTasks();
    debounce(searchQuery, (_) => _applyFilters(), time: const Duration(milliseconds: 300));
  }

  Future<void> loadTasks() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final result = await _repo.getTasks();
      tasks.assignAll(result);
      stats.value = _repo.getStats();
      _applyFilters();
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void _applyFilters() {
    var filtered = tasks.toList();
    
    if (searchQuery.value.isNotEmpty) {
      filtered = filtered.where((t) =>
        t.title.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
        t.description.toLowerCase().contains(searchQuery.value.toLowerCase()),
      ).toList();
    }
    
    if (selectedStatus.value != 'All') {
      filtered = filtered.where((t) => t.status == selectedStatus.value).toList();
    }
    
    if (selectedPriority.value != 'All') {
      filtered = filtered.where((t) => t.priority == selectedPriority.value).toList();
    }
    
    filteredTasks.assignAll(filtered);
  }

  void setStatusFilter(String status) {
    selectedStatus.value = status;
    _applyFilters();
  }

  void setPriorityFilter(String priority) {
    selectedPriority.value = priority;
    _applyFilters();
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
  }

  Future<void> createTask() async {
    if (titleController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Task title is required',
        backgroundColor: Colors.red.shade50, colorText: Colors.red);
      return;
    }
    
    isSubmitting.value = true;
    try {
      final task = TaskModel(
        id: _uuid.v4(),
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        priority: formPriority.value,
        status: formStatus.value,
        deadline: formDeadline.value,
        projectId: formProjectId.value,
        createdAt: DateTime.now(),
      );
      await _repo.createTask(task);
      await loadTasks();
      _clearForm();
      Get.back();
      Get.snackbar('Success', 'Task created successfully',
        backgroundColor: Colors.green.shade50, colorText: Colors.green.shade700,
        duration: const Duration(seconds: 2));
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> updateTask(String taskId) async {
    if (titleController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Task title is required');
      return;
    }

    isSubmitting.value = true;
    try {
      final existing = tasks.firstWhere((t) => t.id == taskId);
      final updated = existing.copyWith(
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        priority: formPriority.value,
        status: formStatus.value,
        deadline: formDeadline.value,
      );
      await _repo.updateTask(updated);
      await loadTasks();
      Get.back();
      Get.snackbar('Success', 'Task updated successfully',
        backgroundColor: Colors.green.shade50, colorText: Colors.green.shade700);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> deleteTask(String id) async {
    try {
      await _repo.deleteTask(id);
      tasks.removeWhere((t) => t.id == id);
      stats.value = _repo.getStats();
      _applyFilters();
      Get.snackbar('Deleted', 'Task has been removed',
        backgroundColor: Colors.orange.shade50, colorText: Colors.orange.shade700);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> updateStatus(String id, String status) async {
    try {
      final updated = await _repo.updateStatus(id, status);
      final index = tasks.indexWhere((t) => t.id == id);
      if (index != -1) tasks[index] = updated;
      stats.value = _repo.getStats();
      _applyFilters();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  void prepareEditTask(TaskModel task) {
    titleController.text = task.title;
    descriptionController.text = task.description;
    formPriority.value = task.priority;
    formStatus.value = task.status;
    formDeadline.value = task.deadline;
    formProjectId.value = task.projectId;
  }

  void _clearForm() {
    titleController.clear();
    descriptionController.clear();
    formPriority.value = 'Medium';
    formStatus.value = 'Todo';
    formDeadline.value = null;
    formProjectId.value = null;
  }

  void clearFormForNew() => _clearForm();

  List<TaskModel> get upcomingTasks {
    return tasks.where((t) =>
      t.status != 'Done' &&
      t.deadline != null &&
      t.deadline!.isAfter(DateTime.now()),
    ).toList()
      ..sort((a, b) => a.deadline!.compareTo(b.deadline!));
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}