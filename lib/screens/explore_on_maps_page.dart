import 'package:adoptme/screens/petCard.dart';
import 'package:flutter/material.dart';

class ExploreOnMaps extends StatefulWidget {
  const ExploreOnMaps({super.key});

  @override
  State<ExploreOnMaps> createState() => _ExploreOnMapsState();
}

class _ExploreOnMapsState extends State<ExploreOnMaps> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Explore Pets on Maps"),
      ),
    );
  }
}
