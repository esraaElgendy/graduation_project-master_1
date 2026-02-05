import 'package:equatable/equatable.dart';

class CourseModel extends Equatable {
  final int courseID;
  final String name;
  final int creditHours;

  const CourseModel({
    required this.courseID,
    required this.name,
    required this.creditHours,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      courseID: _toInt(json['courseID']),
      name: json['name']?.toString() ?? '',
      creditHours: _toInt(json['creditHours']),
    );
  }

  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  @override
  List<Object?> get props => [courseID, name, creditHours];
}

class SemesterModel extends Equatable {
  final int semester;
  final List<CourseModel> courses;

  const SemesterModel({
    required this.semester,
    required this.courses,
  });

  factory SemesterModel.fromJson(Map<String, dynamic> json) {
    return SemesterModel(
      semester: CourseModel._toInt(json['semester']),
      courses: (json['courses'] as List?)
              ?.map((c) => CourseModel.fromJson(c))
              .toList() ??
          [],
    );
  }

  @override
  List<Object?> get props => [semester, courses];
}

class LevelModel extends Equatable {
  final int level;
  final List<SemesterModel> semesters;

  const LevelModel({
    required this.level,
    required this.semesters,
  });

  factory LevelModel.fromJson(Map<String, dynamic> json) {
    return LevelModel(
      level: CourseModel._toInt(json['level']),
      semesters: (json['semesters'] as List?)
              ?.map((s) => SemesterModel.fromJson(s))
              .toList() ??
          [],
    );
  }

  @override
  List<Object?> get props => [level, semesters];
}
