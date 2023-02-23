// ignore_for_file: prefer_const_constructors

import 'package:adoptme/screens/verification_page.dart';
import 'package:adoptme/screens/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

final navigatorkey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pets Adoption App',
      navigatorKey: navigatorkey,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: StreamBuilder<User?>(
        stream: _auth.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return VerificationPage();
          } else {
            return LoginPage();
          }
        },
      ),
    );
  }
}
