// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:adoptme/screens/details_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

class PetDetailsWidget extends StatelessWidget {
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
                imageUrl,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(breed),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () => MapsLauncher.launchCoordinates(
                    lat,
                    lng,
                  ),
                  icon: const Icon(Icons.directions),
                  color: Colors.deepPurple,
                ),
                IconButton(
                  onPressed: () {
                    Get.to(() => DetailPage(documentSnapshot: snapshot));
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
}
