
// lib/controllers/create_task_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/local_task_model.dart';
import '../models/subtask_model.dart';
import '../models/category_model.dart';
import '../repositories/local_task_repository.dart';
import '../repositories/category_repository.dart';

class CreateTaskController extends GetxController {
  final LocalTaskRepository _taskRepo = LocalTaskRepository();
  final CategoryRepository _catRepo = CategoryRepository();

  // Form controllers
  final titleController = TextEditingController();
  final descController = TextEditingController();
  final subtaskController = TextEditingController();

  // Reactive form state
  final RxString priority = 'medium'.obs;
  final RxString repeat = 'none'.obs;
  final Rx<DateTime?> startDate = Rx<DateTime?>(null);
  final Rx<DateTime?> deadline = Rx<DateTime?>(null);
  final RxString startTime = ''.obs;
  final RxString endTime = ''.obs;
  final RxBool reminderEnabled = false.obs;
  final Rx<CategoryModel?> selectedCategory = Rx<CategoryModel?>(null);
  final RxList<SubtaskModel> subtasks = <SubtaskModel>[].obs;
  final RxList<CategoryModel> categories = <CategoryModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isSubmitting = false.obs;

  // Edit mode
  LocalTaskModel? editingTask;

  @override
  void onInit() {
    super.onInit();
    loadCategories();
  }

  Future<void> loadCategories() async {
    isLoading.value = true;
    try {
      final result = await _catRepo.getAll();
      categories.assignAll(result);
    } finally {
      isLoading.value = false;
    }
  }

  void addSubtask() {
    final text = subtaskController.text.trim();
    if (text.isEmpty) return;
    subtasks.add(SubtaskModel(
      id: '',
      taskId: '',
      title: text,
    ));
    subtaskController.clear();
  }

  void removeSubtask(int index) {
    subtasks.removeAt(index);
  }

  void reorderSubtask(int oldIdx, int newIdx) {
    if (newIdx > oldIdx) newIdx--;
    final item = subtasks.removeAt(oldIdx);
    subtasks.insert(newIdx, item);
  }

  Future<void> saveTask() async {
    if (!_validate()) return;
    isSubmitting.value = true;
    try {
      final task = LocalTaskModel(
        id: editingTask?.id ?? '',
        title: titleController.text.trim(),
        description: descController.text.trim(),
        priority: priority.value,
        status: editingTask?.status ?? 'todo',
        categoryId: selectedCategory.value?.id,
        categoryName: selectedCategory.value?.name,
        startDate: startDate.value,
        deadline: deadline.value,
        startTime: startTime.value.isEmpty ? null : startTime.value,
        endTime: endTime.value.isEmpty ? null : endTime.value,
        reminderEnabled: reminderEnabled.value,
        repeat: repeat.value,
        createdAt: editingTask?.createdAt ?? DateTime.now(),
        subtasks: subtasks.toList(),
      );

      if (editingTask != null) {
        await _taskRepo.update(task);
      } else {
        await _taskRepo.create(task);
      }
      _clearAll();
      Get.back(result: true);
      Get.snackbar(
        'Berhasil',
        editingTask != null ? 'Task berhasil diperbarui' : 'Task berhasil dibuat',
        backgroundColor: Colors.green.shade50,
        colorText: Colors.green.shade700,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isSubmitting.value = false;
    }
  }

  void prepareEdit(LocalTaskModel task) {
    editingTask = task;
    titleController.text = task.title;
    descController.text = task.description;
    priority.value = task.priority;
    repeat.value = task.repeat;
    startDate.value = task.startDate;
    deadline.value = task.deadline;
    startTime.value = task.startTime ?? '';
    endTime.value = task.endTime ?? '';
    reminderEnabled.value = task.reminderEnabled;
    subtasks.assignAll(task.subtasks);
    if (task.categoryId != null) {
      try {
        selectedCategory.value =
            categories.firstWhere((c) => c.id == task.categoryId);
      } catch (_) {}
    }
  }

  void initForNew() {
    editingTask = null;
    _clearAll();
  }

  bool _validate() {
    if (titleController.text.trim().isEmpty) {
      Get.snackbar('Validasi', 'Judul task wajib diisi',
          backgroundColor: Colors.red.shade50, colorText: Colors.red);
      return false;
    }
    if (deadline.value != null &&
        startDate.value != null &&
        deadline.value!.isBefore(startDate.value!)) {
      Get.snackbar('Validasi', 'Deadline tidak boleh sebelum tanggal mulai',
          backgroundColor: Colors.red.shade50, colorText: Colors.red);
      return false;
    }
    return true;
  }

  void _clearAll() {
    titleController.clear();
    descController.clear();
    subtaskController.clear();
    priority.value = 'medium';
    repeat.value = 'none';
    startDate.value = null;
    deadline.value = null;
    startTime.value = '';
    endTime.value = '';
    reminderEnabled.value = false;
    selectedCategory.value = null;
    subtasks.clear();
    editingTask = null;
  }

  @override
  void onClose() {
    titleController.dispose();
    descController.dispose();
    subtaskController.dispose();
    super.onClose();
  }
}
