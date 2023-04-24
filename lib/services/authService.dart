// ignore_for_file: non_constant_identifier_names, prefer_const_constructors, use_build_context_synchronously

import 'dart:ffi';

import 'package:adoptme/main.dart';
import 'package:adoptme/screens/login_page.dart';
import 'package:adoptme/screens/verification_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';

class AuthService {
  FirebaseAuth auth = FirebaseAuth.instance;

  Future SignUp(BuildContext context, String email, String password,
      String username, String phone) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      FirebaseFirestore.instance
          .collection('UserProfile')
          .doc(userCredential.user!.uid)
          .set({
        'fullname': username,
        'email': userCredential.user!.email,
        'phone': phone,
        'image':
            "https://cdn4.iconfinder.com/data/icons/evil-icons-user-interface/64/avatar-512.png",
        'adresse': "",
        'isbanned': false,
        'strike': 0,
        "createdAT": Timestamp.now(),
      }).then((value) async {
        print("profile updated");
      }).catchError((error) => print("Failed to add user: $error"));
      Get.to(VerificationPage());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
    navigatorkey.currentState!.popUntil((route) => route.isFirst);
  }

  Future SignIn(BuildContext context, String email, String password) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Required", e.message.toString(),
          icon: const Icon(
            Icons.warning_amber_rounded,
          ),
          backgroundColor: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
    }
    navigatorkey.currentState!.popUntil((route) => route.isFirst);
  }

  Future<void> LogOut() async {
    try {
      await FirebaseAuth.instance
          .signOut()
          .then((value) => Get.to(LoginPage()));
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
    } on Exception catch (e) {
      Get.snackbar("Required", "Verification email sent!",
          icon: const Icon(
            Icons.warning_amber_rounded,
          ),
          backgroundColor: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future ResetPassword(BuildContext context, String email) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: CircularProgressIndicator(),
      ),
    );
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      Get.snackbar("Required", "Password Reset email sent !",
          icon: const Icon(
            Icons.warning_amber_rounded,
          ),
          backgroundColor: Colors.white,
          snackPosition: SnackPosition.BOTTOM);

      Navigator.of(context).popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      print(e.message);
      Get.snackbar("Required", e.message.toString(),
          icon: const Icon(
            Icons.warning_amber_rounded,
            color: Colors.deepPurple,
          ),
          colorText: Colors.deepPurple,
          backgroundColor: Colors.white,
          snackPosition: SnackPosition.BOTTOM);

      Navigator.of(context).pop();
    }
  }

  Future<void> SignInWithFacebook(
    BuildContext context,
  ) async {
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login();

      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(loginResult.accessToken!.token);

      await auth.signInWithCredential(facebookAuthCredential);
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Required", e.message.toString(),
          icon: const Icon(
            Icons.warning_amber_rounded,
          ),
          backgroundColor: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}
