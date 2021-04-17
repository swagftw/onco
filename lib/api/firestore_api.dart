import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onco/api/auth_api.dart';
import 'package:onco/app/home/course_details.dart';
import 'package:onco/models/course.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:uuid/uuid.dart';

class CourseApi extends StateNotifier<AsyncValue<List<Course>>> {
  CourseApi(this._firebaseFirestore) : super(AsyncValue.loading()) {
    // for (var i = 0; i < 10; i++) {
    //   add();
    // }
    getAllCourses();
  }
  FirebaseFirestore _firebaseFirestore;
  var uuid = Uuid();
  Future getAllCourses() async {
    if (state != AsyncValue.loading()) {
      state = AsyncValue.loading();
    }

    await Future.delayed(Duration(seconds: 3));
    final snapshot = await _firebaseFirestore.collection("courses").get();
    // final data = snapshot.docs.map((e) => e.data()).toList();
    final courses =
        snapshot.docs.map<Course>((e) => Course.fromJson(e.data())).toList();

    state = AsyncValue.data(courses);
  }
}

class CourseEnrollApi extends StateNotifier<AsyncValue<bool>> {
  CourseEnrollApi(this._firestore, this._razorpay)
      : super(AsyncValue.data(false));
  FirebaseFirestore _firestore;
  Razorpay _razorpay;
  Future enroll(String id, String userId, List<String> students) async {
    state = AsyncValue.loading();
    try {  
      students.add(userId);
      final QuerySnapshot docs = await _firestore
          .collection("courses")
          .where("id", isEqualTo: id)
          .get();
      await _firestore
          .collection("courses")
          .doc(docs.docs[0].reference.id)
          .update({"student": students});
      state = AsyncValue.data(true);
    } catch (e) {}
  }
}

final courseEnrollApiProvider =
    StateNotifierProvider<CourseEnrollApi, AsyncValue>((ref) {
  final firestore = ref.watch(firestoreProvider);
  final razorpay = ref.watch(razorpayProvider);
  return CourseEnrollApi(firestore, razorpay);
});

final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});
final courseApi = StateNotifierProvider<CourseApi, AsyncValue<List<Course>>>(
  (ref) {
    final firestore = ref.watch(firestoreProvider);
    return CourseApi(firestore);
  },
);
