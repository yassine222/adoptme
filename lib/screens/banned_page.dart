import 'package:flutter/material.dart';

class BannedPage extends StatelessWidget {
  const BannedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: 60,
        height: 100,
        child: Text("You are banned!x"),
      ),
    );
  }
}
