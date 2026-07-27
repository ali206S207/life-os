import 'package:equatable/equatable.dart';

class Course extends Equatable {
  const Course({
    required this.id,
    required this.title,
    required this.subject,
    required this.hoursCompleted,
    required this.totalHours,
    required this.hasCertificate,
  });

  final String id;
  final String title;
  final String subject;
  final double hoursCompleted;
  final double totalHours;
  final bool hasCertificate;

  double get progress => totalHours == 0 ? 0 : (hoursCompleted / totalHours).clamp(0.0, 1.0);
  bool get isComplete => progress >= 1.0;

  @override
  List<Object?> get props => [id, title, subject, hoursCompleted, totalHours, hasCertificate];
}
