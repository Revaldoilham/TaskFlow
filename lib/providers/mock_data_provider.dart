import '../models/user_model.dart';
import '../models/task_model.dart';
import '../models/project_model.dart';

class MockDataProvider {

  // =========================
  // USER
  // =========================

  static UserModel get currentUser => UserModel(
        id: '1',
        name: 'Revaldo',
        email: 'revaldo@gmail.com',
        role: 'Mahasiswa',
        phone: '081234567890',
        avatar: null,
      );

  // =========================
  // PROJECTS
  // =========================

  static List<ProjectModel> get projects => [

        ProjectModel(
          id: 'p1',
          name: 'Aplikasi Task Manager Flutter',
          description:
              'Membuat aplikasi task manager menggunakan Flutter dan Express JS.',
          color: '#2563EB',
          totalTasks: 10,
          completedTasks: 6,
          progress: 0.6,
          memberNames: [
            'Revaldo',
            'Andi',
            'Rizky',
          ],
          deadline: DateTime.now().add(
            const Duration(days: 14),
          ),
          createdAt: DateTime.now().subtract(
            const Duration(days: 20),
          ),
          status: 'Active',
        ),

        ProjectModel(
          id: 'p2',
          name: 'Desain UI Aplikasi',
          description:
              'Mendesain tampilan aplikasi mobile yang modern dan responsif.',
          color: '#7C3AED',
          totalTasks: 8,
          completedTasks: 4,
          progress: 0.5,
          memberNames: [
            'Revaldo',
            'Aulia',
          ],
          deadline: DateTime.now().add(
            const Duration(days: 10),
          ),
          createdAt: DateTime.now().subtract(
            const Duration(days: 15),
          ),
          status: 'Active',
        ),

        ProjectModel(
          id: 'p3',
          name: 'Persiapan Seminar Proposal',
          description:
              'Menyiapkan laporan dan presentasi seminar proposal.',
          color: '#059669',
          totalTasks: 6,
          completedTasks: 6,
          progress: 1.0,
          memberNames: [
            'Revaldo',
          ],
          deadline: DateTime.now().subtract(
            const Duration(days: 3),
          ),
          createdAt: DateTime.now().subtract(
            const Duration(days: 30),
          ),
          status: 'Completed',
        ),

        ProjectModel(
          id: 'p4',
          name: 'Konten Media Sosial',
          description:
              'Membuat desain postingan dan jadwal upload Instagram.',
          color: '#DC2626',
          totalTasks: 5,
          completedTasks: 2,
          progress: 0.4,
          memberNames: [
            'Nanda',
            'Revaldo',
          ],
          deadline: DateTime.now().add(
            const Duration(days: 20),
          ),
          createdAt: DateTime.now().subtract(
            const Duration(days: 7),
          ),
          status: 'Active',
        ),
      ];

  // =========================
  // TASKS
  // =========================

