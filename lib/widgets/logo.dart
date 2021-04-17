import 'package:flutter/material.dart';
import 'package:onco/style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OncoLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Onco",
            style: TextStyle(
                fontSize: 32.sp,
                color: primaryColor,
                fontFamily: gilroy,
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
