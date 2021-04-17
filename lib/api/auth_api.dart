import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:onco/main.dart';

final firebaseInstanceProvider = Provider<FirebaseAuth>((_) {
  return FirebaseAuth.instance;
});

final firebaseApiProvider = Provider<FirebaseAuthApi>((ref) {
  final firebaseInstance = ref.watch(firebaseInstanceProvider);
  return FirebaseAuthApi(firebaseInstance);
});

final authStateProvider = StreamProvider.autoDispose<User?>((ref) {
  return FirebaseAuth.instance.userChanges();
});

final user = Provider.autoDispose<User?>((ref) {
  final instance = ref.watch(firebaseInstanceProvider);
  return instance.currentUser;
});

final isSkippedProvider = StateProvider<bool>((ref) {
  final pref = ref.watch(sharedPreferenceProvider);
  return pref?.getBool("isSkipped") ?? false;
});

class FirebaseAuthApi {
  FirebaseAuthApi(this._auth);
  FirebaseAuth _auth;

  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: [
    "email",
    "https://www.googleapis.com/auth/cloud-platform.read-only"
  ]);

  Future googleSignIn() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      final authentication = await googleUser?.authentication;
      final creds = GoogleAuthProvider.credential(
        accessToken: authentication?.accessToken ?? "",
        idToken: authentication?.idToken ?? "",
      );
      final userCredential = await _auth.signInWithCredential(creds);
      print(userCredential.user?.uid);
      onAuthStateChange(userCredential.user);
    } catch (e) {
      print("cancelled login");
    }
  }

  Stream<User?> onAuthStateChange(User? user) {
    return _auth.userChanges().map((event) => event = user);
  }

  Future signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
    print("signed out");
  }
}
