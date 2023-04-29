// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class AgeSelector extends StatefulWidget {
  final String initialAge;
  final ValueChanged<String> onAgeSelected;

  AgeSelector({this.initialAge = "18", required this.onAgeSelected});

  @override
  _AgeSelectorState createState() => _AgeSelectorState();
}

class _AgeSelectorState extends State<AgeSelector> {
  String? _currentAge;

  @override
  void initState() {
    super.initState();
    _currentAge = widget.initialAge;
  }

  List<DropdownMenuItem<String>> _buildAgeItems() {
    List<DropdownMenuItem<String>> items = [];
    for (int i = 1; i <= 20; i++) {
      items.add(
        DropdownMenuItem(
          value: i.toString(),
          child: Text('$i' + " months"),
        ),
      );
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Pet Age",
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
              value: _currentAge,
              items: _buildAgeItems(),
              onChanged: (value) {
                setState(() {
                  _currentAge = value!;
                });
                if (widget.onAgeSelected != null) {
                  widget.onAgeSelected(value!);
                }
              },
              decoration: InputDecoration(),
            ),
          ),
        ],
      ),
    );
  }
}
