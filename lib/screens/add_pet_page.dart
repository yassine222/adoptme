// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:adoptme/main.dart';
import 'package:adoptme/screens/home_page.dart';
import 'package:adoptme/theme/theme_helper.dart';
import 'package:adoptme/widgets/ageSelector_page.dart';
import 'package:adoptme/widgets/inputField.dart';
import 'package:adoptme/widgets/petTypeSelector.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../widgets/regionSelector.dart';

class AddPetPage extends StatefulWidget {
  @override
  _AddPetPageState createState() => _AddPetPageState();
}

class _AddPetPageState extends State<AddPetPage> {
  final TextEditingController petNameController = TextEditingController();
  final TextEditingController petBreedController = TextEditingController();
  final picker = ImagePicker();
  var uuid = Uuid();
  final _formKey = GlobalKey<FormState>();
  File? image;
  // Owner Infos

  String? _ownerImage;
  String? _ownerName;
  String? _ownerID;
  String? _ownerPhone;
  String? _ownerAdress;
  // Pet Infos
  String? _imageUrl;
  String? _petType;
  String? _petBreed;
  String? _petAge;
  String? _petGender;
  String _petDescription = '';
  String? _petRegion;
  Timestamp _createdAt = Timestamp.now();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserPostData(user!.uid);
    _petGender = 'male';
    _petAge = "1";
    _petRegion = "Tunis";
    _petType = "Dog";
  }

  @override
  void dispose() {
    petNameController.dispose();
    petBreedController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Add Pet'),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      height: 300.0,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: image != null
                              ? FileImage(
                                  image!,
                                )
                              : AssetImage('assets/images/place_holder2.webp')
                                  as ImageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 5,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: IconButton(
                          onPressed: () => pickImage(),
                          icon: Icon(
                            Icons.add_a_photo_outlined,
                            size: 30,
                          ),
                          color: Colors.deepPurple,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Column(
                      children: [
                        PetCategorie(
                          type: ['Dog', 'Cat', 'Parrots', 'Fish', "Other"],
                          initialType: "Dog",
                          onTypeSelected: (type) {
                            setState(() {
                              _petType = type;
                            });
                          },
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: InputField(
                                controller: petNameController,
                                title: "Pet Name",
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return "this field is required";
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: InputField(
                                controller: petBreedController,
                                title: "Pet Breed",
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return "this field is required";
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: AgeSelector(
                                initialAge: "1",
                                onAgeSelected: (age) {
                                  setState(() {
                                    _petAge = age;
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: RegionSelector(
                                regions: ['Tunis', 'Sfax', 'Sousse', 'Bizerte'],
                                initialRegion: 'Tunis',
                                onRegionSelected: (region) {
                                  setState(() {
                                    _petRegion = region;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Pet Description",
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.deepPurple),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 8.0),
                                padding: const EdgeInsets.only(left: 14),
                                height: 100,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.deepPurple,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(10)),
                                child: TextField(
                                  decoration: InputDecoration(),
                                  keyboardType: TextInputType.multiline,
                                  maxLines: 5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Pet Gender",
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.deepPurple),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Radio(
                                    value: 'male',
                                    groupValue: _petGender,
                                    onChanged: (value) {
                                      setState(() {
                                        _petGender = value!;
                                      });
                                    },
                                  ),
                                  Text('Male'),
                                  Radio(
                                    value: 'female',
                                    groupValue: _petGender,
                                    onChanged: (value) {
                                      setState(() {
                                        _petGender = value!;
                                      });
                                    },
                                  ),
                                  Text('Female'),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Center(
                                child: Container(
                                  decoration: ThemeHelper()
                                      .buttonBoxDecoration(context),
                                  child: ElevatedButton(
                                    style: ThemeHelper().buttonStyle(),
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          40, 10, 40, 10),
                                      child: Text(
                                        "Post".toUpperCase(),
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        if (_imageUrl == null) {
                                          Get.snackbar("Required",
                                              "Upload your pet image",
                                              icon: const Icon(
                                                Icons.warning_amber_rounded,
                                              ),
                                              backgroundColor: Colors.white,
                                              snackPosition:
                                                  SnackPosition.BOTTOM);
                                        } else {
                                          addUserPost(user!.uid).then(
                                              (value) => Get.to(HomePage()));
                                        }
                                      }
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future pickImage() async {
    try {
      final image = await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 20);

      if (image == null) return;
      final imageTemp = File(image.path);
      Reference ref = FirebaseStorage.instance.ref().child(uuid.v1());
      await ref.putFile(imageTemp);
      ref.getDownloadURL().then((value) {
        setState(() {
          _imageUrl = value;
        });
        print(value);
      });

      setState(() {
        this.image = imageTemp;
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future<void> addUserPost(String userId) async {
    // Generate a new document ID
    final newDocRef = FirebaseFirestore.instance.collection('UserPost').doc();
    final newDocId = newDocRef.id;

    // Create the new document with the ID
    await newDocRef.set({
      'owner': _ownerName,
      'name': petNameController.text.trim(),
      'breed': petBreedController.text.trim(),
      'image': _imageUrl,
      'description': _petDescription,
      'sex': _petGender,
      'age': _petAge.toString(),
      'color': "color",
      'id': userId,
      'adress': _ownerAdress,
      'ownerImage': _ownerImage,
      'type': _petType!.toLowerCase().capitalizeFirst,
      'docID': newDocId,
      'phone': _ownerPhone,
      "region": _petRegion,
      'isactive': true,
      'createdAt': _createdAt,
      'isadopted': false,
    });
  }

  getUserPostData(String userID) async {
    final postRef =
        FirebaseFirestore.instance.collection('UserProfile').doc(userID);
    final postDoc = await postRef.get();

    if (postDoc.exists) {
      final data = postDoc.data();
      setState(() {
        _ownerImage = data!['image'];
        _ownerName = data['fullname'];
        _ownerAdress = data["adresse"];
        _ownerPhone = data['phone'];
      });
    } else {
      throw Exception('Post with ID $userID does not exist.');
    }
  }
}
