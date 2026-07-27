import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/learning_repository.dart';
import '../../domain/course.dart';

final learningRepositoryProvider = Provider<LearningRepository>((ref) {
  return LocalLearningRepository();
});

final coursesProvider = FutureProvider<List<Course>>((ref) {
  return ref.read(learningRepositoryProvider).fetchCourses();
});

final totalLearningHoursProvider = Provider<double>((ref) {
  final courses = ref.watch(coursesProvider).value ?? [];
  return courses.fold<double>(0, (sum, c) => sum + c.hoursCompleted);
});

final certificatesEarnedProvider = Provider<int>((ref) {
  final courses = ref.watch(coursesProvider).value ?? [];
  return courses.where((c) => c.hasCertificate).length;
});
