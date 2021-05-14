import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onco/api/auth_api.dart';
import 'package:onco/app/auth/login_page.dart';
import 'package:onco/app/home/home_page.dart';
import 'package:onco/style.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferenceProvider = Provider<SharedPreferences?>((ref) {
  return null;
});

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPref = await SharedPreferences.getInstance();
  await Firebase.initializeApp();
  runApp(
    ProviderScope(overrides: [
      sharedPreferenceProvider.overrideWithValue(sharedPref),
    ], child: Onco()),
  );
}

class Onco extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          primaryColor: primaryColor,
          secondaryHeaderColor: secondaryColor,
        ),
        debugShowCheckedModeBanner: false,
        home: AuthBuilder());
  }
}

class AuthBuilder extends ConsumerWidget {
  @override
  Widget build(BuildContext context, watch) {
    final loginSkipped = watch(isSkippedProvider);
    final size = MediaQuery.of(context).size;
    return ScreenUtilInit(
      builder: () => loginSkipped.state ? TabView() : AuthWidget(),
      designSize: Size(size.width, size.height),
    );
  }
}

class AuthWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, watch) {
    final authProvider = watch(authStateProvider);
    return authProvider.when(
      data: (user) => user == null ? LoginPage() : TabView(),
      loading: () => Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (err, stack) => Scaffold(
        body: Center(
          child: Text(err.toString()),
        ),
      ),
    );
  }
}
