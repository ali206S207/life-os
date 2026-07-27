import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/projects_repository.dart';
import '../../domain/project.dart';

final projectsRepositoryProvider = Provider<ProjectsRepository>((ref) {
  return LocalProjectsRepository();
});

class ProjectsNotifier extends AsyncNotifier<List<Project>> {
  @override
  Future<List<Project>> build() {
    return ref.read(projectsRepositoryProvider).fetchProjects();
  }

  void toggleTask(String projectId, String taskId) {
    state.whenData((projects) {
      state = AsyncValue.data([
        for (final project in projects)
          if (project.id == projectId)
            project.copyWithTask(
              project.tasks
                  .firstWhere((t) => t.id == taskId)
                  .copyWith(isDone: !project.tasks.firstWhere((t) => t.id == taskId).isDone),
            )
          else
            project,
      ]);
    });
  }
}

final projectsProvider = AsyncNotifierProvider<ProjectsNotifier, List<Project>>(
  ProjectsNotifier.new,
);
