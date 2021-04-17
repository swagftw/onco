import 'package:flutter/material.dart';
import 'package:onco/style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ActionTile extends StatelessWidget {
  final bool? action;
  final String title;
  const ActionTile({Key? key, this.action, required this.title})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        action ?? true
            ? Container()
            : InkWell(
                child: Icon(Icons.arrow_back_ios),
              ),
        Text(
          title,
          style: headingStyle
        )
      ],
    );
  }
}
