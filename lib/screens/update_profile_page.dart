import 'dart:io';

import 'package:adoptme/theme/theme_helper.dart';
import 'package:adoptme/widgets/header_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({super.key});

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController addressController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();
  String? username;
  String? phone;
  String? newImage;
  String? adress;
  bool checkedValue = false;
  bool checkboxValue = false;
  String? imageUrl;
  File? image;
  var uuid = const Uuid();
  final user = FirebaseAuth.instance.currentUser!;

  @override
  void dispose() {
    fullNameController.dispose();
    mobileNumberController.dispose();
    addressController.dispose();

    super.dispose();
  }

  CollectionReference users =
      FirebaseFirestore.instance.collection('UserProfile');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            const SizedBox(
              height: 150,
              child: HeaderWidget(
                  150, false, AssetImage("assets/images/logo.png")),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(25, 50, 25, 10),
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              alignment: Alignment.center,
              child: Column(
                children: [
                  FutureBuilder<DocumentSnapshot>(
                      future: users.doc(user.uid).get(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return const Text("Something went wrong");
                        }

                        if (snapshot.hasData && !snapshot.data!.exists) {
                          return const Text("Document does not exist");
                        }
                        if (snapshot.connectionState == ConnectionState.done) {
                          Map<String, dynamic> data =
                              snapshot.data!.data() as Map<String, dynamic>;
                          return Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                GestureDetector(
                                  child: Stack(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          border: Border.all(
                                              width: 5, color: Colors.white),
                                          color: Colors.white,
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Colors.black12,
                                              blurRadius: 20,
                                              offset: Offset(5, 5),
                                            ),
                                          ],
                                        ),
                                        child: FittedBox(
                                          fit: BoxFit.contain,
                                          child: CircleAvatar(
                                            radius: 50,
                                            foregroundColor: Colors.white,
                                            backgroundColor: Colors.white,
                                            foregroundImage: image != null
                                                ? FileImage(
                                                    image!,
                                                  )
                                                : NetworkImage(
                                                        '${data['image']}')
                                                    as ImageProvider,
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          pickImage();
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.fromLTRB(
                                              90, 90, 0, 0),
                                          child: const Icon(
                                            Icons.add_circle,
                                            color: Colors.deepPurple,
                                            size: 25.0,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                Container(
                                  decoration:
                                      ThemeHelper().inputBoxDecorationShaddow(),
                                  child: TextFormField(
                                    initialValue: '${data['fullname']}',
                                    onChanged: (value) {
                                      username = value;
                                    },
                                    decoration:
                                        ThemeHelper().textInputDecoration(
                                      'User Name',
                                      'Enter your user name',
                                      GestureDetector(
                                        child: const Icon(Icons.person),
                                      ),
                                    ),
                                    validator: (val) {
                                      if (val!.isEmpty) {
                                        return "Please enter your user name";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Container(
                                  decoration:
                                      ThemeHelper().inputBoxDecorationShaddow(),
                                  child: TextFormField(
                                    maxLength: 8,
                                    initialValue: '${data['phone']}',
                                    onChanged: (value) {
                                      phone = value;
                                    },
                                    decoration:
                                        ThemeHelper().textInputDecoration(
                                      "Mobile Number",
                                      "Enter your mobile number",
                                      GestureDetector(
                                        child: const Icon(Icons.phone),
                                      ),
                                    ),
                                    keyboardType: TextInputType.phone,
                                  ),
                                ),
                                const SizedBox(height: 20.0),
                                Container(
                                  decoration:
                                      ThemeHelper().inputBoxDecorationShaddow(),
                                  child: TextFormField(
                                    initialValue: '${data['adresse']}',
                                    onChanged: (value) {
                                      adress = value;
                                    },
                                    decoration:
                                        ThemeHelper().textInputDecoration(
                                      "Address",
                                      "Enter your address",
                                      GestureDetector(
                                          child: const Icon(Icons.pin_drop)),
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Enter your address';
                                      }

                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(height: 15.0),
                                const SizedBox(height: 20.0),
                                Container(
                                  decoration: ThemeHelper()
                                      .buttonBoxDecoration(context),
                                  child: ElevatedButton(
                                    style: ThemeHelper().buttonStyle(),
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          40, 10, 40, 10),
                                      child: Text(
                                        "Save".toUpperCase(),
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      updateProfile(
                                              user.uid,
                                              '${data['fullname']}',
                                              '${data['phone']}',
                                              '${data['image']}',
                                              '${data['adresse']}')
                                          .then((value) {
                                        Get.snackbar("Success",
                                            "Profile updated successfully",
                                            icon: const Icon(
                                              Icons.check_circle_outlined,
                                            ),
                                            backgroundColor: Colors.white,
                                            snackPosition:
                                                SnackPosition.BOTTOM);
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        return const CircularProgressIndicator();
                      }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future pickImage() async {
    try {
      final image = await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 1);

      if (image == null) return;
      final imageTemp = File(image.path);
      Reference ref = FirebaseStorage.instance.ref().child(uuid.v1());
      await ref.putFile(imageTemp);
      ref.getDownloadURL().then((value) {
        setState(() {
          imageUrl = value;
        });
        if (kDebugMode) {
          print(value);
        }
      });

      setState(() {
        this.image = imageTemp;
      });
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('Failed to pick image: $e');
      }
    }
  }

  Future<void> updateProfile(String uid, String curentUserName,
      String curentPhone, String curentPhoto, String curentAdress) async {
    // Call the user's CollectionReference to add a new user
    return await users.doc(uid).update({
      'fullname': username ?? curentUserName,
      'phone': phone ?? curentPhone,
      'image': imageUrl ?? curentPhoto,
      'adresse': adress ?? curentAdress
    }).then((value) async {
      if (kDebugMode) {
        print("profile updated");
      }
      // ignore: avoid_print
    });
  }
}
