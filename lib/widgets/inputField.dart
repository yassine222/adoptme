// ignore_for_file: file_names

import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final int? maxlength;
  final TextInputType? inputType;
  final String title;
  final String? hint;
  final TextEditingController? controller;
  final Widget? widget;
  final String? initialValue;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  const InputField({
    super.key,
    required this.title,
    this.hint,
    this.controller,
    this.inputType,
    this.maxlength,
    this.initialValue,
    this.widget,
    this.validator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
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
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    onChanged: onChanged,
                    validator: validator,
                    initialValue: initialValue,
                    maxLength: maxlength,
                    keyboardType: inputType,
                    readOnly: widget == null ? false : true,
                    decoration: InputDecoration(
                      hintText: hint,
                    ),
                    controller: controller,
                    autofocus: false,
                    cursorColor: Colors.deepPurple,
                  ),
                ),
                widget == null
                    ? Container()
                    : Container(
                        child: widget,
                      )
              ],
            ),
          )
        ],
      ),
    );
  }
}
