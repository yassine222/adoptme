// ignore_for_file: prefer_const_constructors

import 'package:adoptme/screens/details_page.dart';
import 'package:adoptme/services/favoriteService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FavoritsPage extends StatefulWidget {
  const FavoritsPage({super.key});

  @override
  State<FavoritsPage> createState() => _FavoritsPageState();
}

class _FavoritsPageState extends State<FavoritsPage> {
  final user = FirebaseAuth.instance.currentUser;

  final CollectionReference _favoriteStream =
      FirebaseFirestore.instance.collection('UserProfile');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorites"),
      ),
      body: StreamBuilder(
        stream:
            _favoriteStream.doc(user!.uid).collection("Favorite").snapshots(),
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
              final DocumentSnapshot documentSnapshot =
                  snapshot.data!.docs[index];
              return GestureDetector(
                onTap: () {
                  Get.to(DetailPage(documentSnapshot: documentSnapshot));
                },
                child: Card(
                  color: Color.fromARGB(255, 179, 138, 228),
                  shadowColor: Colors.deepPurple,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        onTap: () {},
                        leading: Container(
                          width: 100,
                          color: Colors.black,
                          child: Image(
                            fit: BoxFit.fill,
                            image: NetworkImage(
                              documentSnapshot['image'],
                            ),
                          ),
                        ),
                        title: Text(documentSnapshot['name']),
                        subtitle: Text(documentSnapshot['breed']),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          TextButton.icon(
                            onPressed: () {
                              FavoriteService().infavorite(documentSnapshot.id);
                            },
                            icon: Icon(
                              Icons.favorite,
                              color: Colors.deepPurple,
                            ),
                            label: Text(
                              'Défavoriser ',
                              style: TextStyle(color: Colors.deepPurple),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
