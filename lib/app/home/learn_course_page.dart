import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:onco/app/home/home_page.dart';
import 'package:onco/models/course.dart';
import 'package:onco/style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:random_string/random_string.dart';

class LearnCoursePage extends StatefulWidget {
  final Course course;

  const LearnCoursePage({Key? key, required this.course}) : super(key: key);

  @override
  _LearnCoursePageState createState() => _LearnCoursePageState();
}

class _LearnCoursePageState extends State<LearnCoursePage>
    with SingleTickerProviderStateMixin {
  TabController? _controller;
  @override
  void initState() {
    _controller =
        TabController(length: widget.course.syllabus.length, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        iconTheme: IconThemeData(color: primaryColor),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            color: primaryColor,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 24.h,
                  ),
                  Text(
                    widget.course.instructor,
                    style: bodyStyle.copyWith(
                        fontSize: subBodyFontSize, color: Colors.white),
                  ),
                  Text(
                    widget.course.name,
                    style: headingStyle.copyWith(
                        fontSize: subHeadingFontSize, color: Colors.white),
                  ),
                  SizedBox(
                    height: 24.h,
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: kToolbarHeight,
            child: TabBar(
              controller: _controller,
              isScrollable: true,
              tabs: [
                Tab(
                  icon: Text(
                    "Week " + widget.course.syllabus[0].week.toString(),
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                Tab(
                  icon: Text(
                    "Week " + widget.course.syllabus[1].week.toString(),
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                Tab(
                  icon: Text(
                    "Week " + widget.course.syllabus[2].week.toString(),
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                Tab(
                  icon: Text(
                    "Week " + widget.course.syllabus[3].week.toString(),
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                Tab(
                  icon: Text(
                    "Week " + widget.course.syllabus[4].week.toString(),
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                Tab(
                  icon: Text(
                    "Week " + widget.course.syllabus[5].week.toString(),
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                Tab(
                  icon: Text(
                    "Week " + widget.course.syllabus[6].week.toString(),
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
                controller: _controller,
                children: widget.course.syllabus
                    .map((e) => ChapterView(syllabus: e))
                    .toList()),
          )
        ],
      ),
    );
  }
}

class ChapterView extends StatelessWidget {
  final Syllabus syllabus;

  const ChapterView({Key? key, required this.syllabus}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          children: [
            SizedBox(
              height: 24.h,
            ),
            Text(
              "Module : " + syllabus.module,
              style: headingStyle.copyWith(fontSize: 20.sp),
            ),
            SizedBox(
              height: 8.h,
            ),
            Text(
              syllabus.about,
              style: bodyStyle,
            ),
            SizedBox(
              height: 8.h,
            ),
            Divider(
              color: grey,
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: syllabus.chapters.length,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (_, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (_) {
                              return Dialog(
                                child: Container(
                                  color: Colors.white,
                                  padding: EdgeInsets.all(16.w),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Chapter ${index + 1}",
                                        style: bodyStyle.copyWith(),
                                      ),
                                      SizedBox(
                                        height: 8.h,
                                      ),
                                      Text(
                                        randomAlphaNumeric(10),
                                        style: headingStyle.copyWith(
                                            fontSize: 20.sp),
                                      ),
                                      SizedBox(
                                        height: 8.h,
                                      ),
                                      Container(
                                        color: primaryColor,
                                        padding: EdgeInsets.all(8),
                                        height: 48.h,
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.play_arrow,
                                                color: Colors.white,
                                              ),
                                              SizedBox(
                                                width: 16.h,
                                              ),
                                              Text(
                                                "Play",
                                                style: bodyStyle.copyWith(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              )
                                            ]),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            });
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 8.h),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.play_arrow,
                              size: 32.h,
                              color: primaryColor,
                            ),
                            SizedBox(
                              width: 16.w,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Chapter ${index + 1}",
                                  style: bodyStyle.copyWith(
                                      color: grey, fontSize: subBodyFontSize),
                                ),
                                Text(
                                  syllabus.chapters[index].title,
                                  style: bodyStyle.copyWith(color: black),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(
                      color: grey,
                    )
                  ],
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
