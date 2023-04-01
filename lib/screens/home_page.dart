// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:adoptme/screens/banned_page.dart';
import 'package:adoptme/screens/details_page.dart';
import 'package:adoptme/screens/set_profile_page.dart';
import 'package:adoptme/services/favoriteService.dart';
import 'package:adoptme/widgets/drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> favoriteList = [];
  final user = FirebaseAuth.instance.currentUser;
  bool? profileExist;
  int selectedAnimalIconIndex = 0;
  String searchedRegion = "";
  String selectedType = "All";
  bool? isbanned;

  List<String> animalTypes = [
    'All',
    'cat',
    'dog',
    'Parrots',
    'Fish',
  ];

  List<IconData> animalIcons = [
    FontAwesomeIcons.paw,
    FontAwesomeIcons.cat,
    FontAwesomeIcons.dog,
    FontAwesomeIcons.crow,
    FontAwesomeIcons.fish,
  ];
  Widget buildAnimalIcon(int index) {
    return Padding(
      padding: EdgeInsets.only(right: 30.0),
      child: Column(
        children: <Widget>[
          InkWell(
            onTap: () {
              setState(() {
                selectedAnimalIconIndex = index;
                selectedType = animalTypes[selectedAnimalIconIndex];
              });
            },
            child: Material(
              color: selectedAnimalIconIndex == index
                  ? Theme.of(context).primaryColor
                  : Colors.white,
              elevation: 8.0,
              borderRadius: BorderRadius.circular(20.0),
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Icon(
                  animalIcons[index],
                  size: 30.0,
                  color: selectedAnimalIconIndex == index
                      ? Colors.white
                      : Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 12.0,
          ),
          Text(
            animalTypes[index],
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 16.0,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  checkIfDocExists() async {
    try {
      // Get reference to Firestore collection
      var collectionRef = FirebaseFirestore.instance.collection('UserProfile');

      var doc = await collectionRef.doc(user!.uid).get();
      if (doc.exists == true) {
        setState(() {
          profileExist = true;
        });
      } else {
        setState(() {
          profileExist = false;
        });
      }
    } catch (e) {
      rethrow;
    }
  }

  void _updateProfileExist() {
    setState(() {
      checkIfDocExists();
    });
  }

  final CollectionReference _petStrem =
      FirebaseFirestore.instance.collection('UserPost');

  @override
  void initState() {
    super.initState();
    checkIfDocExists();
  }

  @override
  Widget build(BuildContext context) {
    return profileExist == true
        ? Scaffold(
            appBar: AppBar(
              title: Text("Home"),
            ),
            drawer: DrawerPage(),
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
                                searchedRegion = value;
                                setState(() {
                                  searchedRegion = value;
                                });
                              },
                              style: TextStyle(fontSize: 18.0),
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none),
                                  hintText: 'Search pets by region'),
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
                    height: 120.0,
                    child: ListView.builder(
                      padding: EdgeInsets.only(
                        left: 24.0,
                        top: 8.0,
                      ),
                      scrollDirection: Axis.horizontal,
                      itemCount: animalTypes.length,
                      itemBuilder: (context, index) {
                        return buildAnimalIcon(index);
                      },
                    ),
                  ),
                  SizedBox(
                    height: 500,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: selectedAnimalIconIndex == 0 &&
                              searchedRegion == ""
                          ? _petStrem
                              .orderBy("createdAt", descending: true)
                              .snapshots()
                          : selectedAnimalIconIndex != 0 && searchedRegion == ""
                              ? _petStrem
                                  .where("type", isEqualTo: selectedType)
                                  .snapshots()
                              : selectedAnimalIconIndex != 0 &&
                                      searchedRegion != ""
                                  ? _petStrem
                                      .where("region",
                                          isEqualTo:
                                              searchedRegion.toLowerCase())
                                      .where("type", isEqualTo: selectedType)
                                      .snapshots()
                                  : _petStrem
                                      .where("region",
                                          isEqualTo:
                                              searchedRegion.toLowerCase())
                                      .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text('Something went wrong');
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator.adaptive();
                        }

                        return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (BuildContext context, int index) {
                            final DocumentSnapshot documentSnapshot =
                                snapshot.data!.docs[index];

                            return Padding(
                              padding: EdgeInsets.only(
                                  left: 40.0, bottom: 30.0, top: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () {
                                      Get.to(DetailPage(
                                          documentSnapshot: documentSnapshot));
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      height: 250.0,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20.0),
                                          bottomLeft: Radius.circular(20.0),
                                        ),
                                        image: DecorationImage(
                                          image: NetworkImage(
                                              documentSnapshot["image"]),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        12.0, 12.0, 40.0, 0.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          documentSnapshot["name"],
                                          style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize: 24.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        12.0, 0.0, 40.0, 12.0),
                                    child: Text(
                                      documentSnapshot["breed"],
                                      style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 16.0,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ],
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
          )
        : SetProfile();
  }
}
