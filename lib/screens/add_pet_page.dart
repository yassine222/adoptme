import 'dart:io';

import 'package:adoptme/main.dart';
import 'package:adoptme/screens/home2.dart';
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

class AddPetPage extends StatefulWidget {
  const AddPetPage({super.key});

  @override
  State<AddPetPage> createState() => _AddPetPageState();
}

class _AddPetPageState extends State<AddPetPage> {
  final TextEditingController petNameController = TextEditingController();
  final TextEditingController petBreedController = TextEditingController();
  final picker = ImagePicker();
  var uuid = const Uuid();
  final _formKey = GlobalKey<FormState>();
  File? image;
  // Owner Infos
// ignore: prefer_final_fields
  LatLng _initialcameraposition = const LatLng(0.0, 0.0);
  LatLng _lastPosition = const LatLng(0.0, 0.0);
  final Set<Marker> _markers = {};
  String? _ownerImage;
  String? _ownerName;
  String? _ownerPhone;
  String? _ownerAdress;
  // Pet Infos
  String? _imageUrl;
  String? _petType;
  String? _petAge;
  String? _petGender;
  final String _petDescription = '';
  String? _petRegion;
  final Timestamp _createdAt = Timestamp.now();
  @override
  void initState() {
    _getCurrentLocation();
    getUserPostData(user!.uid);
    _petGender = 'male';
    _petAge = "1";
    _petRegion = "Tunis";
    _petType = "Dog";
    super.initState();
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
          title: const Text('Add Pet'),
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
                              : const AssetImage(
                                      'assets/images/place_holder2.webp')
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
                          icon: const Icon(
                            Icons.add_a_photo_outlined,
                            size: 30,
                          ),
                          color: Colors.deepPurple,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Column(
                      children: [
                        PetCategorie(
                          type: const [
                            'Dog',
                            'Cat',
                            'Parrots',
                            'Fish',
                            "Other"
                          ],
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
                            const SizedBox(
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
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: RegionSelector(
                                regions: const [
                                  'Tunis',
                                  'Sfax',
                                  'Sousse',
                                  'Bizerte'
                                ],
                                initialRegion: 'Tunis',
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
                                                onLongPress: _addMarker,
                                                markers: {
                                                  Marker(
                                                      draggable: true,
                                                      onDrag: (value) {
                                                        _initialcameraposition =
                                                            value;
                                                      },
                                                      markerId: const MarkerId(
                                                          "myPosition"),
                                                      position:
                                                          _initialcameraposition)
                                                },
                                                mapType: MapType.normal,
                                                onCameraMove:
                                                    (CameraPosition position) {
                                                  _lastPosition =
                                                      position.target;
                                                },
                                                initialCameraPosition:
                                                    CameraPosition(
                                                        target:
                                                            _initialcameraposition,
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
                              const Text(
                                "Pet Description",
                                style: TextStyle(
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
                                child: const TextField(
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
                              const Text(
                                "Pet Gender",
                                style: TextStyle(
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
                                  const Text('Male'),
                                  Radio(
                                    value: 'female',
                                    groupValue: _petGender,
                                    onChanged: (value) {
                                      setState(() {
                                        _petGender = value!;
                                      });
                                    },
                                  ),
                                  const Text('Female'),
                                ],
                              ),
                              const SizedBox(
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
                                        style: const TextStyle(
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
                                          addUserPost(user!.uid).then((value) =>
                                              Get.to(() => const Home2()));
                                        }
                                      }
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(
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
      "isApproved": "waiting",
      'isactive': true,
      'createdAt': _createdAt,
      'isadopted': false,
      'location': GeoPoint(
          _initialcameraposition.latitude, _initialcameraposition.longitude)
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

  void _addMarker(LatLng point) {
    setState(() {
      _markers.clear();
      _markers.add(Marker(
        markerId: MarkerId(_lastPosition.toString()),
        position: point,
      ));
      _lastPosition = point;
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
    print(_initialcameraposition);
  }
}
