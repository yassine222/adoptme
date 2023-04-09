// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:adoptme/screens/set_profile_page.dart';
import 'package:adoptme/widgets/drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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

  List<String> animalTypes = ['All', 'Cat', 'Dog', 'Parrots', 'Fish', "Other"];

  List<IconData> animalIcons = [
    FontAwesomeIcons.paw,
    FontAwesomeIcons.cat,
    FontAwesomeIcons.dog,
    FontAwesomeIcons.crow,
    FontAwesomeIcons.fish,
    FontAwesomeIcons.paw,
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
    return Scaffold();
  }
}
