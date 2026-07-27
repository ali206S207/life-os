import '../domain/course.dart';

abstract class LearningRepository {
  Future<List<Course>> fetchCourses();
}

class LocalLearningRepository implements LearningRepository {
  @override
  Future<List<Course>> fetchCourses() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return const [
      Course(
        id: 'c1',
        title: 'Flutter & Dart Complete Guide',
        subject: 'Mobile Development',
        hoursCompleted: 18,
        totalHours: 40,
        hasCertificate: false,
      ),
      Course(
        id: 'c2',
        title: 'English Business Communication',
        subject: 'Language',
        hoursCompleted: 12,
        totalHours: 12,
        hasCertificate: true,
      ),
      Course(
        id: 'c3',
        title: 'Intro to UI/UX Design',
        subject: 'Design',
        hoursCompleted: 4,
        totalHours: 20,
        hasCertificate: false,
      ),
    ];
  }
}
