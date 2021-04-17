import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final roboto = "roboto";
final gilroy = "gilroy";

final subBodyFontSize = 14.sp;
final bodyFontSize = 16.sp;
final subHeadingFontSize = 22.sp;
final headingFontSize = 28.sp;

final black = Color(0xff171D1C);
final primaryColor = Color(0xff3454D1);
final secondaryColor = Color(0xffF3A712);
final offWhite = Color(0xffF4F4F6);
final grey = Color(0xff817F82);

final bodyStyle = TextStyle(
  fontFamily: roboto,
  fontSize: bodyFontSize,
  fontWeight: FontWeight.w400,
);

final buttonstyle = TextStyle(
    fontFamily: gilroy,
    fontSize: bodyFontSize,
    fontWeight: FontWeight.w600,
    color: black);

final appBarTitleStyle = TextStyle(
  fontFamily: gilroy,
  fontSize: 24.sp,
  fontWeight: FontWeight.w600,
  color: black,
);

final headingStyle =
    TextStyle(fontFamily: gilroy, fontWeight: FontWeight.w600, fontSize: 24.sp);

final subHeadingstyle = TextStyle(
  fontFamily: gilroy,
  fontWeight: FontWeight.w600,
  fontSize: subHeadingFontSize,
  color: black,
);
