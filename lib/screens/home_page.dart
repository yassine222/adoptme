import 'package:adoptme/screens/banned_page.dart';
import 'package:adoptme/screens/details_page.dart';
import 'package:adoptme/widgets/drawer.dart';
import 'package:adoptme/widgets/loadingwidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
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
      padding: const EdgeInsets.only(right: 30.0),
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
                padding: const EdgeInsets.all(20.0),
                child: Icon(
                  animalIcons[index],
                  size: 20.0,
                  color: selectedAnimalIconIndex == index
                      ? Colors.white
                      : Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
          const SizedBox(
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

  final CollectionReference _petStrem =
      FirebaseFirestore.instance.collection('UserPost');

  Stream<bool> isUserBanned(String userId) {
    // Get the reference to the user's document in the UserProfile collection
    final userProfileRef =
        FirebaseFirestore.instance.collection('UserProfile').doc(userId);

    // Create a stream of snapshots of the user's document
    return userProfileRef.snapshots().map((snapshot) {
      // Check if the snapshot contains any data
      if (!snapshot.exists) {
        // If the document does not exist, assume the user is not banned
        return false;
      }

      // Get the value of the isBanned field from the snapshot
      final isBanned = snapshot['isbanned'];

      // Return the value of the isBanned field
      return isBanned;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
        stream: isUserBanned(user!.uid),
        builder: (context, snapshot) {
          if (snapshot.data == true) {
            return const BannedPage();
          } else {
            return Scaffold(
              appBar: AppBar(
                title: const Text("Home"),
              ),
              drawer: const DrawerPage(),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24.0,
                        vertical: 10.0,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.0)),
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Row(
                          children: [
                            const Icon(
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
                                style: const TextStyle(fontSize: 18.0),
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none),
                                    hintText: 'Search pets by region'),
                              ),
                            ),
                            const Icon(
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
                        padding: const EdgeInsets.only(
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
                                .where("isadopted", isEqualTo: false)
                                .where("isApproved", isEqualTo: "yes")
                                .orderBy("createdAt", descending: true)
                                .snapshots()
                            : selectedAnimalIconIndex != 0 &&
                                    searchedRegion == ""
                                ? _petStrem
                                    .where("type", isEqualTo: selectedType)
                                    .where("isadopted", isEqualTo: false)
                                    .where("isApproved", isEqualTo: "yes")
                                    .orderBy("createdAt", descending: true)
                                    .snapshots()
                                : selectedAnimalIconIndex != 0 &&
                                        searchedRegion != ""
                                    ? _petStrem
                                        .where("region",
                                            isEqualTo: searchedRegion)
                                        .where("type", isEqualTo: selectedType)
                                        .where("isadopted", isEqualTo: false)
                                        .where("isApproved", isEqualTo: "yes")
                                        .orderBy("createdAt", descending: true)
                                        .snapshots()
                                    : _petStrem
                                        .where("region",
                                            isEqualTo: searchedRegion)
                                        .where("isadopted")
                                        .where("isApproved", isEqualTo: "yes")
                                        .orderBy("createdAt", descending: true)
                                        .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            if (kDebugMode) {
                              print(snapshot.error.toString());
                            }
                            return const Text('Something went wrong');
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Loading2();
                          }

                          return ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (BuildContext context, int index) {
                              final DocumentSnapshot documentSnapshot =
                                  snapshot.data!.docs[index];

                              return Padding(
                                padding: const EdgeInsets.only(
                                    left: 40.0, bottom: 30.0, top: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: () {
                                        Get.to(() => DetailPage(
                                            documentSnapshot:
                                                documentSnapshot));
                                      },
                                      child: Container(
                                        width: double.infinity,
                                        height: 250.0,
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.only(
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
                                      padding: const EdgeInsets.fromLTRB(
                                          12.0, 12.0, 40.0, 0.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            documentSnapshot["name"],
                                            style: const TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontSize: 24.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          documentSnapshot["isApproved"] ==
                                                      "waiting" &&
                                                  documentSnapshot["id"] ==
                                                      user!.uid
                                              ? TextButton.icon(
                                                  label: const Text("Pending "),
                                                  onPressed: () {
                                                    Get.snackbar("Pending",
                                                        "Please wait for admin approval of your post. Thank you.",
                                                        icon: const Icon(
                                                          Icons
                                                              .warning_amber_rounded,
                                                        ),
                                                        backgroundColor:
                                                            Colors.white,
                                                        snackPosition:
                                                            SnackPosition
                                                                .BOTTOM);
                                                  },
                                                  icon: const Icon(
                                                    Icons.error,
                                                    size: 35,
                                                  ),
                                                )
                                              : const SizedBox(),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          12.0, 0.0, 40.0, 12.0),
                                      child: Text(
                                        documentSnapshot["breed"],
                                        style: const TextStyle(
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
            );
          }
        });
  }
}
