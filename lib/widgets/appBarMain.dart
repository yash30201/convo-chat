import 'package:flutter/material.dart';

Widget appBarMain(BuildContext context, String title) {
  return AppBar(
    title: Text(
      title,
      style: TextStyle(fontSize: 22, color: Colors.white),
    ),
    elevation: 0.0,
    centerTitle: false,
  );
}
