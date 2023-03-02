// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, invalid_return_type_for_catch_error, avoid_print

import 'dart:io';

import 'package:adoptme/screens/home_page.dart';
import 'package:adoptme/screens/login_page.dart';
import 'package:adoptme/services/authService.dart';
import 'package:adoptme/theme/theme_helper.dart';
import 'package:adoptme/widgets/header_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import 'profile_page.dart';

class SetProfile extends StatefulWidget {
  const SetProfile({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SetProfileState();
  }
}

class _SetProfileState extends State<SetProfile> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController addressController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();
  bool checkedValue = false;
  bool checkboxValue = false;
  String? imageUrl;
  File? image;
  var uuid = Uuid();
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
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Set Profile"),
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Stack(
            children: [
              SizedBox(
                height: 150,
                child: HeaderWidget(150, false, Icons.person_add_alt_1_rounded),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(25, 50, 25, 10),
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          GestureDetector(
                            child: Stack(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    border: Border.all(
                                        width: 5, color: Colors.white),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 20,
                                        offset: const Offset(5, 5),
                                      ),
                                    ],
                                  ),
                                  child: FittedBox(
                                    fit: BoxFit.contain,
                                    child: CircleAvatar(
                                      radius: 50,
                                      backgroundColor: Colors.white,
                                      foregroundImage: image != null
                                          ? FileImage(
                                              image!,
                                            )
                                          : NetworkImage(
                                                  "https://cdn4.iconfinder.com/data/icons/evil-icons-user-interface/64/avatar-512.png")
                                              as ImageProvider,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    pickImage();
                                  },
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(90, 90, 0, 0),
                                    child: Icon(
                                      Icons.add_circle,
                                      color: Colors.deepPurple,
                                      size: 25.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Container(
                            decoration:
                                ThemeHelper().inputBoxDecorationShaddow(),
                            child: TextFormField(
                              controller: fullNameController,
                              decoration: ThemeHelper().textInputDecoration(
                                  'User Name',
                                  'Enter your user name',
                                  Icon(Icons.person)),
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return "Please enter your user name";
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(height: 20),
                          Container(
                            decoration:
                                ThemeHelper().inputBoxDecorationShaddow(),
                            child: TextFormField(
                              controller: mobileNumberController,
                              decoration: ThemeHelper().textInputDecoration(
                                  "Mobile Number",
                                  "Enter your mobile number",
                                  Icon(Icons.phone)),
                              keyboardType: TextInputType.phone,
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return "Please enter your mobile number";
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(height: 20.0),
                          Container(
                            decoration:
                                ThemeHelper().inputBoxDecorationShaddow(),
                            child: TextFormField(
                              controller: addressController,
                              decoration: ThemeHelper().textInputDecoration(
                                  "Address",
                                  "Enter your address",
                                  Icon(Icons.pin_drop)),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Enter your address';
                                }

                                return null;
                              },
                            ),
                          ),
                          SizedBox(height: 15.0),
                          FormField<bool>(
                            builder: (state) {
                              return Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Checkbox(
                                          value: checkboxValue,
                                          onChanged: (value) {
                                            setState(() {
                                              checkboxValue = value!;
                                              state.didChange(value);
                                            });
                                          }),
                                      Text(
                                        "I accept all terms and conditions.",
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      state.errorText ?? '',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        color: Theme.of(context).errorColor,
                                        fontSize: 12,
                                      ),
                                    ),
                                  )
                                ],
                              );
                            },
                            validator: (value) {
                              if (!checkboxValue) {
                                return 'You need to accept terms and conditions';
                              } else {
                                return null;
                              }
                            },
                          ),
                          SizedBox(height: 20.0),
                          Container(
                            decoration:
                                ThemeHelper().buttonBoxDecoration(context),
                            child: ElevatedButton(
                              style: ThemeHelper().buttonStyle(),
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(40, 10, 40, 10),
                                child: Text(
                                  "Save".toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  setProfile(user.uid)
                                      .then((value) => Get.to(HomePage()));
                                }
                              },
                            ),
                          ),
                          SizedBox(height: 25.0),
                          Container(
                            margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
                            //child: Text('Don\'t have an account? Create'),
                            child: Text.rich(TextSpan(children: [
                              TextSpan(
                                text: 'Cancel',
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    AuthService()
                                        .LogOut()
                                        .then((value) => Get.to(LoginPage()));
                                  },
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).accentColor),
                              ),
                            ])),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
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
        print(value);
      });

      setState(() {
        this.image = imageTemp;
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future<void> setProfile(
    String uid,
  ) async {
    // Call the user's CollectionReference to add a new user
    return await users.doc(uid).set({
      'fullname': fullNameController.text,
      'email': user.email,
      'phone': mobileNumberController.text,
      'image': imageUrl ??
          "https://cdn4.iconfinder.com/data/icons/evil-icons-user-interface/64/avatar-512.png",
      'adresse': addressController.text,
      'isbanned': false,
      'strike': 0,
    }).then((value) async {
      print("profile updated");
    }).catchError((error) => print("Failed to add user: $error"));
  }
}
