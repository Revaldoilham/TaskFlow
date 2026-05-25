import 'package:uuid/uuid.dart';

import '../models/local_task_model.dart';
import '../models/subtask_model.dart';

import '../services/database_helper.dart';

class LocalTaskRepository {

  final DatabaseHelper _db =
      DatabaseHelper();

  final Uuid _uuid =
      const Uuid();

  // ─────────────────────────────────────
  // GET ALL TASKS
  // ─────────────────────────────────────

  Future<List<LocalTaskModel>>
      getAll() async {

    final rows =
        await _db.getTasks();

    return rows.map(
      (row) {

        final subtasksData =
            row['subtasks'] ?? [];

        final subtasks =
            List<Map<String, dynamic>>
                .from(
          subtasksData,
        ).map(
          (subtask) {

            return SubtaskModel
                .fromMap(
              subtask,
            );
          },
        ).toList();

        return LocalTaskModel
            .fromMap(
          row,
          subtasks: subtasks,
        );
      },
    ).toList();
  }

  // ─────────────────────────────────────
  // GET TODAY TASKS
  // ─────────────────────────────────────

  Future<List<LocalTaskModel>>
      getToday() async {

    final tasks =
        await getAll();

    final now =
        DateTime.now();

    return tasks.where(
      (task) {

        if (task.startDate ==
            null) {

          return false;
        }

        return task.startDate!
                .year ==
            now.year &&
            task.startDate!
                    .month ==
                now.month &&
            task.startDate!
                    .day ==
                now.day;
      },
    ).toList();
  }

  // ─────────────────────────────────────
  // GET BY CATEGORY
  // ─────────────────────────────────────

  Future<List<LocalTaskModel>>
      getByCategory(
    String categoryId,
  ) async {

    final tasks =
        await getAll();

    return tasks.where(
      (task) {

        return task
                .categoryId ==
            categoryId;
      },
    ).toList();
  }

  // ─────────────────────────────────────
  // GET BY ID
  // ─────────────────────────────────────

  Future<LocalTaskModel?>
      getById(
    String id,
  ) async {

    final tasks =
        await getAll();

    try {

      return tasks.firstWhere(
        (task) =>
            task.id == id,
      );

    } catch (_) {

      return null;
    }
  }

  // ─────────────────────────────────────
  // CREATE TASK
  // ─────────────────────────────────────

  Future<LocalTaskModel>
      create(
    LocalTaskModel task,
  ) async {

    final tasks =
        await _db.getTasks();

    final newTask =
        task.copyWith();

    tasks.add({
      ...newTask.toMap(),

      'subtasks':
          newTask.subtasks
              .map(
        (subtask) {

          return subtask
              .toMap();
        },
      ).toList(),
    });

    await _db.saveTasks(
      tasks,
    );

    return newTask;
  }

  // ─────────────────────────────────────
  // UPDATE TASK
  // ─────────────────────────────────────

  Future<void> update(
    LocalTaskModel task,
  ) async {

    final tasks =
        await _db.getTasks();

    final updated =
        tasks.map(
      (item) {

        if (item['id'] ==
            task.id) {

          return {
            ...task.toMap(),

            'subtasks':
                task.subtasks
                    .map(
              (subtask) {

                return subtask
                    .toMap();
              },
            ).toList(),
          };
        }

        return item;
      },
    ).toList();

    await _db.saveTasks(
      updated,
    );
  }

  // ─────────────────────────────────────
  // UPDATE STATUS
  // ─────────────────────────────────────

  Future<void>
      updateStatus(
    String id,
    String status,
  ) async {

    final tasks =
        await getAll();

    final updated =
        tasks.map(
      (task) {

        if (task.id == id) {

          return task
              .copyWith(
            status: status,
          );
        }

        return task;
      },
    ).toList();

    await _db.saveTasks(
      updated.map(
        (task) {

          return {
            ...task.toMap(),

            'subtasks':
                task.subtasks
                    .map(
              (subtask) {

                return subtask
                    .toMap();
              },
            ).toList(),
          };
        },
      ).toList(),
    );
  }

  // ─────────────────────────────────────
  // DELETE TASK
  // ─────────────────────────────────────

  Future<void> delete(
    String id,
  ) async {

    final tasks =
        await _db.getTasks();

    tasks.removeWhere(
      (task) {

        return task['id'] ==
            id;
      },
    );

    await _db.saveTasks(
      tasks,
    );
  }

  // ─────────────────────────────────────
  // TODAY STATS
  // ─────────────────────────────────────

  Future<Map<String, int>>
      getTodayStats() async {

    final tasks =
        await getToday();

    final total =
        tasks.length;

    final done =
        tasks.where(
      (task) {

        return task.isDone;
      },
    ).length;

    final pending =
        total - done;

    return {
      'total': total,
      'done': done,
      'pending': pending,
    };
  }
}