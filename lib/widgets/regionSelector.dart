// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class RegionSelector extends StatefulWidget {
  final List<String> regions;
  final String initialRegion;
  final ValueChanged<String> onRegionSelected;

  RegionSelector({
    required this.regions,
    required this.initialRegion,
    required this.onRegionSelected,
  });

  @override
  _RegionSelectorState createState() => _RegionSelectorState();
}

class _RegionSelectorState extends State<RegionSelector> {
  String? _currentRegion;

  @override
  void initState() {
    super.initState();
    _currentRegion = widget.initialRegion;
  }

  List<DropdownMenuItem<String>> _buildRegionItems() {
    List<DropdownMenuItem<String>> items = [];
    for (String region in widget.regions) {
      items.add(
        DropdownMenuItem(
          value: region,
          child: Text(region),
        ),
      );
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            "Region",
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
                if (widget.onRegionSelected != null) {
                  widget.onRegionSelected(value!);
                }
              },
              decoration: InputDecoration(),
            ),
          )
        ]));
  }
}
