// category detail screen
// lib/screens/categories/category_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_constants.dart';

import '../../controllers/category_controller.dart';

import '../../models/category_model.dart';
import '../../models/local_task_model.dart';

import '../../widgets/app_widgets.dart';

class CategoryDetailScreen
extends StatelessWidget {

const CategoryDetailScreen({
super.key,
});

@override
Widget build(BuildContext context) {


final CategoryModel category =
    Get.arguments
        as CategoryModel;

final CategoryController ctrl =
    Get.find<CategoryController>();

final bool isDark =
    Theme.of(context).brightness ==
        Brightness.dark;

final Color color =
    Color(
  int.parse(
    'FF${category.color.replaceFirst('#', '')}',
    radix: 16,
  ),
);

return Scaffold(
  backgroundColor:
      isDark
          ? AppColors.backgroundDark
          : AppColors.background,

  body: CustomScrollView(
    slivers: [

      // APP BAR

      SliverAppBar(
        expandedHeight: 160,

        pinned: true,

        backgroundColor: color,

        foregroundColor:
            Colors.white,

        flexibleSpace:
            FlexibleSpaceBar(
          background: Container(
            decoration:
                BoxDecoration(
              gradient:
                  LinearGradient(
                colors: [
                  color,
                  color.withOpacity(
                    0.7,
                  ),
                ],
              ),
            ),

            padding:
                const EdgeInsets
                    .fromLTRB(
              20,
              80,
              20,
              20,
            ),

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,

              mainAxisAlignment:
                  MainAxisAlignment
                      .end,

              children: [

                Text(
                  category.name,

                  style:
                      GoogleFonts
                          .plusJakartaSans(
                    fontSize: 24,

                    fontWeight:
                        FontWeight
                            .w800,

                    color:
                        Colors.white,
                  ),
                ),

                if (category
                    .description
                    .isNotEmpty)

                  Text(
                    category
                        .description,

                    style:
                        GoogleFonts
                            .plusJakartaSans(
                      fontSize: 13,

                      color: Colors
                          .white
                          .withOpacity(
                        0.8,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),

        actions: [

          IconButton(
            onPressed: () {

              Get.toNamed(
                AppConstants
                    .createTaskRoute,
              );
            },

            icon:
                const Icon(
              Icons.add,
            ),
          ),
        ],
      ),

      // STATS

      SliverToBoxAdapter(
        child: Padding(
          padding:
              const EdgeInsets
                  .all(20),

          child: Row(
            children: [

              _StatChip(
                label:
                    'Total',

                value:
                    '${category.taskCount}',

                color:
                    color,
              ),

              const SizedBox(
                width: 10,
              ),

              _StatChip(
                label:
                    'Done',

                value:
                    '${category.completedCount}',

                color:
                    AppColors.success,
              ),

              const SizedBox(
                width: 10,
              ),

              _StatChip(
                label:
                    'Progress',

                value:
                    '${(category.progress * 100).toInt()}%',

                color:
                    AppColors.info,
              ),
            ],
          ),
        ),
      ),

      // TASK HEADER

      SliverToBoxAdapter(
        child: Padding(
          padding:
              const EdgeInsets
                  .fromLTRB(
            20,
            0,
            20,
            12,
          ),

          child: SectionHeader(
            title:
                'Tasks',

            actionLabel:
                '+ Tambah',

            onAction: () {

              Get.toNamed(
                AppConstants
                    .createTaskRoute,
              );
            },
          ),
        ),
      ),

      // TASK LIST

      Obx(() {

        final tasks =
            ctrl.categoryTasks;

        if (tasks.isEmpty) {

          return SliverToBoxAdapter(
            child: EmptyState(
              title:
                  'Belum ada task',

              subtitle:
                  'Tambah task ke kategori ini',

              icon: Icons
                  .assignment_outlined,

              actionLabel:
                  '+ Buat Task',

              onAction: () {

                Get.toNamed(
                  AppConstants
                      .createTaskRoute,
                );
              },
            ),
          );
        }

        return SliverList(
          delegate:
              SliverChildBuilderDelegate(
            (context, index) {

              return Padding(
                padding:
                    const EdgeInsets
                        .symmetric(
                  horizontal: 20,
                ),

                child: _LocalTaskCard(
                  task:
                      tasks[index],

                  isDark:
                      isDark,

                  categoryColor:
                      color,
                ),
              );
            },

            childCount:
                tasks.length,
          ),
        );
      }),

      const SliverToBoxAdapter(
        child: SizedBox(
          height: 100,
        ),
      ),
    ],
  ),
);


}
}

// ─────────────────────────────────────
// STAT CHIP
// ─────────────────────────────────────

class _StatChip
extends StatelessWidget {

final String label;

final String value;

final Color color;

const _StatChip({
required this.label,
required this.value,
required this.color,
});

@override
Widget build(BuildContext context) {


return Expanded(
  child: Container(
    padding:
        const EdgeInsets.symmetric(
      vertical: 12,
    ),

    decoration:
        BoxDecoration(
      color:
          color.withOpacity(
        0.08,
      ),

      borderRadius:
          BorderRadius.circular(
        12,
      ),
    ),

    child: Column(
      children: [

        Text(
          value,

          style:
              GoogleFonts
                  .plusJakartaSans(
            fontSize: 18,

            fontWeight:
                FontWeight.w800,

            color: color,
          ),
        ),

        const SizedBox(
          height: 2,
        ),

        Text(
          label,

          style:
              GoogleFonts
                  .plusJakartaSans(
            fontSize: 10,

            color:
                color.withOpacity(
              0.8,
            ),
          ),
        ),
      ],
    ),
  ),
);


}
}
class _LocalTaskCard
extends StatelessWidget {

final LocalTaskModel task;

final bool isDark;

final Color categoryColor;

const _LocalTaskCard({
required this.task,
required this.isDark,
required this.categoryColor,
});

@override
Widget build(BuildContext context) {


return Container(
  margin:
      const EdgeInsets.only(
    bottom: 14,
  ),

  padding:
      const EdgeInsets.all(16),

  decoration: BoxDecoration(
    color:
        isDark
            ? AppColors.cardDark
            : Colors.white,

    borderRadius:
        BorderRadius.circular(
      18,
    ),

    boxShadow:
        AppColors.cardShadow,
  ),

  child: Column(
    crossAxisAlignment:
        CrossAxisAlignment.start,

    children: [

      // HEADER

      Row(
        children: [

          Expanded(
            child: Text(
              task.title,

              style:
                  GoogleFonts
                      .plusJakartaSans(
                fontSize: 16,

                fontWeight:
                    FontWeight.w700,

                color:
                    isDark
                        ? Colors.white
                        : AppColors
                            .textPrimary,
              ),
            ),
          ),

          Container(
            padding:
                const EdgeInsets
                    .symmetric(
              horizontal: 10,
              vertical: 5,
            ),

            decoration:
                BoxDecoration(
              color:
                  _priorityColor(
                task.priority,
              ).withOpacity(
                0.12,
              ),

              borderRadius:
                  BorderRadius
                      .circular(
                50,
              ),
            ),

            child: Text(
              task.priority
                  .toUpperCase(),

              style:
                  GoogleFonts
                      .plusJakartaSans(
                fontSize: 10,

                fontWeight:
                    FontWeight.w700,

                color:
                    _priorityColor(
                  task.priority,
                ),
              ),
            ),
          ),
        ],
      ),

      // DESCRIPTION

      if (task.description
          .isNotEmpty)

        Padding(
          padding:
              const EdgeInsets
                  .only(
            top: 8,
          ),

          child: Text(
            task.description,

            style:
                GoogleFonts
                    .plusJakartaSans(
              fontSize: 13,

              height: 1.5,

              color:
                  AppColors
                      .textSecondary,
            ),
          ),
        ),

      const SizedBox(
        height: 14,
      ),

      // PROGRESS

      if (task.subtasks
          .isNotEmpty)

        Column(
          children: [

            Row(
              children: [

                Text(
                  'Subtask',

                  style:
                      GoogleFonts
                          .plusJakartaSans(
                    fontSize: 12,

                    fontWeight:
                        FontWeight
                            .w600,
                  ),
                ),

                const Spacer(),

                Text(
                  '${task.subtaskDone}/${task.subtasks.length}',

                  style:
                      GoogleFonts
                          .plusJakartaSans(
                    fontSize: 12,

                    color:
                        AppColors
                            .textSecondary,
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 8,
            ),

            LinearProgressIndicator(
              value:
                  task.subtaskProgress,

              minHeight: 6,

              borderRadius:
                  BorderRadius
                      .circular(
                50,
              ),

              backgroundColor:
                  Colors.grey
                      .withOpacity(
                0.15,
              ),

              valueColor:
                  AlwaysStoppedAnimation(
                categoryColor,
              ),
            ),
          ],
        ),

      const SizedBox(
        height: 14,
      ),

      // FOOTER

      Row(
        children: [

          Icon(
            Icons.schedule,

            size: 16,

            color:
                AppColors
                    .textSecondary,
          ),

          const SizedBox(
            width: 6,
          ),

          Text(
            task.deadline != null
                ? '${task.deadline?.day ?? 0}/${task.deadline?.month ?? 0}/${task.deadline?.year ?? 0}'
                : 'No deadline',

            style:
                GoogleFonts
                    .plusJakartaSans(
              fontSize: 12,

              color:
                  AppColors
                      .textSecondary,
            ),
          ),

          const Spacer(),

          Container(
            padding:
                const EdgeInsets
                    .symmetric(
              horizontal: 10,
              vertical: 5,
            ),

            decoration:
                BoxDecoration(
              color:
                  task.isDone
                      ? AppColors
                          .success
                          .withOpacity(
                        0.12,
                      )
                      : task.isOverdue
                          ? AppColors
                              .error
                              .withOpacity(
                            0.12,
                          )
                          : AppColors
                              .info
                              .withOpacity(
                            0.12,
                          ),

              borderRadius:
                  BorderRadius
                      .circular(
                50,
              ),
            ),

            child: Text(
              task.isDone
                  ? 'DONE'
                  : task.isOverdue
                      ? 'OVERDUE'
                      : 'TODO',

              style:
                  GoogleFonts
                      .plusJakartaSans(
                fontSize: 10,

                fontWeight:
                    FontWeight.w700,

                color:
                    task.isDone
                        ? AppColors
                            .success
                        : task.isOverdue
                            ? AppColors
                                .error
                            : AppColors
                                .info,
              ),
            ),
          ),
        ],
      ),
    ],
  ),
);


}

Color _priorityColor(
String priority,
) {


switch (priority) {

  case 'high':
    return AppColors.error;

  case 'medium':
    return AppColors.warning;

  case 'low':
    return AppColors.success;

  default:
    return AppColors.primary;
}


}
}

