// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:adoptme/main.dart';
import 'package:adoptme/screens/home_page.dart';
import 'package:adoptme/theme/theme_helper.dart';
import 'package:adoptme/widgets/ageselectorpage.dart';
import 'package:adoptme/widgets/inputField.dart';
import 'package:adoptme/widgets/pettypeselector.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../widgets/regionselector.dart';

class EditPost extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;

  const EditPost({super.key, required this.documentSnapshot});
  @override
  _EditPostState createState() => _EditPostState();
}

class _EditPostState extends State<EditPost> {
  final TextEditingController petNameController = TextEditingController();
  final TextEditingController petBreedController = TextEditingController();
  final picker = ImagePicker();
  var uuid = Uuid();
  final _formKey = GlobalKey<FormState>();
  File? image;
  // Owner Infos

  // Pet Infos
  String? _imageUrl;
  String? _petType;
  String? _petBreed;
  String? _petAge;
  String? _petGender;
  String? _petDescription;
  String? _petRegion;
  String? _petName;

  Timestamp _updatedAt = Timestamp.now();

  String? currentSex;
  String? currentImage;
  String? currentAge;
  String? currentName;
  String? currentDescription;
  String? currentType;
  String? currentBreed;
  String? currentRegion;
  GeoPoint? curentPostPosition;

  @override
  void initState() {
    _getCurrentLocation();
    _petGender = widget.documentSnapshot["sex"];
    currentSex = widget.documentSnapshot["sex"];
    _imageUrl = widget.documentSnapshot["image"];
    currentImage = widget.documentSnapshot["image"];
    _petAge = widget.documentSnapshot["age"];
    currentAge = widget.documentSnapshot["age"];
    _petName = widget.documentSnapshot["name"];
    currentName = widget.documentSnapshot["name"];
    _petBreed = widget.documentSnapshot["breed"];
    currentBreed = widget.documentSnapshot["breed"];
    _petType = widget.documentSnapshot["type"];
    currentType = widget.documentSnapshot["type"];
    _petDescription = widget.documentSnapshot["description"];
    currentDescription = widget.documentSnapshot["description"];
    _petRegion = widget.documentSnapshot["region"];
    currentRegion = widget.documentSnapshot["region"];
    curentPostPosition = widget.documentSnapshot["location"];

    super.initState();
  }

  @override
  void dispose() {
    petNameController.dispose();
    petBreedController.dispose();
    super.dispose();
  }

  LatLng _initialcameraposition = const LatLng(0.0, 0.0);
  LatLng _lastPosition = const LatLng(0.0, 0.0);

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
          title: Text('Edit Post'),
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
                              : NetworkImage(widget.documentSnapshot["image"])
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
                          initialType: widget.documentSnapshot["type"],
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
                                onChanged: (value) {
                                  _petName = value;
                                },
                                initialValue: widget.documentSnapshot["name"],
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
                                onChanged: (value) {
                                  _petBreed = value;
                                },
                                initialValue: widget.documentSnapshot["breed"],
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
                                initialAge: widget.documentSnapshot["age"],
                                onAgeSelected: (age) {
                                  setState(() {
                                    _petAge = age.toString();
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
                                initialRegion:
                                    widget.documentSnapshot["region"],
                                onRegionSelected: (region) {
                                  setState(() {
                                    _petRegion = region;
                                  });
                                },
                              ),
                            ),
                            Column(
                              children: [
                                const SizedBox(
                                  height: 50,
                                ),
                                IconButton(
                                  onPressed: () {
                                    Get.bottomSheet(
                                        Card(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadiusDirectional
                                                      .circular(
                                                40,
                                              ),
                                            ),
                                            child: GestureDetector(
                                              child: GoogleMap(
                                                markers: {
                                                  Marker(
                                                      draggable: true,
                                                      onDrag: (value) {
                                                        setState(() {
                                                          _initialcameraposition =
                                                              value;
                                                        });
                                                      },
                                                      markerId: const MarkerId(
                                                          "myPosition"),
                                                      position: LatLng(
                                                          curentPostPosition!
                                                              .latitude,
                                                          curentPostPosition!
                                                              .longitude))
                                                },
                                                mapType: MapType.normal,
                                                onCameraMove:
                                                    (CameraPosition position) {
                                                  _lastPosition =
                                                      position.target;
                                                },
                                                initialCameraPosition:
                                                    CameraPosition(
                                                        target: LatLng(
                                                            curentPostPosition!
                                                                .latitude,
                                                            curentPostPosition!
                                                                .longitude),
                                                        zoom: 16),
                                              ),
                                            ),
                                          ),
                                        ),
                                        enableDrag: false);
                                  },
                                  icon: const Icon(Icons.location_on,
                                      color: Colors.deepPurple),
                                ),
                              ],
                            )
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
                                child: TextFormField(
                                  onChanged: (value) {
                                    _petDescription = value;
                                  },
                                  initialValue:
                                      widget.documentSnapshot["description"],
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
                                          updatePost(
                                            widget.documentSnapshot.id,
                                          ).then((value) {
                                            Get.snackbar("Success",
                                                "Post updated successfully",
                                                icon: const Icon(
                                                  Icons.check_circle_outlined,
                                                ),
                                                backgroundColor: Colors.white,
                                                snackPosition:
                                                    SnackPosition.BOTTOM);
                                          });
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
        debugPrint(value);
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

  Future<void> updatePost(
    String postId,
  ) async {
    // Generate a new document ID
    final postToEdit =
        FirebaseFirestore.instance.collection('UserPost').doc(postId);

    // Create the new document with the ID
    await postToEdit.update({
      'name': _petName,
      'breed': _petBreed,
      'image': _imageUrl,
      'description': _petDescription,
      'sex': _petGender,
      'age': _petAge.toString(),
      'type': _petType!.toLowerCase().capitalizeFirst,
      "region": _petRegion!.toLowerCase().capitalizeFirst,
      "isApproved": currentName != _petName ||
              currentAge != _petAge ||
              currentBreed != _petBreed ||
              currentDescription != _petDescription ||
              currentImage != _imageUrl ||
              currentSex != _petGender ||
              currentRegion != _petRegion ||
              currentType != _petType
          ? "waiting"
          : "yes",
      'location': GeoPoint(
          _initialcameraposition.latitude, _initialcameraposition.longitude),
    });
  }

  void _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error("Location services are disabled");
    }

    if (permission == LocationPermission.denied) {
      return Future.error("Location permissions denied");
    }
    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _initialcameraposition = LatLng(position.latitude, position.longitude);
    });
    if (kDebugMode) {
      print(_initialcameraposition);
    }
  }
}
