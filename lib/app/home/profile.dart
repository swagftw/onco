import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onco/api/firestore_api.dart';
import 'package:onco/app/home/my_courses.dart';
import 'package:onco/main.dart';
import 'package:onco/style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import '../../api/auth_api.dart';

class ProfilePage extends ConsumerWidget {
  final Function(int) onTap;

  ProfilePage({required this.onTap});
  @override
  Widget build(BuildContext context, watch) {
    final coursesProvider = watch(courseApi);
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 56.sp,
              ),
              Text("Profile", style: headingStyle),
              SizedBox(
                height: 16.h,
              ),
              context.read(firebaseInstanceProvider).currentUser == null
                  ? Container(
                      width: double.infinity,
                      color: primaryColor,
                      child: TextButton(
                        onPressed: () async {
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
                        },
                        child: Text(
                          "Sign in to see profile",
                          style: bodyStyle.copyWith(
                              color: Colors.white,
                              fontFamily: gilroy,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    )
                  : ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Container(
                        height: 36.h,
                        width: 36.h,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: Image.network(
                            context
                                    .read(firebaseInstanceProvider)
                                    .currentUser
                                    ?.photoURL ??
                                "",
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      title: Text(
                        context
                                .read(firebaseInstanceProvider)
                                .currentUser
                                ?.displayName ??
                            "",
                        style: bodyStyle.copyWith(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(context
                              .read(firebaseInstanceProvider)
                              .currentUser
                              ?.email ??
                          ""),
                    ),
              SizedBox(
                height: 24.h,
              ),
              coursesProvider.when(
                  data: (courses) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Courses Enrolled in",
                            style: bodyStyle.copyWith(fontSize: 20.sp),
                          ),
                          SizedBox(
                            height: 16.h,
                          ),
                          Text(
                            courses
                                .where((element) => element.student.contains(
                                    context
                                            .read(firebaseInstanceProvider)
                                            .currentUser
                                            ?.uid ??
                                        ""))
                                .toList()
                                .length
                                .toString(),
                            style: headingStyle.copyWith(fontSize: 32.sp),
                          ),
                          SizedBox(
                            height: 24.h,
                          ),
                        ],
                      ),
                  loading: () => Center(
                        child: CircularProgressIndicator(),
                      ),
                  error: (_, __) => Container()),
              Container(
                color: primaryColor,
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    onTap(0);
                  },
                  child: Text(
                    "Explore more courses",
                    style: bodyStyle.copyWith(
                        fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
