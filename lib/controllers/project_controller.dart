// lib/modules/projects/project_controller.dart
import 'package:get/get.dart';
import '/models/project_model.dart';
import '/repositories/project_repository.dart';

class ProjectController extends GetxController {
  final ProjectRepository _repo = ProjectRepository();

  final RxList<ProjectModel> projects = <ProjectModel>[].obs;
  final RxList<ProjectModel> activeProjects = <ProjectModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final Rx<ProjectModel?> selectedProject = Rx<ProjectModel?>(null);

  @override
  void onInit() {
    super.onInit();
    loadProjects();
  }

  Future<void> loadProjects() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final result = await _repo.getProjects();
      projects.assignAll(result);
      activeProjects.assignAll(result.where((p) => p.status == 'Active').toList());
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> selectProject(String id) async {
    selectedProject.value = await _repo.getProjectById(id);
  }

  int get totalProjects => projects.length;
  int get activeCount => activeProjects.length;
  int get completedCount => projects.where((p) => p.status == 'Completed').length;
}