import 'package:flutter/material.dart';

Widget processIndicator = Center(
  child: Column(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.all(30.0),
        child: CircularProgressIndicator(),
      ),
    ],
  ),
);