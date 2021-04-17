import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:onco/api/auth_api.dart';
import 'package:onco/app/home/learn_course_page.dart';
import 'package:onco/main.dart';
import 'package:onco/models/course.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onco/style.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../api/firestore_api.dart';

class CourseDetails extends ConsumerWidget {
  final Course course;

  const CourseDetails({Key? key, required this.course}) : super(key: key);
  @override
  Widget build(BuildContext context, watch) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: black),
        elevation: 2,
        title: Text(
          course.name,
          style: bodyStyle.copyWith(color: black),
        ),
      ),
      bottomNavigationBar: EnrollBottomButton(
        course: course,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 24.h,
                ),
                AspectRatio(
                  aspectRatio: 1.5,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: course.banner,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(
                  height: 16.h,
                ),
                Text(
                  course.name,
                  style: headingStyle.copyWith(fontSize: subHeadingFontSize),
                ),
                SizedBox(
                  height: 8.h,
                ),
                Text("offered by,"),
                Text(
                  course.instructor,
                  style: bodyStyle,
                ),
                SizedBox(
                  height: 16.h,
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                  decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "About the course",
                        style: subHeadingstyle.copyWith(fontSize: 20.sp),
                      ),
                      SizedBox(
                        height: 16.h,
                      ),
                      Text(
                        course.about,
                        style: bodyStyle.copyWith(color: grey),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 16.h,
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundColor: primaryColor,
                    child: Icon(
                      Icons.online_prediction,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    "100% " + course.mode,
                    style: bodyStyle,
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundColor: primaryColor,
                    child: Icon(
                      Icons.signal_cellular_alt,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    course.level + " level",
                    style: bodyStyle,
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundColor: primaryColor,
                    child: Icon(
                      Icons.query_builder,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    course.duration + " weeks to complete",
                    style: bodyStyle,
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundColor: primaryColor,
                    child: Icon(
                      Icons.language,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    course.language,
                    style: bodyStyle,
                  ),
                ),
                SizedBox(
                  height: 24.h,
                ),
                Text(
                  "syllabys",
                  style: headingStyle.copyWith(fontSize: 20.sp),
                ),
                SizedBox(
                  height: 16.h,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: course.syllabus.length,
                  itemBuilder: (_, index) {
                    return Container(
                      padding: EdgeInsets.all(8.w),
                      margin: EdgeInsets.only(bottom: 16.w),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade200),
                          borderRadius: BorderRadius.circular(4)),
                      child: ExpandablePanel(
                          expanded: Container(
                              padding: EdgeInsets.all(8.w),
                              margin: EdgeInsets.only(top: 8.w),
                              decoration: BoxDecoration(
                                  color: offWhite,
                                  borderRadius: BorderRadius.circular(4)),
                              child: Text(
                                course.syllabus[index].about,
                                style:
                                    bodyStyle.copyWith(color: Colors.black54),
                              )),
                          header: RichText(
                            text: TextSpan(children: [
                              TextSpan(
                                text: "Week ${course.syllabus[index].week} : ",
                                style: bodyStyle.copyWith(color: black),
                              ),
                              TextSpan(
                                text: "${course.syllabus[index].module}",
                                style: bodyStyle.copyWith(
                                    color: black, fontWeight: FontWeight.w600),
                              )
                            ]),
                          ),
                          collapsed: Container()),
                    );
                  },
                ),
                Container(
                  height: 50,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

final razorpayProvider = Provider<Razorpay>((ref) {
  return Razorpay();
});

class EnrollBottomButton extends StatefulWidget {
  final Course course;

  EnrollBottomButton({required this.course});

  @override
  _EnrollBottomButtonState createState() => _EnrollBottomButtonState();
}

class _EnrollBottomButtonState extends State<EnrollBottomButton> {
  String getDate() {
    return DateFormat("dd, MMM, yyyy").format(
        DateTime.fromMillisecondsSinceEpoch(
            widget.course.startingDate.toInt() * 1000));
  }

  @override
  void initState() {
    var _razorpay = context.read(razorpayProvider);
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
  }

  Future _handlePaymentSuccess(PaymentSuccessResponse response) async {
    if (!widget.course.student.contains(context.read(user)?.uid)) {
      await context.read(courseEnrollApiProvider.notifier).enroll(
          widget.course.id,
          context.read(user)?.uid ?? "",
          widget.course.student);
      showDialog(
          context: context,
          builder: (_) {
            return Dialog(
              child: Container(
                padding: EdgeInsets.all(16.w),
                child: Row(
                  children: [
                    Icon(Icons.check, color: Colors.green),
                    SizedBox(
                      width: 16.h,
                    ),
                    Text(
                      "Enrolled successfully..",
                      style: bodyStyle,
                    ),
                  ],
                ),
              ),
            );
          });
    }
  }

  Future _handleExternalWallet(ExternalWalletResponse response) async {}

  Future _handlePaymentError(PaymentFailureResponse response) async {
    showDialog(
        context: context,
        builder: (_) {
          return Dialog(
            child: Container(
              padding: EdgeInsets.all(16.w),
              child: Row(
                children: [
                  Icon(Icons.close, color: Colors.red),
                  SizedBox(
                    width: 16.h,
                  ),
                  Text(
                    "Payment failed..",
                    style: bodyStyle,
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (_, watch, child) {
        final courseEnrollApi = watch(courseEnrollApiProvider);
        return Container(
          width: double.infinity,
          height: 56.h,
          color: primaryColor,
          child: context.read(user) == null
              ? TextButton(
                  onPressed: () async {
                    await context.read(firebaseApiProvider).googleSignIn();
                    if (context.read(user) != null) {
                      watch(sharedPreferenceProvider)
                          ?.setBool("isSkipped", false);
                      watch(isSkippedProvider).state = false;
                    }
                  },
                  child: Text(
                    "Sign in to Enroll",
                    style: bodyStyle.copyWith(
                        color: Colors.white,
                        fontFamily: gilroy,
                        fontWeight: FontWeight.w600),
                  ))
              : TextButton(
                  child: courseEnrollApi.when(
                      error: (_, __) => Container(),
                      loading: () => CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(
                            Colors.white,
                          )),
                      data: (data) => widget.course.student
                              .contains(context.read(user)?.uid ?? "")
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.check,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 8.w,
                                ),
                                Text(
                                  "Enrolled Aleady",
                                  style:
                                      bodyStyle.copyWith(color: Colors.white),
                                ),
                              ],
                            )
                          : Text(
                              "Enroll (from ${getDate()})",
                              style: bodyStyle.copyWith(color: Colors.white),
                            )),
                  onPressed: () async {
                    if (!widget.course.student
                        .contains(context.read(user)?.uid)) {
                      var options = {
                        'key': const String.fromEnvironment("KEY"),
                        'amount': widget.course.price * 100,
                        'name': widget.course.name,
                        'description': widget.course.about.substring(1, 200),
                        'prefill': {
                          'contact': context.read(user)?.phoneNumber,
                          'email': context.read(user)?.email
                        }
                      };
                      context.read(razorpayProvider).open(options);
                    } else {
                      await Navigator.of(context)
                          .push(MaterialPageRoute(builder: (_) {
                        return LearnCoursePage(course: widget.course);
                      }));
                    }
                  },
                ),
        );
      },
    );
  }
}
