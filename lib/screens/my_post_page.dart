import 'package:adoptme/screens/editPost.dart';
import 'package:adoptme/screens/petcard.dart';
import 'package:adoptme/widgets/loadingwidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class MyPostsPage extends StatefulWidget {
  const MyPostsPage({super.key});

  @override
  State<MyPostsPage> createState() => _MyPostsPageState();
}

class _MyPostsPageState extends State<MyPostsPage> {
  String petName = "";
  final CollectionReference _myPetStrem =
      FirebaseFirestore.instance.collection('UserPost');
  final User? user = FirebaseAuth.instance.currentUser;

  bool isPressed1 = true;
  bool isPressed2 = false;
  @override
  void initState() {
    isPressed1 = true;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Posts"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
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
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 20.0,
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
                          petName = value;
                          setState(() {
                            petName = value;
                          });
                        },
                        style: const TextStyle(fontSize: 18.0),
                        decoration: const InputDecoration(
                            border:
                                OutlineInputBorder(borderSide: BorderSide.none),
                            hintText: 'Search your pets by name'),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      isPressed2 = false;
                      isPressed1 = true;
                    });
                  },
                  style: TextButton.styleFrom(
                    backgroundColor:
                        isPressed1 ? Colors.deepPurple : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 20.0),
                  ),
                  child: Text(
                    "Active",
                    style: TextStyle(
                      color: isPressed1 ? Colors.white : Colors.deepPurple,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      isPressed2 = true;
                      isPressed1 = false;
                    });
                  },
                  style: TextButton.styleFrom(
                    backgroundColor:
                        isPressed2 ? Colors.deepPurple : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 20.0),
                  ),
                  child: Text(
                    "Adopted",
                    style: TextStyle(
                      color: isPressed2 ? Colors.white : Colors.deepPurple,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 600,
              child: StreamBuilder<QuerySnapshot>(
                stream: petName == "" && isPressed1
                    ? _myPetStrem
                        .where("id", isEqualTo: user!.uid)
                        .where("isadopted", isEqualTo: false)
                        .orderBy("createdAt", descending: true)
                        .snapshots()
                    : isPressed2 && petName == ""
                        ? _myPetStrem
                            .where("id", isEqualTo: user!.uid)
                            .where("isadopted", isEqualTo: true)
                            .orderBy("createdAt", descending: true)
                            .snapshots()
                        : petName != "" && isPressed1
                            ? _myPetStrem
                                .where("id", isEqualTo: user!.uid)
                                .where("name", isEqualTo: petName)
                                .where("isadopted", isEqualTo: false)
                                .orderBy("createdAt", descending: true)
                                .snapshots()
                            : _myPetStrem
                                .where("id", isEqualTo: user!.uid)
                                .where("isadopted", isEqualTo: true)
                                .where("name", isEqualTo: petName)
                                .orderBy("createdAt", descending: true)
                                .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    if (kDebugMode) {
                      print(snapshot.error.toString());
                    }
                    return Text(snapshot.error.toString());
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Loading2();
                  }

                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      final DocumentSnapshot documentSnapshot =
                          snapshot.data!.docs[index];

                      return PetCard(
                          documentSnapshot: documentSnapshot,
                          isAdopted: documentSnapshot["isadopted"],
                          imageUrl: documentSnapshot["image"],
                          name: documentSnapshot["name"],
                          breed: documentSnapshot["breed"],
                          postStaus: documentSnapshot["isApproved"],
                          isActive: documentSnapshot["isactive"],
                          activate: () {
                            if (documentSnapshot["isactive"] == false) {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Activate Post'),
                                  content: const Text('Reactivate Your Post ?'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('No'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        activatePost(documentSnapshot.id).then(
                                            (value) => Navigator.pop(context));
                                      },
                                      child: const Text('Yes'),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                          diactivate: () {
                            if (documentSnapshot["isactive"] == true) {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Diactivate Post'),
                                  content: const Text(
                                      'is your Pet adopted through AdopteMe OR diactivate for other reasons ?'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        diactivatePost(documentSnapshot.id)
                                            .then((value) =>
                                                Navigator.pop(context));
                                      },
                                      child: const Text('No (Other Reason)'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        diactivatePost(documentSnapshot.id);
                                        isadopted(documentSnapshot.id).then(
                                            (value) => Navigator.pop(context));
                                      },
                                      child: const Text('Yes (AdopteMe)'),
                                    ),
                                  ],
                                ),
                              );
                            } else {}
                          },
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
      if (kDebugMode) {
        print('Post deleted successfully');
      }
    } catch (error) {
      if (kDebugMode) {
        print('Failed to delete post: $error');
      }
    }
  }

  Future<void> isadopted(String postId) {
    return FirebaseFirestore.instance
        .collection('UserPost')
        .doc(postId)
        .update({'isadopted': true});
  }

  Future<void> diactivatePost(String postId) {
    return FirebaseFirestore.instance
        .collection('UserPost')
        .doc(postId)
        .update({'isactive': false});
  }

  Future<void> activatePost(String postId) {
    return FirebaseFirestore.instance
        .collection('UserPost')
        .doc(postId)
        .update({'isactive': true});
  }
}
