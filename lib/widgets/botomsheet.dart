// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:adoptme/screens/details_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

class PetDetailsWidget extends StatefulWidget {
  final String imageUrl;
  final String name;
  final String breed;
  final String description;
  final String location;
  final QueryDocumentSnapshot<Object?> snapshot;
  final double lat;
  final double lng;

  const PetDetailsWidget({
    Key? key,
    required this.imageUrl,
    required this.name,
    required this.breed,
    required this.description,
    required this.location,
    required this.snapshot,
    required this.lat,
    required this.lng,
  }) : super(key: key);

  static Future<void> openMap(GeoPoint coerdinates) async {
    String latitude = coerdinates.latitude.toString();
    String longitude = coerdinates.longitude.toString();
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      if (longitude == "0.0" && latitude == "0.0") {
        Get.snackbar("Error", "Cant get direction for goolge Maps ",
            icon: const Icon(
              Icons.warning_amber_rounded,
            ),
            backgroundColor: Colors.white,
            snackPosition: SnackPosition.BOTTOM);
      } else {
        await launch(googleUrl);
      }
    } else {
      throw 'Could not open the map.';
    }
  }

  @override
  State<PetDetailsWidget> createState() => _PetDetailsWidgetState();
}

class _PetDetailsWidgetState extends State<PetDetailsWidget> {
  LatLng _initialcameraposition = const LatLng(0.0, 0.0);
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Image.network(
                widget.imageUrl,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(widget.breed),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () =>
                      PetDetailsWidget.openMap(widget.snapshot["location"]),
                  icon: const Icon(Icons.directions),
                  color: Colors.deepPurple,
                ),
                IconButton(
                  onPressed: () {
                    Get.to(() => DetailPage(documentSnapshot: widget.snapshot));
                  },
                  icon: const Icon(Icons.visibility),
                  color: Colors.blue,
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.bookmark),
                  color: Colors.green,
                ),
              ],
            ),
          ],
        ),
      ),
    );
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