  static List<TaskModel> get tasks => [

        TaskModel(
          id: 't1',
          title: 'Membuat halaman login Flutter',
          description:
              'Menyelesaikan tampilan login dan validasi form menggunakan GetX.',
          priority: 'High',
          status: 'In Progress',
          deadline: DateTime.now().add(
            const Duration(days: 2),
          ),
          assignedName: 'Revaldo',
          projectId: 'p1',
          projectName: 'Aplikasi Task Manager Flutter',
          createdAt: DateTime.now().subtract(
            const Duration(days: 3),
          ),
          tags: [
            'Flutter',
            'Frontend',
          ],
        ),

        TaskModel(
          id: 't2',
          title: 'Memperbaiki error GetX',
          description:
              'Memperbaiki error route dan controller pada aplikasi Flutter.',
          priority: 'Urgent',
          status: 'Todo',
          deadline: DateTime.now().add(
            const Duration(days: 1),
          ),
          assignedName: 'Andi',
          projectId: 'p1',
          projectName: 'Aplikasi Task Manager Flutter',
          createdAt: DateTime.now().subtract(
            const Duration(days: 1),
          ),
          tags: [
            'Flutter',
            'Bug Fix',
          ],
        ),

        TaskModel(
          id: 't3',
          title: 'Mengerjakan laporan BAB 3',
          description:
              'Menulis metodologi penelitian dan flowchart sistem.',
          priority: 'Medium',
          status: 'Review',
          deadline: DateTime.now().add(
            const Duration(days: 5),
          ),
          assignedName: 'Revaldo',
          projectId: 'p3',
          projectName: 'Persiapan Seminar Proposal',
          createdAt: DateTime.now().subtract(
            const Duration(days: 4),
          ),
          tags: [
            'Skripsi',
            'Laporan',
          ],
        ),

        TaskModel(
          id: 't4',
          title: 'Desain dashboard aplikasi',
          description:
              'Membuat tampilan dashboard modern dengan tema biru.',
          priority: 'High',
          status: 'Done',
          deadline: DateTime.now().subtract(
            const Duration(days: 2),
          ),
          assignedName: 'Aulia',
          projectId: 'p2',
          projectName: 'Desain UI Aplikasi',
          createdAt: DateTime.now().subtract(
            const Duration(days: 8),
          ),
          tags: [
            'UI Design',
            'Mobile',
          ],
        ),

        TaskModel(
          id: 't5',
          title: 'Revisi proposal dosen pembimbing',
          description:
              'Memperbaiki bagian latar belakang dan tujuan penelitian.',
          priority: 'Medium',
          status: 'Done',
          deadline: DateTime.now().subtract(
            const Duration(days: 6),
          ),
          assignedName: 'Revaldo',
          projectId: 'p3',
          projectName: 'Persiapan Seminar Proposal',
          createdAt: DateTime.now().subtract(
            const Duration(days: 10),
          ),
          tags: [
            'Kuliah',
            'Proposal',
          ],
        ),

        TaskModel(
          id: 't6',
          title: 'Menambahkan fitur task',
          description:
              'Membuat fitur tambah dan detail tugas pada aplikasi.',
          priority: 'High',
          status: 'In Progress',
          deadline: DateTime.now().add(
            const Duration(days: 4),
          ),
          assignedName: 'Rizky',
          projectId: 'p1',
          projectName: 'Aplikasi Task Manager Flutter',
          createdAt: DateTime.now().subtract(
            const Duration(days: 2),
          ),
          tags: [
            'Flutter',
            'Task',
          ],
        ),

        TaskModel(
          id: 't7',
          title: 'Membuat presentasi sidang',
          description:
              'Menyiapkan slide presentasi seminar proposal.',
          priority: 'Medium',
          status: 'Todo',
          deadline: DateTime.now().add(
            const Duration(days: 7),
          ),
          assignedName: 'Revaldo',
          projectId: 'p3',
          projectName: 'Persiapan Seminar Proposal',
          createdAt: DateTime.now(),
          tags: [
            'Presentasi',
            'Seminar',
          ],
        ),

        TaskModel(
          id: 't8',
          title: 'Belajar Express JS',
          description:
              'Mempelajari REST API untuk backend aplikasi task manager.',
          priority: 'Low',
          status: 'Todo',
          deadline: DateTime.now().add(
            const Duration(days: 10),
          ),
          assignedName: 'Andi',
          projectId: 'p1',
          projectName: 'Aplikasi Task Manager Flutter',
          createdAt: DateTime.now(),
          tags: [
            'Backend',
            'ExpressJS',
          ],
        ),

        TaskModel(
          id: 't9',
          title: 'Testing aplikasi Flutter',
          description:
              'Mengecek bug dan memastikan aplikasi berjalan normal.',
          priority: 'Urgent',
          status: 'Todo',
          deadline: DateTime.now().add(
            const Duration(days: 2),
          ),
          assignedName: 'Revaldo',
          projectId: 'p1',
          projectName: 'Aplikasi Task Manager Flutter',
          createdAt: DateTime.now().subtract(
            const Duration(days: 1),
          ),
          tags: [
            'Testing',
            'Flutter',
          ],
        ),

        TaskModel(
          id: 't10',
          title: 'Upload project ke GitHub',
          description:
              'Menyimpan source code project Flutter ke repository GitHub.',
          priority: 'Low',
          status: 'Done',
          deadline: DateTime.now().subtract(
            const Duration(days: 5),
          ),
          assignedName: 'Revaldo',
          projectId: 'p1',
          projectName: 'Aplikasi Task Manager Flutter',
          createdAt: DateTime.now().subtract(
            const Duration(days: 12),
          ),
          tags: [
            'GitHub',
            'Project',
          ],
        ),
      ];

  // =========================
  // TASK STATS
  // =========================

  static Map<String, int> get taskStats {
    final allTasks = tasks;

    return {
      'total': allTasks.length,
      'todo': allTasks
          .where((t) => t.status == 'Todo')
          .length,
      'inProgress': allTasks
          .where((t) => t.status == 'In Progress')
          .length,
      'review': allTasks
          .where((t) => t.status == 'Review')
          .length,
      'done': allTasks
          .where((t) => t.status == 'Done')
          .length,
      'overdue': allTasks
          .where((t) => t.isOverdue)
          .length,
    };
  }
}