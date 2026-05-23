// lib/data/repositories/project_repository.dart
import '../models/project_model.dart';
import '../providers/mock_data_provider.dart';

class ProjectRepository {
  static final List<ProjectModel> _projects = List.from(MockDataProvider.projects);

  Future<List<ProjectModel>> getProjects() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return List.from(_projects);
  }

  Future<ProjectModel?> getProjectById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _projects.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<List<ProjectModel>> getActiveProjects() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _projects.where((p) => p.status == 'Active').toList();
  }
}