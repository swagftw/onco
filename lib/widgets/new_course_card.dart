import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onco/app/home/course_details.dart';
import 'package:onco/models/course.dart';
import 'package:onco/style.dart';

class NewCourseCard extends StatelessWidget {
  final Course course;

  const NewCourseCard({
    Key? key,
    required this.course,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InkWell(
          onTap: () async {
            await Navigator.of(context).push(MaterialPageRoute(builder: (_) {
              return CourseDetails(course: course);
            }));
          },
          child: Container(
            width: ScreenUtil.defaultSize.width,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                "assets/images/bg${Random().nextInt(3)}.jpg",
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
        ),
        Positioned(
          top: 16.h,
          left: 16.w,
          child: Text(
            "All New",
            style: headingStyle.copyWith(fontSize: 18.sp, color: Colors.white),
          ),
        ),
        Positioned(
          bottom: 16.h,
          left: 16.w,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: ScreenUtil.defaultSize.width / 1.5,
                    child: Text(
                      course.name,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 22.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontFamily: gilroy),
                    ),
                  ),
                  SizedBox(
                    width: 16.w,
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 20,
                  ),
                ],
              ),
              Container(
                width: ScreenUtil.defaultSize.width / 1.5,
                child: Text(
                  "by, " + course.instructor,
                  overflow: TextOverflow.ellipsis,
                  style: bodyStyle.copyWith(color: Colors.white),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
