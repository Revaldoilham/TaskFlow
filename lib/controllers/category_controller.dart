// lib/controllers/category_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/category_model.dart';
import '../models/local_task_model.dart';

import '../repositories/category_repository.dart';
import '../repositories/local_task_repository.dart';

class CategoryController
extends GetxController {

final CategoryRepository _catRepo =
CategoryRepository();

final LocalTaskRepository _taskRepo =
LocalTaskRepository();

// ─────────────────────────────────────
// STATE
// ─────────────────────────────────────

final RxList<CategoryModel>
categories = <CategoryModel>[].obs;

final Rx<CategoryModel?>
selectedCategory =
Rx<CategoryModel?>(null);

final RxList<LocalTaskModel>
categoryTasks = <LocalTaskModel>[].obs;

final RxBool isLoading =
false.obs;

final RxBool isSubmitting =
false.obs;

// ─────────────────────────────────────
// FORM CONTROLLER
// ─────────────────────────────────────

final TextEditingController
nameController =
TextEditingController();

final TextEditingController
descController =
TextEditingController();

final RxString selectedColor =
'#2563EB'.obs;

// ─────────────────────────────────────
// LIFECYCLE
// ─────────────────────────────────────

@override
void onInit() {
super.onInit();


loadCategories();


}

// ─────────────────────────────────────
// LOAD CATEGORY
// ─────────────────────────────────────

Future<void>
loadCategories() async {


isLoading.value = true;

try {

  final result =
      await _catRepo.getAll();

  categories.assignAll(
    result,
  );

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
// LOAD TASK BY CATEGORY
// ─────────────────────────────────────

Future<void>
loadCategoryTasks(
String categoryId,
) async {


final tasks =
    await _taskRepo
        .getByCategory(
  categoryId,
);

categoryTasks.assignAll(
  tasks,
);

}

// ─────────────────────────────────────
// SELECT CATEGORY
// ─────────────────────────────────────

Future<void> selectCategory(
CategoryModel category,
) async {


selectedCategory.value =
    category;

await loadCategoryTasks(
  category.id,
);


}

// ─────────────────────────────────────
// CREATE CATEGORY
// ─────────────────────────────────────

Future<void>
createCategory() async {


if (!_validateForm()) {
  return;
}

isSubmitting.value = true;

try {

  await _catRepo.create(
    name:
        nameController.text
            .trim(),

    description:
        descController.text
            .trim(),

    color:
        selectedColor.value,
  );

  await loadCategories();

  _clearForm();

  Get.back();

  Get.snackbar(
    'Berhasil',
    'Kategori berhasil dibuat',

    backgroundColor:
        Colors.green.shade50,

    colorText:
        Colors.green.shade700,

    duration:
        const Duration(
      seconds: 2,
    ),
  );

} catch (e) {

  Get.snackbar(
    'Error',
    e.toString(),
  );

} finally {

  isSubmitting.value =
      false;
}


}

// ─────────────────────────────────────
// UPDATE CATEGORY
// ─────────────────────────────────────

Future<void>
updateCategory(
CategoryModel category,
) async {


if (!_validateForm()) {
  return;
}

isSubmitting.value = true;

try {

  final updated =
      category.copyWith(
    name:
        nameController.text
            .trim(),

    description:
        descController.text
            .trim(),

    color:
        selectedColor.value,
  );

  await _catRepo.update(
    updated,
  );

  await loadCategories();

  _clearForm();

  Get.back();

  Get.snackbar(
    'Berhasil',
    'Kategori berhasil diperbarui',

    backgroundColor:
        Colors.green.shade50,

    colorText:
        Colors.green.shade700,

    duration:
        const Duration(
      seconds: 2,
    ),
  );

} catch (e) {

  Get.snackbar(
    'Error',
    e.toString(),
  );

} finally {

  isSubmitting.value =
      false;
}


}

// ─────────────────────────────────────
// DELETE CATEGORY
// ─────────────────────────────────────

Future<void>
deleteCategory(
String id,
) async {


try {

  await _catRepo.delete(
    id,
  );

  categories.removeWhere(
    (category) =>
        category.id == id,
  );

  Get.snackbar(
    'Berhasil',
    'Kategori berhasil dihapus',

    backgroundColor:
        Colors.orange.shade50,

    colorText:
        Colors.orange.shade700,

    duration:
        const Duration(
      seconds: 2,
    ),
  );

} catch (e) {

  Get.snackbar(
    'Error',
    e.toString(),
  );
}


}

// ─────────────────────────────────────
// PREPARE EDIT
// ─────────────────────────────────────

void prepareEdit(
CategoryModel category,
) {


nameController.text =
    category.name;

descController.text =
    category.description;

selectedColor.value =
    category.color;


}

// ─────────────────────────────────────
// CLEAR FORM
// ─────────────────────────────────────

void clearForNew() {


_clearForm();


}

void _clearForm() {


nameController.clear();

descController.clear();

selectedColor.value =
    '#2563EB';

}

// ─────────────────────────────────────
// VALIDATION
// ─────────────────────────────────────

bool _validateForm() {


if (nameController.text
    .trim()
    .isEmpty) {

  Get.snackbar(
    'Validasi',
    'Nama kategori wajib diisi',
  );

  return false;
}

return true;


}

// ─────────────────────────────────────
// DISPOSE
// ─────────────────────────────────────

@override
void onClose() {


nameController.dispose();

descController.dispose();

super.onClose();


}
}
