// ignore_for_file: prefer_const_constructors

import 'package:adoptme/main.dart';
import 'package:adoptme/screens/editPost.dart';
import 'package:adoptme/screens/home_page.dart';
import 'package:adoptme/screens/petCard.dart';
import 'package:adoptme/widgets/drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import 'details_page.dart';

class MyPostsPage extends StatefulWidget {
  const MyPostsPage({super.key});

  @override
  State<MyPostsPage> createState() => _MyPostsPageState();
}

class _MyPostsPageState extends State<MyPostsPage> {
  String petName = "";
  final CollectionReference _myPetStrem =
      FirebaseFirestore.instance.collection('UserPost');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Posts"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Navigate to a custom route instead of the default route
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 20.0,
              ),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0)),
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  children: [
                    Icon(
                      FontAwesomeIcons.search,
                      color: Colors.grey,
                    ),
                    Expanded(
                      child: TextField(
                        onChanged: (value) {
                          petName = value;
                          setState(() {
                            petName = value;
                          });
                        },
                        style: TextStyle(fontSize: 18.0),
                        decoration: InputDecoration(
                            border:
                                OutlineInputBorder(borderSide: BorderSide.none),
                            hintText: 'Search your pets by name'),
                      ),
                    ),
                    Icon(
                      FontAwesomeIcons.filter,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 600,
              child: StreamBuilder<QuerySnapshot>(
                stream: petName == ""
                    ? _myPetStrem
                        .where("id", isEqualTo: user!.uid)
                        .orderBy("createdAt", descending: true)
                        .snapshots()
                    : _myPetStrem
                        .where("id", isEqualTo: user!.uid)
                        .where("name", isEqualTo: petName)
                        .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    print(snapshot.error.toString());
                    return Text(snapshot.error.toString());
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator.adaptive();
                  }

                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      final DocumentSnapshot documentSnapshot =
                          snapshot.data!.docs[index];

                      return PetCard(
                          imageUrl: documentSnapshot["image"],
                          name: documentSnapshot["name"],
                          breed: documentSnapshot["breed"],
                          onDelete: () => deleteUserPost(documentSnapshot.id),
                          onUpdate: () => Get.to(() => EditPost(
                                documentSnapshot: documentSnapshot,
                              )),
                          onBookmark: () => null);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> deleteUserPost(String postId) async {
    try {
      await FirebaseFirestore.instance
          .collection('UserPost')
          .doc(postId)
          .delete();
      print('Post deleted successfully');
    } catch (error) {
      print('Failed to delete post: $error');
    }
  }
}
