// ignore_for_file: prefer_const_constructors

import 'package:adoptme/screens/details_page.dart';
import 'package:adoptme/screens/petcard.dart';
import 'package:adoptme/services/favoriteservice.dart';
import 'package:adoptme/widgets/favoritepetwidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class FavoritsPage extends StatefulWidget {
  const FavoritsPage({super.key});

  @override
  State<FavoritsPage> createState() => _FavoritsPageState();
}

class _FavoritsPageState extends State<FavoritsPage> {
  final user = FirebaseAuth.instance.currentUser;
  String petName = "";

  final CollectionReference _favoriteStream =
      FirebaseFirestore.instance.collection('UserProfile');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Favorites")),
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
              height: 500,
              child: StreamBuilder<QuerySnapshot>(
                stream: petName == ""
                    ? _favoriteStream
                        .doc(user!.uid)
                        .collection("Favorite")
                        .snapshots()
                    : _favoriteStream
                        .doc(user!.uid)
                        .collection("Favorite")
                        .where("name", isEqualTo: petName.toLowerCase())
                        .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator.adaptive();
                  }

                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      final DocumentSnapshot favoritePet =
                          snapshot.data!.docs[index];
                      return GestureDetector(
                        onTap: () => Get.to(
                            () => DetailPage(documentSnapshot: favoritePet)),
                        child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(15.0),
                                  child: Image.network(
                                    favoritePet["image"],
                                    height: 180,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  favoritePet["name"],
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  favoritePet["breed"],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          FavoriteService()
                                              .infavorite(favoritePet.id);
                                        },
                                        icon: Icon(
                                          Icons.favorite,
                                          color: Colors.deepPurple,
                                          size: 33,
                                        ))
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      );
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
}
