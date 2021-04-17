import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onco/api/auth_api.dart';
import 'package:onco/api/firestore_api.dart';
import 'package:onco/app/home/my_courses.dart';
import 'package:onco/app/home/profile.dart';
import 'package:onco/main.dart';
import 'package:onco/models/course.dart';
import 'package:onco/style.dart';
import 'package:onco/widgets/action_tile.dart';
import 'package:onco/widgets/app_bar.dart';
import 'package:onco/widgets/course_card.dart';
import 'package:onco/widgets/new_course_card.dart';
import 'package:onco/widgets/search_field.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

final hideNavbarProvider = StateProvider<bool>((ref) {
  return false;
});

class TabView extends StatefulWidget {
  @override
  _TabViewState createState() => _TabViewState();
}

class _TabViewState extends State<TabView> {
  PersistentTabController? _controller;
  @override
  void initState() {
    _controller = PersistentTabController(initialIndex: 1);
    super.initState();
  }

  jumpTo(int page) {
    _controller?.jumpToTab(page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: Consumer(
          builder: (_, watch, child) => PersistentTabView(
            context,
            hideNavigationBar: watch(hideNavbarProvider).state,
            navBarHeight: 56.h,
            controller: _controller,
            itemAnimationProperties:
                ItemAnimationProperties(duration: Duration(milliseconds: 200)),
            screens: [
              HomePage(
                onTap: jumpTo,
              ),
              MyCourses(),
              ProfilePage(
                onTap: jumpTo,
              )
            ],
            items: [
              PersistentBottomNavBarItem(
                  icon: Icon(Icons.home_outlined), title: "Explore"),
              PersistentBottomNavBarItem(
                  icon: Icon(Icons.play_arrow), title: "My Courses"),
              PersistentBottomNavBarItem(
                  icon: Icon(Icons.person_outline), title: "Profile"),
            ],
          ),
        ),
      ),
    );
  }
}

class HomePage extends ConsumerWidget {
  final Function(int) onTap;

  HomePage({required this.onTap});
  @override
  Widget build(BuildContext context, watch) {
    final usr = watch(user);
    final name = usr?.displayName?.split(" ")[0];

    return Scaffold(
      backgroundColor: Colors.white,
      drawer: Drawer(
        child: Column(
          children: [
            context.read(user) == null
                ? ListTile(
                    leading: Container(
                      child: Image.asset("assets/images/google.png"),
                      height: 32.h,
                      width: 32.h,
                    ),
                    title: Text(
                      "Sign in with Google",
                      style: buttonstyle.copyWith(color: primaryColor),
                    ),
                    onTap: () async {
                      await watch(firebaseApiProvider).googleSignIn();
                      watch(sharedPreferenceProvider)
                          ?.setBool("isSkipped", false);
                      watch(isSkippedProvider).state = false;
                    },
                  )
                : Container(),
            Spacer(),
            context.read(user) == null
                ? Container()
                : ListTile(
                    leading: Icon(Icons.exit_to_app),
                    title: Text(
                      "Log out",
                      style: bodyStyle.copyWith(fontWeight: FontWeight.w600),
                    ),
                    onTap: () async {
                      await showDialog(
                        context: context,
                        useRootNavigator: false,
                        builder: (_) => AlertDialog(
                          title: Text("Sure log out ?"),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("Cancel")),
                            TextButton(
                                onPressed: () async {
                                  await context
                                      .read(firebaseApiProvider)
                                      .signOut();
                                  watch(sharedPreferenceProvider)
                                      ?.setBool("isSkipped", false);
                                  watch(isSkippedProvider).state = false;
                                },
                                child: Text("Ok"))
                          ],
                        ),
                      );
                    },
                  )
          ],
        ),
      ),
      appBar: AppBarCustom(onTap: onTap),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await watch(courseApi.notifier).getAllCourses();
          },
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ActionTile(title: name != null ? "Hi $name," : "Hi,"),
                  Text(
                    "Explore",
                    style: headingStyle.copyWith(color: secondaryColor),
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  SearchField(),
                  CourseSection()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CourseSection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, watch) {
    final firestoreApi = watch(courseApi);

    return firestoreApi.when(
      data: (courses) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 24.h,
            ),
            NewCourseSlider(
                courses:
                    courses.where((element) => element.type == "new").toList()),
            SizedBox(
              height: 24.h,
            ),
            Text(
              "Popular Courses",
              style: subHeadingstyle,
            ),
            SizedBox(
              height: 16.h,
            ),
            PopularCoursesList(
              courses: courses
                  .where((element) => element.type == "popular")
                  .toList(),
            ),
            SizedBox(
              height: 24.h,
            ),
            Text(
              "Trending Now",
              style: subHeadingstyle,
            ),
            SizedBox(
              height: 16.h,
            ),
            TrendingCoursesList(
              courses: courses
                  .where((element) => element.type == "trending")
                  .toList(),
            ),
          ],
        );
      },
      error: (err, stack) => Container(),
      loading: () => Center(
        child: Container(
            margin: EdgeInsets.only(top: 56.h),
            child: CircularProgressIndicator()),
      ),
    );
  }
}

class NewCourseSlider extends StatelessWidget {
  final List<Course> courses;

  const NewCourseSlider({Key? key, required this.courses}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    print(courses.length);
    return CarouselSlider(
      items: courses.map<NewCourseCard>((e) {
        return NewCourseCard(
          course: e,
        );
      }).toList(),
      options: CarouselOptions(
        scrollPhysics: BouncingScrollPhysics(),
        enableInfiniteScroll: false,
        aspectRatio: 2.5,
        viewportFraction: 1,
      ),
    );
  }
}

class PopularCoursesList extends StatelessWidget {
  final List<Course> courses;

  const PopularCoursesList({Key? key, required this.courses}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 230.h,
      child: ListView.builder(
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: courses.length,
          itemBuilder: (_, index) {
            return Container(
                margin: EdgeInsets.only(right: 16.w),
                child: CourseCard(course: courses[index]));
          }),
    );
  }
}

class TrendingCoursesList extends StatelessWidget {
  final List<Course> courses;

  const TrendingCoursesList({Key? key, required this.courses})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 230.h,
      child: ListView.builder(
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: courses.length,
          itemBuilder: (_, index) {
            return Container(
                margin: EdgeInsets.only(right: 16.w),
                child: CourseCard(course: courses[index]));
          }),
    );
  }
}
