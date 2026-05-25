import 'package:uuid/uuid.dart';

import '../models/category_model.dart';

import '../services/database_helper.dart';

class CategoryRepository {

  final DatabaseHelper _db =
      DatabaseHelper();

  final Uuid _uuid =
      const Uuid();

  // ─────────────────────────────────────
  // GET ALL CATEGORIES
  // ─────────────────────────────────────

  Future<List<CategoryModel>>
      getAll() async {

    final rows =
        await _db.getCategories();

    final taskRows =
        await _db.getTasks();

    final List<CategoryModel>
        categories = [];

    for (final row in rows) {

      final categoryTasks =
          taskRows.where(
        (task) {

          return task[
                  'category_id'] ==
              row['id'];
        },
      ).toList();

      final completedTasks =
          categoryTasks.where(
        (task) {

          return task[
                  'status'] ==
              'done';
        },
      ).toList();

      final int taskCount =
          categoryTasks.length;

      final int completedCount =
          completedTasks.length;

      categories.add(
        CategoryModel.fromMap(
          {
            ...row,

            'task_count':
                taskCount,

            'completed_count':
                completedCount,
          },
        ),
      );
    }

    return categories;
  }

  // ─────────────────────────────────────
  // GET CATEGORY BY ID
  // ─────────────────────────────────────

  Future<CategoryModel?>
      getById(
    String id,
  ) async {

    final categories =
        await getAll();

    try {

      return categories.firstWhere(
        (category) =>
            category.id == id,
      );

    } catch (_) {

      return null;
    }
  }

  // ─────────────────────────────────────
  // CREATE CATEGORY
  // ─────────────────────────────────────

  Future<CategoryModel>
      create({

    required String name,

    String description = '',

    String color =
        '#2563EB',

  }) async {

    final categories =
        await _db.getCategories();

    final category =
        CategoryModel(
      id: _uuid.v4(),

      name: name,

      description:
          description,

      color: color,

      createdAt:
          DateTime.now(),
    );

    categories.add(
      category.toMap(),
    );

    await _db.saveCategories(
      categories,
    );

    return category;
  }

  // ─────────────────────────────────────
  // UPDATE CATEGORY
  // ─────────────────────────────────────

  Future<void> update(
    CategoryModel category,
  ) async {

    final categories =
        await _db.getCategories();

    final updated =
        categories.map(
      (item) {

        if (item['id'] ==
            category.id) {

          return category.toMap();
        }

        return item;
      },
    ).toList();

    await _db.saveCategories(
      updated,
    );
  }

  // ─────────────────────────────────────
  // DELETE CATEGORY
  // ─────────────────────────────────────

  Future<void> delete(
    String id,
  ) async {

    final categories =
        await _db.getCategories();

    categories.removeWhere(
      (category) {

        return category['id'] ==
            id;
      },
    );

    await _db.saveCategories(
      categories,
    );
  }
}