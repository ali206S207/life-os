import '../domain/project.dart';

abstract class ProjectsRepository {
  Future<List<Project>> fetchProjects();
}

class LocalProjectsRepository implements ProjectsRepository {
  @override
  Future<List<Project>> fetchProjects() async {
    await Future.delayed(const Duration(milliseconds: 200));
    final now = DateTime.now();

    return [
      Project(
        id: 'p1',
        title: 'Life OS App',
        emoji: '🧭',
        deadline: now.add(const Duration(days: 45)),
        tasks: const [
          ProjectTask(id: 't1', title: 'Design system', isDone: true),
          ProjectTask(id: 't2', title: 'Dashboard', isDone: true),
          ProjectTask(id: 't3', title: 'Goals module', isDone: true),
          ProjectTask(id: 't4', title: 'Supabase sync', isDone: false),
          ProjectTask(id: 't5', title: 'App store release', isDone: false),
        ],
      ),
      Project(
        id: 'p2',
        title: 'TEFA Supplements Storefront',
        emoji: '💊',
        deadline: now.add(const Duration(days: 10)),
        tasks: const [
          ProjectTask(id: 't6', title: 'Product catalog', isDone: true),
          ProjectTask(id: 't7', title: 'Checkout flow', isDone: false),
          ProjectTask(id: 't8', title: 'Payment integration', isDone: false),
        ],
      ),
    ];
  }
}
