import 'dart:math';

import 'package:adoptme/theme/theme_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import 'package:url_launcher/url_launcher.dart';

import '../services/favoriteservice.dart';

class DetailPage extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;

  const DetailPage({
    Key? key,
    required this.documentSnapshot,
  }) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool hasCallSupport = false;
  Future<void>? launched;
  String phone = '';
  static const kPrimaryLightColor = Color(0xFFF1E6FF);
  List<String> favoriteList = [];
  final user = FirebaseAuth.instance.currentUser;

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

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

  Future<void> launchWhatsapp(
      {required String phone, String message = ""}) async {
    String launchurl = "whatsapp://send?phone=+216$phone&text=$message";
    await canLaunch(launchurl)
        ? await launch(launchurl)
        : print('Could not launch app');
  }

  Widget _buildInfoCard(String label, String info) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      width: 100.0,
      decoration: BoxDecoration(
        color: kPrimaryLightColor,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            label,
            style: const TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: Colors.deepPurple),
          ),
          const SizedBox(height: 8.0),
          Text(
            info,
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                openMap(widget.documentSnapshot["location"]);
              },
              icon: const Icon(Icons.directions))
        ],
        title: const Text("Pet Details"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: 350.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        widget.documentSnapshot["image"],
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    widget.documentSnapshot["name"],
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: (isfavorite(widget.documentSnapshot["docID"]) == true)
                        ? const Icon(Icons.favorite)
                        : const Icon(Icons.favorite_border),
                    iconSize: 30.0,
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      if (isfavorite(widget.documentSnapshot["docID"]) ==
                          false) {
                        FavoriteService().setfavorite(
                          widget.documentSnapshot["image"],
                          widget.documentSnapshot["name"],
                          widget.documentSnapshot["breed"],
                          widget.documentSnapshot["description"],
                          widget.documentSnapshot["id"],
                          widget.documentSnapshot["owner"],
                          widget.documentSnapshot["sex"],
                          widget.documentSnapshot["color"],
                          widget.documentSnapshot["age"],
                          widget.documentSnapshot["adress"],
                          widget.documentSnapshot["ownerImage"],
                          widget.documentSnapshot["type"],
                          widget.documentSnapshot["createdAt"],
                          widget.documentSnapshot["phone"],
                          widget.documentSnapshot["docID"],
                        );
                      } else {
                        FavoriteService()
                            .infavorite(widget.documentSnapshot["docID"]);
                      }
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Text(
                widget.documentSnapshot["breed"],
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 16.0,
                  color: Colors.grey,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 30.0),
              height: 120.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _buildInfoCard(
                    'Age',
                    widget.documentSnapshot["age"],
                  ),
                  _buildInfoCard(
                    'Sex',
                    widget.documentSnapshot["sex"],
                  ),
                  _buildInfoCard(
                    'Color',
                    widget.documentSnapshot["color"],
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20.0, top: 30.0),
              width: double.infinity,
              height: 90.0,
              decoration: const BoxDecoration(
                color: kPrimaryLightColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  bottomLeft: Radius.circular(20.0),
                ),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 8.0,
                ),
                leading: CircleAvatar(
                  child: ClipOval(
                    child: Image(
                      height: 40.0,
                      width: 40.0,
                      image: NetworkImage(
                        widget.documentSnapshot["ownerImage"],
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                title: Text(
                  widget.documentSnapshot["owner"],
                  style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
                subtitle: Text(
                  'Owner',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontFamily: 'Montserrat',
                  ),
                ),
                trailing: Text(
                  widget.documentSnapshot["adress"],
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontFamily: 'Montserrat',
                      fontSize: 13),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 40.0, vertical: 25.0),
              child: ExpandableText(
                widget.documentSnapshot["description"],
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 15.0,
                  height: 1.5,
                ),
                collapseText: 'less',
                expandText: 'more',
                linkStyle: const TextStyle(fontWeight: FontWeight.w800),
                maxLines: 3,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(40.0, 0.0, 40.0, 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  // ignore: deprecated_member_use
                  Container(
                    decoration: ThemeHelper().buttonBoxDecoration(context),
                    child: ElevatedButton.icon(
                      style: ThemeHelper().buttonStyle(),
                      onPressed: () {
                        _makePhoneCall(widget.documentSnapshot["phone"]);
                      },
                      icon: const Icon(
                        Icons.call,
                      ),
                      label: const Text(
                        'Call',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 20.0,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  ),

                  // ignore: deprecated_member_use
                  Container(
                    decoration: ThemeHelper().buttonBoxDecoration(context),
                    child: ElevatedButton.icon(
                      style: ThemeHelper().buttonStyle(),
                      onPressed: () {
                        launchWhatsapp(phone: widget.documentSnapshot["phone"]);
                      },
                      icon: const FaIcon(
                        FontAwesomeIcons.whatsapp,
                      ),
                      label: const Text(
                        'Message',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 20.0,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool isfavorite(String id) {
    List<String> favorite = [];
    FirebaseFirestore.instance
        .collection('UserProfile')
        .doc(user!.uid)
        .collection('Favorite')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        favorite.add(doc.id);
      }
      favoriteList = favorite;
      if (mounted) {
        setState(() {
          favoriteList = favorite;
        });
      }
    });
    if (favoriteList.contains(id)) {
      return true;
    } else {
      return false;
    }
  }
}
