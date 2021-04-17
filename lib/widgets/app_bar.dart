import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onco/api/auth_api.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onco/style.dart';

class AppBarCustom extends ConsumerWidget implements PreferredSizeWidget {
  final Function(int) onTap;

  AppBarCustom({required this.onTap});
  @override
  Widget build(BuildContext context, watch) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Center(
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          InkWell(
            onTap: () {
              Scaffold.of(context).openDrawer();
            },
            child: Icon(Icons.menu),
          ),
          watch(user) == null
              ? Container(
                  height: 36.h,
                  width: 36.h,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24), color: grey),
                )
              : InkWell(
                  onTap: () => onTap(2),
                  child: Container(
                    height: 36.h,
                    width: 36.h,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Image.network(
                        watch(user)?.photoURL ?? "",
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                )
        ]),
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size(ScreenUtil.defaultSize.width, 72.h);
}
