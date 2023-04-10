// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';

class MyButton extends StatefulWidget {
  final String text;
  final bool isPressed;

  const MyButton({Key? key, required this.text, required this.isPressed})
      : super(key: key);

  @override
  _MyButtonState createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        setState(() {
          _isPressed = !_isPressed;
        });
      },
      child: Text(
        widget.text,
        style: TextStyle(
          color: _isPressed ? Colors.white : Colors.deepPurple,
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: TextButton.styleFrom(
        backgroundColor: _isPressed ? Colors.deepPurple : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
      ),
    );
  }
}
