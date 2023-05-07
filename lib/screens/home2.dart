import 'package:adoptme/screens/add_pet_page.dart';
import 'package:adoptme/screens/explore_on_maps_page.dart';
import 'package:adoptme/screens/favorites_page.dart';
import 'package:adoptme/screens/home_page.dart';
import 'package:adoptme/widgets/drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import 'banned_page.dart';

class Home2 extends StatefulWidget {
  const Home2({super.key});

  @override
  State<Home2> createState() => _Home2State();
}

class _Home2State extends State<Home2> {
  int _selectedIndex = 0;

  final user = FirebaseAuth.instance.currentUser;
  static const List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    FavoritsPage(),
    ExploreOnMaps(),
    AddPetPage()
  ];
  Stream<bool> isUserBanned(String userId) {
    final userProfileRef =
        FirebaseFirestore.instance.collection('UserProfile').doc(userId);
    return userProfileRef.snapshots().map((snapshot) {
      if (!snapshot.exists) {
        return false;
      }
      final isBanned = snapshot['isbanned'];
      return isBanned;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: isUserBanned(user!.uid),
        builder: (context, snapshot) {
          if (snapshot.data == true) {
            return const BannedPage();
          } else {
            return Scaffold(
              drawer: const DrawerPage(),
              body: Center(
                child: _widgetOptions.elementAt(_selectedIndex),
              ),
              bottomNavigationBar: Container(
                decoration: const BoxDecoration(),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 8),
                    child: GNav(
                      rippleColor: Colors.grey[300]!,
                      hoverColor: Colors.grey[100]!,
                      gap: 8,
                      activeColor: Colors.deepPurple,
                      iconSize: 22,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      duration: const Duration(milliseconds: 400),
                      tabBackgroundColor: Colors.grey[100]!,
                      color: Colors.deepPurple,
                      tabs: const [
                        GButton(
                          icon: FontAwesome.home,
                          text: 'Home',
                        ),
                        GButton(
                          icon: FontAwesome.heart,
                          text: 'Favorite',
                        ),
                        GButton(
                          icon: FontAwesome.map,
                          text: 'Explore',
                        ),
                        GButton(
                          icon: FontAwesome.plus_circled,
                          text: 'Post',
                        ),
                      ],
                      selectedIndex: _selectedIndex,
                      onTabChange: (index) {
                        setState(() {
                          _selectedIndex = index;
                        });
                      },
                    ),
                  ),
                ),
              ),
            );
          }
        });
  }
}
