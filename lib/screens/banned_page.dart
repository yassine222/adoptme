// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class BannedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('You are banned'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.block,
              size: 50.0,
              color: Colors.red,
            ),
            SizedBox(height: 20.0),
            Text(
              'Sorry, you have been banned from using this app.',
              style: TextStyle(fontSize: 20.0),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10.0),
            Text(
              "miss using the app",
              style: TextStyle(fontSize: 16.0),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
