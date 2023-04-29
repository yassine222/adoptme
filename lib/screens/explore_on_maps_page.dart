// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:adoptme/widgets/botomsheet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class ExploreOnMaps extends StatefulWidget {
  const ExploreOnMaps({Key? key}) : super(key: key);

  @override
  State<ExploreOnMaps> createState() => ExploreOnMapsState();
}

class ExploreOnMapsState extends State<ExploreOnMaps> {
  Completer<GoogleMapController> _controller = Completer();

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  // ignore: unused_field
  LatLng _initialcameraposition = const LatLng(0.0, 0.0);
  late BitmapDescriptor otherIcon;
  late BitmapDescriptor dogIcon;
  late BitmapDescriptor catIcon;
  late BitmapDescriptor parrotIcon;
  late BitmapDescriptor fishIcon;

  void addOtherIcon() {
    BitmapDescriptor.fromAssetImage(
      ImageConfiguration(),
      "assets/images/other.png",
    ).then((icon) {
      setState(() {
        otherIcon = icon;
      });
    });
  }

  void addDogIcon() {
    BitmapDescriptor.fromAssetImage(
      ImageConfiguration(),
      "assets/images/dog.png",
    ).then((icon) {
      setState(() {
        dogIcon = icon;
      });
    });
  }

  void addCatIcon() {
    BitmapDescriptor.fromAssetImage(
      ImageConfiguration(),
      "assets/images/cat.png",
    ).then((icon) {
      setState(() {
        catIcon = icon;
      });
    });
  }

  void addParrotIcon() {
    BitmapDescriptor.fromAssetImage(
      ImageConfiguration(),
      "assets/images/parrot.png",
    ).then((icon) {
      setState(() {
        parrotIcon = icon;
      });
    });
  }

  void addFishIcon() {
    BitmapDescriptor.fromAssetImage(
      ImageConfiguration(),
      "assets/images/fish.png",
    ).then((icon) {
      setState(() {
        fishIcon = icon;
      });
    });
  }

  @override
  void dispose() {
    _controller;
    super.dispose();
  }

  @override
  void initState() {
    addOtherIcon();
    addCatIcon();
    addDogIcon();
    addFishIcon();
    addParrotIcon();
    _getCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Explore"),
      ),
      body: FutureBuilder<List<QueryDocumentSnapshot>>(
          future: getUserPostDocuments(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              final List<QueryDocumentSnapshot> userPostDocuments =
                  snapshot.data!;
              final List<Marker> markers = userPostDocuments.map((document) {
                final GeoPoint location = document['location'];
                final LatLng latLng =
                    LatLng(location.latitude, location.longitude);
                return Marker(
                  icon: document['type'] == "Dog"
                      ? dogIcon
                      : document['type'] == "Cat"
                          ? catIcon
                          : document['type'] == "Parrot"
                              ? parrotIcon
                              : document['type'] == "Fish"
                                  ? fishIcon
                                  : otherIcon,
                  onTap: () {
                    Get.bottomSheet(PetDetailsWidget(
                        snapshot: document,
                        lat: location.latitude,
                        lng: location.longitude,
                        imageUrl: document['image'],
                        name: document['name'],
                        breed: document['breed'],
                        description: document['description'],
                        location: "location"));
                  },
                  markerId: MarkerId(document.id),
                  position: latLng,
                  infoWindow: InfoWindow(title: document['name']),
                );
              }).toList();
              return GoogleMap(
                markers: Set<Marker>.of(markers),
                mapType: MapType.normal,
                initialCameraPosition: CameraPosition(
                    target: LatLng(34.820746, 9.460153), zoom: 7),
              );
            }
            return CircularProgressIndicator.adaptive();
          }),
    );
  }

  Future<List<QueryDocumentSnapshot>> getUserPostDocuments() async {
    final CollectionReference userPostCollection =
        FirebaseFirestore.instance.collection('UserPost');
    final QuerySnapshot userPostSnapshot = await userPostCollection.get();
    final List<QueryDocumentSnapshot> userPostDocuments = userPostSnapshot.docs;
    return userPostDocuments;
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
