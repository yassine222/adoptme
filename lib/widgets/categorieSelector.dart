// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:atomsbox/atomsbox.dart';
import 'package:flutter/material.dart';

class CategorySelector extends StatefulWidget {
  final List<String> categories;
  final String initialCategorie;
  final ValueChanged<String> onCategorieSelected;

  CategorySelector({
    Key? key,
    required this.categories,
    required this.initialCategorie,
    required this.onCategorieSelected,
  }) : super(key: key);

  @override
  _CategorySelectorState createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.categories.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              setState(() {});
            },
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.sm),
              child: Text(
                widget.categories[index],
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color:
                      _selectedIndex == index ? Colors.black : Colors.grey[500],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
