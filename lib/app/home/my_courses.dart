import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onco/api/firestore_api.dart';
import 'package:onco/app/home/home_page.dart';
import 'package:onco/app/home/learn_course_page.dart';
import 'package:onco/main.dart';
import 'package:onco/models/course.dart';
import 'package:onco/style.dart';
import '../../api/auth_api.dart';

class MyCourses extends ConsumerWidget {
  @override
  Widget build(BuildContext context, watch) {
    final coursesProvider = watch(courseApi);
    return context.read(firebaseInstanceProvider).currentUser == null
        ? Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Sign In",
                      style: headingStyle,
                    ),
                    SizedBox(
                      height: 16.h,
                    ),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(4)),
                      child: TextButton(
                        onPressed: () async {
                          try {
                            await context
                                .read(firebaseApiProvider)
                                .googleSignIn();
                            if (context
                                    .read(firebaseInstanceProvider)
                                    .currentUser !=
                                null) {
                              watch(sharedPreferenceProvider)
                                  ?.setBool("isSkipped", false);
                              watch(isSkippedProvider).state = false;
                            }
                          } catch (e) {}
                        },
                        child: Text(
                          "Sign in to view courses",
                          style: bodyStyle.copyWith(
                              color: Colors.white,
                              fontFamily: gilroy,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        : Scaffold(
            body: RefreshIndicator(
              onRefresh: () async =>
                  await context.read(courseApi.notifier).getAllCourses(),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 56.sp,
                      ),
                      Text(
                        "My Courses",
                        style: headingStyle.copyWith(color: secondaryColor),
                      ),
                      SizedBox(
                        height: 24.h,
                      ),
                      coursesProvider.when(
                          data: (courses) => MyCoursesList(
                              courses: courses
                                  .where((element) => element.student.contains(
                                      context
                                              .read(firebaseInstanceProvider)
                                              .currentUser
                                              ?.uid ??
                                          ""))
                                  .toList()),
                          loading: () => Center(
                                child: CircularProgressIndicator(),
                              ),
                          error: (_, __) => Container())
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}

class MyCoursesList extends StatelessWidget {
  final List<Course> courses;

  const MyCoursesList({Key? key, required this.courses}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: courses.length,
      itemBuilder: (_, index) {
        return MyCourseCard(course: courses[index]);
      },
    );
  }
}

class MyCourseCard extends ConsumerWidget {
  final Course course;

  const MyCourseCard({Key? key, required this.course}) : super(key: key);
  @override
  Widget build(BuildContext context, watch) {
    return InkWell(
      onTap: () async {
        watch(hideNavbarProvider).state = true;
        await Navigator.of(context).push(MaterialPageRoute(builder: (_) {
          return LearnCoursePage(
            course: course,
          );
        }));
        watch(hideNavbarProvider).state = false;
      },
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(8)),
        margin: EdgeInsets.only(bottom: 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 64.h,
                  width: 64.h,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(32.h),
                    child: CachedNetworkImage(
                      imageUrl: course.banner,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(
                  width: 16.h,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        course.instructor,
                        style: bodyStyle.copyWith(fontSize: subBodyFontSize),
                      ),
                      Text(
                        course.name,
                        style: headingStyle.copyWith(fontSize: 20.sp),
                      )
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 16.h,
            ),
            Stack(
              children: [
                Container(
                  height: 4.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: secondaryColor.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(4)),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(4)),
                  height: 4,
                  width: ScreenUtil.defaultSize.width / Random().nextInt(10),
                ),
              ],
            ),
            SizedBox(
              height: 16.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  course.duration + " weeks",
                  style: bodyStyle,
                ),
                CircleAvatar(
                  backgroundColor: primaryColor,
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 20.w,
                    color: Colors.white,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
