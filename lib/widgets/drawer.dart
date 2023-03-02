// ignore_for_file: prefer_const_constructors

import 'package:adoptme/screens/add_pet_page.dart';
import 'package:adoptme/screens/explore_on_maps_page.dart';
import 'package:adoptme/screens/favorites_page.dart';
import 'package:adoptme/screens/home_page.dart';
import 'package:adoptme/screens/messages_page.dart';
import 'package:adoptme/screens/signup_page.dart';
import 'package:adoptme/screens/update_profile_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../screens/verification_page.dart';
import '../services/authService.dart';

class DrawerPage extends StatefulWidget {
  const DrawerPage({super.key});

  @override
  State<DrawerPage> createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  final double _drawerIconSize = 24;
  final double _drawerFontSize = 17;
  final User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    CollectionReference users =
        FirebaseFirestore.instance.collection('UserProfile');
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: const [
              0.0,
              1.0
            ],
                colors: [
              Theme.of(context).primaryColor.withOpacity(0.2),
              Theme.of(context).colorScheme.secondary.withOpacity(0.5),
            ])),
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).splashColor,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: const [0.0, 1.0],
                  colors: [
                    Theme.of(context).primaryColor,
                    Theme.of(context).colorScheme.secondary,
                  ],
                ),
              ),
              child: Container(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    FutureBuilder<DocumentSnapshot>(
                        future: users.doc(user!.uid).get(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Text("Something went wrong");
                          }

                          if (snapshot.hasData && !snapshot.data!.exists) {
                            return Text("Document does not exist");
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            Map<String, dynamic> data =
                                snapshot.data!.data() as Map<String, dynamic>;
                            return ListTile(
                              leading: CircleAvatar(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.white,
                                backgroundImage:
                                    NetworkImage("${data['image']}"),
                                radius: 30,
                              ),
                              title: Text("${data['fullname']}"),
                              subtitle: Text("${data['email']}"),
                            );
                          }
                          return SizedBox();
                        }),
                    TextButton.icon(
                      onPressed: () {
                        Get.to(UpdateProfile());
                      },
                      icon: Icon(Icons.edit),
                      label: Text("Edit Profile"),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home,
                  size: _drawerIconSize,
                  color: Theme.of(context).colorScheme.secondary),
              title: Text(
                'Home Page',
                style: TextStyle(
                    fontSize: _drawerFontSize,
                    color: Theme.of(context).colorScheme.secondary),
              ),
              onTap: () {
                navigator?.pop(context);
              },
            ),
            Divider(
              color: Theme.of(context).primaryColor,
              height: 1,
            ),
            ListTile(
              leading: Icon(Icons.add,
                  size: _drawerIconSize,
                  color: Theme.of(context).colorScheme.secondary),
              title: Text(
                'Add Pet',
                style: TextStyle(
                    fontSize: _drawerFontSize,
                    color: Theme.of(context).colorScheme.secondary),
              ),
              onTap: () {
                Get.to(AddPetPage());
              },
            ),
            Divider(
              color: Theme.of(context).primaryColor,
              height: 1,
            ),
            ListTile(
              leading: Icon(
                Icons.map_sharp,
                size: _drawerIconSize,
                color: Theme.of(context).colorScheme.secondary,
              ),
              title: Text(
                'Explore nearby Pets',
                style: TextStyle(
                    fontSize: _drawerFontSize,
                    color: Theme.of(context).colorScheme.secondary),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ExploreOnMaps()),
                );
              },
            ),
            Divider(
              color: Theme.of(context).primaryColor,
              height: 1,
            ),
            ListTile(
              leading: Icon(
                Icons.favorite,
                size: _drawerIconSize,
                color: Theme.of(context).colorScheme.secondary,
              ),
              title: Text(
                'Favorites',
                style: TextStyle(
                    fontSize: _drawerFontSize,
                    color: Theme.of(context).colorScheme.secondary),
              ),
              onTap: () {},
            ),
            Divider(
              color: Theme.of(context).primaryColor,
              height: 1,
            ),
            ListTile(
              leading: Icon(
                Icons.message_sharp,
                size: _drawerIconSize,
                color: Theme.of(context).colorScheme.secondary,
              ),
              title: Text(
                'Messages',
                style: TextStyle(
                    fontSize: _drawerFontSize,
                    color: Theme.of(context).colorScheme.secondary),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MessagesPage()),
                );
              },
            ),
            Divider(
              color: Theme.of(context).primaryColor,
              height: 1,
            ),
            ListTile(
              leading: Icon(
                Icons.logout_rounded,
                size: _drawerIconSize,
                color: Theme.of(context).colorScheme.secondary,
              ),
              title: Text(
                'Logout',
                style: TextStyle(
                    fontSize: _drawerFontSize,
                    color: Theme.of(context).colorScheme.secondary),
              ),
              onTap: () {
                AuthService().LogOut();
              },
            ),
          ],
        ),
      ),
    );
  }
}
