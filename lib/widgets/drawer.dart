// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:adoptme/screens/add_pet_page.dart';
import 'package:adoptme/screens/explore_on_maps_page.dart';
import 'package:adoptme/screens/favorites_page.dart';
import 'package:adoptme/screens/messages_page.dart';
import 'package:adoptme/screens/update_profile_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../screens/my_post_page.dart';
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
                gradient: LinearGradient(
                  colors: [
                    Colors.deepPurple,
                    Colors.purple,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: FutureBuilder<DocumentSnapshot>(
                  future: users.doc(user!.uid).get(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text("Something went wrong");
                    }

                    if (snapshot.hasData && !snapshot.data!.exists) {
                      return Text("Document does not exist");
                    }
                    if (snapshot.connectionState == ConnectionState.done) {
                      Map<String, dynamic> data =
                          snapshot.data!.data() as Map<String, dynamic>;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 40,
                                backgroundImage:
                                    NetworkImage("${data['image']}"),
                              ),
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.white),
                                onPressed: () {
                                  Get.to(UpdateProfile());
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Text(
                            "${data['fullname']}",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "${data['email']}",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      );
                    }
                    return CircularProgressIndicator.adaptive();
                  }),
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
              leading: Icon(Icons.my_library_books_rounded,
                  size: _drawerIconSize,
                  color: Theme.of(context).colorScheme.secondary),
              title: Text(
                'My Posts',
                style: TextStyle(
                    fontSize: _drawerFontSize,
                    color: Theme.of(context).colorScheme.secondary),
              ),
              onTap: () {
                Get.to(MyPostsPage());
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
                Get.to(ExploreOnMaps());
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
              onTap: () {
                Get.to(FavoritsPage());
              },
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
