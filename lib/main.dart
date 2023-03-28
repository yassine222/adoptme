// ignore_for_file: prefer_const_constructors

import 'package:adoptme/screens/banned_page.dart';
import 'package:adoptme/screens/home_page.dart';
import 'package:adoptme/screens/verification_page.dart';
import 'package:adoptme/screens/login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final user = _auth.currentUser;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

late bool isbanned = false;
final navigatorkey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  checkIfUserBanned() async {
    try {
      // Get reference to Firestore collection
      var collectionRef = FirebaseFirestore.instance.collection('UserProfile');

      var doc = await collectionRef.doc(user!.uid).get();
      if (doc["isbanned"] == true) {
        setState(() {
          isbanned = true;
        });
      } else {
        setState(() {
          isbanned = false;
        });
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  void initState() {
    checkIfUserBanned();
    super.initState();
  }

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
            if (isbanned) {
              return BannedPage();
            } else {
              return HomePage();
            }
          } else {
            return LoginPage();
          }
        },
      ),
    );
  }
}
