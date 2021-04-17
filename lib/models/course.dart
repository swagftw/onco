import 'package:freezed_annotation/freezed_annotation.dart';

part 'course.freezed.dart';
part 'course.g.dart';

@freezed
class Course with _$Course {
  factory Course({
    required String name,
    required String offeredBy,
    required double rating,
    required int reviews,
    required String domain,
    required String type,
    required String about,
    required String level,
    required String mode,
    required String language,
    required String instructor,
    required double startingDate,
    required int price,
    required String banner,
    required String id,
    required List<Syllabus> syllabus,
    required String duration,
    required String totalVideos,
    required List<String> student
  }) = _Course;

  factory Course.fromJson(Map<String, dynamic> json) => _$CourseFromJson(json);
}

@freezed
class Syllabus with _$Syllabus {
  factory Syllabus({
    required int week,
    required String module,
    required String about,
    required List<Chapter> chapters,
  }) = _Syllabus;

  factory Syllabus.fromJson(Map<String, dynamic> json) =>
      _$SyllabusFromJson(json);
}

@freezed
class Chapter with _$Chapter {
  factory Chapter({
    required String title,
  }) = _Chapter;
  factory Chapter.fromJson(Map<String, dynamic> json) =>
      _$ChapterFromJson(json);
}
