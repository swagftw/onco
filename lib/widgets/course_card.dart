import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onco/app/home/course_details.dart';
import 'package:onco/app/home/home_page.dart';
import 'package:onco/models/course.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onco/style.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CourseCard extends ConsumerWidget {
  final Course course;

  const CourseCard({Key? key, required this.course}) : super(key: key);
  @override
  Widget build(BuildContext context, watch) {
    return InkWell(
      onTap: () async {
        
        await Navigator.of(context).push(MaterialPageRoute(builder: (_) {
          return CourseDetails(course: course);
        }));
      },
      child: Container(
        height: 230.h,
        width: 160.w,
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
            color: offWhite, borderRadius: BorderRadius.circular(8)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: course.banner,
                placeholder: (_, __) {
                  return Image.asset(
                    "assets/images/place.png",
                    fit: BoxFit.fitWidth,
                  );
                },
                fit: BoxFit.fitWidth,
              ),
            ),
            SizedBox(
              height: 8.h,
            ),
            Container(
                child: Text(
              course.name,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: bodyStyle.copyWith(),
            )),
            Container(
              child: Text(
                course.offeredBy,
                overflow: TextOverflow.ellipsis,
                style:
                    bodyStyle.copyWith(color: grey, fontSize: subBodyFontSize),
              ),
            ),
            SizedBox(
              height: 4.h,
            ),
            Text(
              "with certificate",
              overflow: TextOverflow.ellipsis,
              style: bodyStyle.copyWith(color: grey, fontSize: subBodyFontSize),
            ),
            SizedBox(
              height: 4.h,
            ),
            Row(
              children: [
                RatingBar.builder(
                  initialRating: 1,
                  minRating: 1,
                  direction: Axis.horizontal,
                  itemCount: 1,
                  itemSize: 16.w,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {},
                ),
                Text(
                  "(" + (course.reviews / 1000).toDouble().toString() + "k)",
                  style: bodyStyle.copyWith(
                      color: grey, fontSize: subBodyFontSize),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
