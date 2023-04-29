// ignore_for_file: prefer_const_constructors

import 'package:adoptme/screens/verificationpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

import 'package:adoptme/screens/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
  // runApp(
  //   DevicePreview(
  //     enabled: true,
  //     builder: (context) => MyApp(), // Wrap your app
  //   ),
  // );
}

final FirebaseAuth _auth = FirebaseAuth.instance;
final user = _auth.currentUser;

final navigatorkey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // useInheritedMediaQuery: true,
      // locale: DevicePreview.locale(context),
      // builder: DevicePreview.appBuilder,
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
