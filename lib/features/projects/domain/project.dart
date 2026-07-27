import 'package:equatable/equatable.dart';

class ProjectTask extends Equatable {
  const ProjectTask({required this.id, required this.title, required this.isDone});

  final String id;
  final String title;
  final bool isDone;

  ProjectTask copyWith({bool? isDone}) {
    return ProjectTask(id: id, title: title, isDone: isDone ?? this.isDone);
  }

  @override
  List<Object?> get props => [id, title, isDone];
}

class Project extends Equatable {
  const Project({
    required this.id,
    required this.title,
    required this.emoji,
    required this.deadline,
    required this.tasks,
  });

  final String id;
  final String title;
  final String emoji;
  final DateTime deadline;
  final List<ProjectTask> tasks;

  double get progress {
    if (tasks.isEmpty) return 0;
    return tasks.where((t) => t.isDone).length / tasks.length;
  }

  int get daysRemaining => deadline.difference(DateTime.now()).inDays;

  Project copyWithTask(ProjectTask updated) {
    return Project(
      id: id,
      title: title,
      emoji: emoji,
      deadline: deadline,
      tasks: [
        for (final t in tasks)
          if (t.id == updated.id) updated else t,
      ],
    );
  }

  @override
  List<Object?> get props => [id, title, emoji, deadline, tasks];
}
