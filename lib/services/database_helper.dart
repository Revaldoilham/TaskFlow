import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class DatabaseHelper {

  static const String
      tasksKey =
      'local_tasks';

  static const String
      categoriesKey =
      'categories';

  // ─────────────────────────────────────
  // GET TASKS
  // ─────────────────────────────────────

  Future<List<Map<String, dynamic>>>
      getTasks() async {

    final prefs =
        await SharedPreferences
            .getInstance();

    final data =
        prefs.getString(
      tasksKey,
    );

    if (data == null) {

      return [
        {
          'id': 'task_1',

          'title':
              'Mengerjakan UI TaskFlow',

          'description':
              'Membuat dashboard modern',

          'priority': 'high',

          'status': 'todo',

          'category_id':
              'cat_work',

          'category_name':
              'Work',

          'start_date':
              DateTime.now()
                  .toIso8601String(),

          'deadline':
              DateTime.now()
                  .add(
                    const Duration(
                      hours: 12,
                    ),
                  )
                  .toIso8601String(),

          'start_time':
              '09:00',

          'end_time':
              '11:00',

          'reminder_enabled': 1,

          'repeat': 'none',

          'created_at':
              DateTime.now()
                  .toIso8601String(),
        },
      ];
    }

    return List<Map<String, dynamic>>
        .from(
      jsonDecode(data),
    );
  }

  // ─────────────────────────────────────
  // SAVE TASKS
  // ─────────────────────────────────────

  Future<void> saveTasks(
    List<Map<String, dynamic>>
        tasks,
  ) async {

    final prefs =
        await SharedPreferences
            .getInstance();

    await prefs.setString(
      tasksKey,

      jsonEncode(tasks),
    );
  }

  // ─────────────────────────────────────
  // GET CATEGORIES
  // ─────────────────────────────────────

  Future<List<Map<String, dynamic>>>
      getCategories() async {

    final prefs =
        await SharedPreferences
            .getInstance();

    final data =
        prefs.getString(
      categoriesKey,
    );

    if (data == null) {

      return [
        {
          'id': 'cat_work',

          'name': 'Work',

          'description':
              'Pekerjaan',

          'color': '#2563EB',

          'created_at':
              DateTime.now()
                  .toIso8601String(),
        },

        {
          'id': 'cat_study',

          'name': 'Study',

          'description':
              'Belajar',

          'color': '#059669',

          'created_at':
              DateTime.now()
                  .toIso8601String(),
        },
      ];
    }

    return List<Map<String, dynamic>>
        .from(
      jsonDecode(data),
    );
  }

  // ─────────────────────────────────────
  // SAVE CATEGORIES
  // ─────────────────────────────────────

  Future<void>
      saveCategories(
    List<Map<String, dynamic>>
        categories,
  ) async {

    final prefs =
        await SharedPreferences
            .getInstance();

    await prefs.setString(
      categoriesKey,

      jsonEncode(categories),
    );
  }
}