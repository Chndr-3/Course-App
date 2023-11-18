import 'curriculum_item.dart';

class Course {
  String courseName;
  String progress;
  List<CurriculumItem> curriculum;

  Course({
    required this.courseName,
    required this.progress,
    required this.curriculum,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      courseName: json['course_name'],
      progress: json['progress'],
      curriculum: (json['curriculum'] as List)
          .map((item) => CurriculumItem.fromJson(item))
          .toList(),
    );
  }
}
