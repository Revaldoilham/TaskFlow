// categories screen
// lib/screens/categories/categories_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_constants.dart';

import '../../controllers/category_controller.dart';

import '../../models/category_model.dart';

import '../../widgets/app_widgets.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final CategoryController ctrl = Get.find<CategoryController>();

    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // HEADER

            Padding(
              padding: const EdgeInsets.fromLTRB(
                20,
                20,
                20,
                0,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Categories',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color:
                                isDark ? Colors.white : AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Obx(
                          () => Text(
                            '${ctrl.categories.length} kategori',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      ctrl.clearForNew();

                      _showCategoryForm(
                        context,
                        ctrl,
                        null,
                        isDark,
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 16,
            ),

            // BODY

            Expanded(
              child: Obx(() {
                if (ctrl.isLoading.value) {
                  return ListView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    children: List.generate(
                      3,
                      (_) => const SkeletonCard(),
                    ),
                  );
                }

                if (ctrl.categories.isEmpty) {
                  return EmptyState(
                    title: 'Belum ada kategori',
                    subtitle: 'Buat kategori untuk mengelompokkan task',
                    icon: Icons.folder_outlined,
                    actionLabel: '+ Buat Kategori',
                    onAction: () {
                      ctrl.clearForNew();

                      _showCategoryForm(
                        context,
                        ctrl,
                        null,
                        isDark,
                      );
                    },
                  );
                }

                return RefreshIndicator(
                  color: AppColors.primary,
                  onRefresh: ctrl.loadCategories,
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(
                      20,
                      0,
                      20,
                      100,
                    ),
                    itemCount: ctrl.categories.length,
                    itemBuilder: (_, index) {
                      final category = ctrl.categories[index];

                      return _CategoryCard(
                        category: category,
                        isDark: isDark,
                        onTap: () {
                          ctrl.selectCategory(
                            category,
                          );

                          Get.toNamed(
                            AppConstants.categoryDetailRoute,
                            arguments: category,
                          );
                        },
                        onEdit: () {
                          ctrl.prepareEdit(
                            category,
                          );

                          _showCategoryForm(
                            context,
                            ctrl,
                            category,
                            isDark,
                          );
                        },
                        onDelete: () {
                          ctrl.deleteCategory(
                            category.id,
                          );
                        },
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

// ─────────────────────────────────────
// SHOW CATEGORY FORM
// ─────────────────────────────────────

  void _showCategoryForm(
    BuildContext context,
    CategoryController ctrl,
    CategoryModel? category,
    bool isDark,
  ) {
    Get.bottomSheet(
      _CategoryFormSheet(
        ctrl: ctrl,
        existing: category,
        isDark: isDark,
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }
}

// ─────────────────────────────────────
// CATEGORY CARD
// ─────────────────────────────────────

class _CategoryCard extends StatelessWidget {
  final CategoryModel category;

  final VoidCallback onTap;

  final VoidCallback onEdit;

  final VoidCallback onDelete;

  final bool isDark;

  const _CategoryCard({
    required this.category,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(
          bottom: 12,
        ),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : Colors.white,
          borderRadius: BorderRadius.circular(
            18,
          ),
          boxShadow: AppColors.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              category.name,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : AppColors.textPrimary,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            LinearProgressIndicator(
              value: category.progress,
              minHeight: 6,
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              '${category.completedCount}/${category.taskCount} selesai',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryFormSheet extends StatelessWidget {
  final CategoryController ctrl;

  final CategoryModel? existing;

  final bool isDark;

  const _CategoryFormSheet({
    required this.ctrl,
    required this.existing,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            Text(
              existing == null ? 'Tambah Kategori' : 'Edit Kategori',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : AppColors.textPrimary,
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            AppTextField(
              label: 'Nama Kategori',
              hint: 'Masukkan nama kategori',
              controller: ctrl.nameController,
            ),
            const SizedBox(
              height: 16,
            ),
            AppTextField(
              label: 'Deskripsi',
              hint: 'Masukkan deskripsi',
              controller: ctrl.descController,
              maxLines: 3,
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'Warna',
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : AppColors.textPrimary,
              ),
            ),
            const SizedBox(
              height: 14,
            ),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                '#2563EB',
                '#7C3AED',
                '#059669',
                '#DC2626',
                '#EA580C',
                '#DB2777',
              ].map((color) {
                final selected = ctrl.selectedColor.value == color;

                return GestureDetector(
                  onTap: () {
                    ctrl.selectedColor.value = color;
                  },
                  child: Obx(
                    () => Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: Color(
                          int.parse(
                            'FF${color.replaceFirst('#', '')}',
                            radix: 16,
                          ),
                        ),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: selected ? Colors.white : Colors.transparent,
                          width: 3,
                        ),
                      ),
                      child: selected
                          ? const Icon(
                              Icons.check,
                              color: Colors.white,
                            )
                          : null,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(
              height: 28,
            ),
            Obx(() => GradientButton(
                  text: ctrl.isSubmitting.value
                      ? 'Loading...'
                      : existing == null
                          ? 'Simpan'
                          : 'Update',
                  onTap: () {
                    if (ctrl.isSubmitting.value) {
                      return;
                    }

                    if (existing == null) {
                      ctrl.createCategory();
                    } else {
                      ctrl.updateCategory(
                        existing!,
                      );
                    }
                  },
                )),
          ],
        ),
      ),
    );
  }
}
