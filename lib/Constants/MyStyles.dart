import 'package:flutter/material.dart';

class My {
  static const TextStyle textSmall =
      TextStyle(color: Colors.black, fontSize: 12);
  static const TextStyle textMidSmall =
      TextStyle(color: Colors.black, fontSize: 16);
  static const TextStyle textMedium =
      TextStyle(color: Colors.black, fontSize: 20);
  static const TextStyle textLarge =
      TextStyle(color: Colors.black, fontSize: 30);
}

InputDecoration textFieldInputDecoration(String hintText, IconData icon) {
  return InputDecoration(
      hintText: hintText,
      prefixIcon: Icon(
        icon,
      ),
      hintStyle: TextStyle(color: Colors.grey),
      focusedBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
      enabledBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)));
}
