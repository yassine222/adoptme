// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class PetCategorie extends StatefulWidget {
  final List<String> type;
  final String initialType;
  final ValueChanged<String> onTypeSelected;

  PetCategorie({
    required this.type,
    required this.initialType,
    required this.onTypeSelected,
  });

  @override
  _PetCategorieState createState() => _PetCategorieState();
}

class _PetCategorieState extends State<PetCategorie> {
  String? _currentRegion;

  @override
  void initState() {
    super.initState();
    _currentRegion = widget.initialType;
  }

  List<DropdownMenuItem<String>> _buildRegionItems() {
    List<DropdownMenuItem<String>> types = [];
    for (String type in widget.type) {
      types.add(
        DropdownMenuItem(
          value: type,
          child: Text(type),
        ),
      );
    }
    return types;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            "Pet Categorie",
            style: const TextStyle(fontSize: 16, color: Colors.deepPurple),
          ),
          Container(
            margin: const EdgeInsets.only(top: 8.0),
            padding: const EdgeInsets.only(left: 14),
            height: 50,
            decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.deepPurple,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(10)),
            child: DropdownButtonFormField(
              value: _currentRegion,
              items: _buildRegionItems(),
              onChanged: (value) {
                setState(() {
                  _currentRegion = value;
                });
                if (widget.onTypeSelected != null) {
                  widget.onTypeSelected(value!);
                }
              },
              decoration: InputDecoration(),
            ),
          )
        ]));
  }
}
