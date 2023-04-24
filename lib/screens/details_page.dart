// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: prefer_const_constructors

import 'package:adoptme/theme/theme_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:adoptme/widgets/drawer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/favoriteService.dart';

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

  Widget _buildInfoCard(String label, String info) {
    return Container(
      margin: EdgeInsets.all(10.0),
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
            style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: Colors.deepPurple),
          ),
          SizedBox(height: 8.0),
          Text(
            info,
            style: TextStyle(
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
        title: Text("Pet Details"),
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
                Padding(
                  padding: EdgeInsets.only(top: 40.0, left: 10.0),
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.arrow_back_ios,
                      size: 35,
                    ),
                    color: Colors.white,
                  ),
                )
              ],
            ),
            SizedBox(height: 20.0),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    widget.documentSnapshot["name"],
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: (isfavorite(widget.documentSnapshot["docID"]) == true)
                        ? Icon(Icons.favorite)
                        : Icon(Icons.favorite_border),
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
              padding: EdgeInsets.symmetric(horizontal: 40.0),
              child: Text(
                widget.documentSnapshot["breed"],
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 16.0,
                  color: Colors.grey,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 30.0),
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
              margin: EdgeInsets.only(left: 20.0, top: 30.0),
              width: double.infinity,
              height: 90.0,
              decoration: BoxDecoration(
                color: kPrimaryLightColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  bottomLeft: Radius.circular(20.0),
                ),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(
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
                  style: TextStyle(
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
              padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 25.0),
              child: ExpandableText(
                widget.documentSnapshot["description"],
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 15.0,
                  height: 1.5,
                ),
                collapseText: 'less',
                expandText: 'more',
                linkStyle: TextStyle(fontWeight: FontWeight.w800),
                maxLines: 3,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(40.0, 0.0, 40.0, 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  // ignore: deprecated_member_use
                  Container(
                    decoration: ThemeHelper().buttonBoxDecoration(context),
                    child: ElevatedButton.icon(
                      style: ThemeHelper().buttonStyle(),
                      onPressed: () {
                        _makePhoneCall(widget.documentSnapshot["description"]);
                      },
                      icon: Icon(
                        Icons.call,
                      ),
                      label: Text(
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
                      onPressed: () {},
                      icon: FaIcon(
                        FontAwesomeIcons.whatsapp,
                      ),
                      label: Text(
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
      querySnapshot.docs.forEach((doc) {
        favorite.add(doc.id);
      });
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
