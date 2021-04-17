// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Course _$_$_CourseFromJson(Map<String, dynamic> json) {
  return _$_Course(
    name: json['name'] as String,
    offeredBy: json['offeredBy'] as String,
    rating: (json['rating'] as num).toDouble(),
    reviews: json['reviews'] as int,
    domain: json['domain'] as String,
    type: json['type'] as String,
    about: json['about'] as String,
    level: json['level'] as String,
    mode: json['mode'] as String,
    language: json['language'] as String,
    instructor: json['instructor'] as String,
    startingDate: (json['startingDate'] as num).toDouble(),
    price: json['price'] as int,
    banner: json['banner'] as String,
    id: json['id'] as String,
    syllabus: (json['syllabus'] as List<dynamic>)
        .map((e) => Syllabus.fromJson(e as Map<String, dynamic>))
        .toList(),
    duration: json['duration'] as String,
    totalVideos: json['totalVideos'] as String,
    student:
        (json['student'] as List<dynamic>).map((e) => e as String).toList(),
  );
}

Map<String, dynamic> _$_$_CourseToJson(_$_Course instance) => <String, dynamic>{
      'name': instance.name,
      'offeredBy': instance.offeredBy,
      'rating': instance.rating,
      'reviews': instance.reviews,
      'domain': instance.domain,
      'type': instance.type,
      'about': instance.about,
      'level': instance.level,
      'mode': instance.mode,
      'language': instance.language,
      'instructor': instance.instructor,
      'startingDate': instance.startingDate,
      'price': instance.price,
      'banner': instance.banner,
      'id': instance.id,
      'syllabus': instance.syllabus,
      'duration': instance.duration,
      'totalVideos': instance.totalVideos,
      'student': instance.student,
    };

_$_Syllabus _$_$_SyllabusFromJson(Map<String, dynamic> json) {
  return _$_Syllabus(
    week: json['week'] as int,
    module: json['module'] as String,
    about: json['about'] as String,
    chapters: (json['chapters'] as List<dynamic>)
        .map((e) => Chapter.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$_$_SyllabusToJson(_$_Syllabus instance) =>
    <String, dynamic>{
      'week': instance.week,
      'module': instance.module,
      'about': instance.about,
      'chapters': instance.chapters,
    };

_$_Chapter _$_$_ChapterFromJson(Map<String, dynamic> json) {
  return _$_Chapter(
    title: json['title'] as String,
  );
}

Map<String, dynamic> _$_$_ChapterToJson(_$_Chapter instance) =>
    <String, dynamic>{
      'title': instance.title,
    };
