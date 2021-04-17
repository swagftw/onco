import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onco/api/auth_api.dart';
import 'package:onco/main.dart';
import 'package:onco/style.dart';
import 'package:onco/widgets/logo.dart';

class LoginPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, watch) {
    return Scaffold(
      floatingActionButton: TextButton(
        onPressed: () async {
          await context
              .read(sharedPreferenceProvider)
              ?.setBool("isSkipped", true);
          watch(isSkippedProvider).state = true;
        },
        child: Text(
          "Skip to home",
          style: TextStyle(fontFamily: gilroy, color: primaryColor),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              children: [
                SizedBox(
                  height: 56.h,
                ),
                OncoLogo(),
                SizedBox(
                  height: 48.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: AspectRatio(
                      aspectRatio: 1,
                      child: SvgPicture.asset("assets/images/login.svg")),
                ),
                SizedBox(
                  height: 24.h,
                ),
                Text(
                  "Learn on Onco",
                  style: TextStyle(
                      color: black,
                      fontFamily: gilroy,
                      fontWeight: FontWeight.w600,
                      fontSize: headingFontSize),
                ),
                SizedBox(
                  height: 24.h,
                ),
                Container(
                  width: ScreenUtil.defaultSize.width * 2 / 3,
                  decoration: BoxDecoration(
                      border: Border.all(color: primaryColor),
                      borderRadius: BorderRadius.circular(8)),
                  child: TextButton.icon(
                      onPressed: () async {
                        await context.read(firebaseApiProvider).googleSignIn();
                      },
                      icon: Container(
                        child: Image.asset("assets/images/google.png"),
                        height: 32.h,
                        width: 32.h,
                      ),
                      label: Text(
                        "Sign in with Google",
                        style: buttonstyle.copyWith(color: primaryColor),
                      )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
