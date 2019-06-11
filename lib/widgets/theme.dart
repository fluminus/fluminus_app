import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.lightBlue[800],
    unselectedWidgetColor: Colors.blueGrey,
    accentColor: Colors.orange,
    fontFamily: 'Roboto',
    textTheme: TextTheme(
      headline: TextStyle(fontSize: 45.0, fontWeight: FontWeight.bold),
      title: TextStyle(fontSize: 40.0, fontStyle: FontStyle.normal),
      caption: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold, color: Colors.blueGrey),
      subhead: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
      subtitle: TextStyle(fontSize: 14.0, color: Colors.grey),
      body1: TextStyle(fontSize: 14.0, fontFamily: 'Roboto'),
      body2: TextStyle(fontSize: 16.0, fontFamily: 'Roboto', color: ThemeData.light().primaryColor)
    ));

ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.black,
    unselectedWidgetColor: Colors.white,
    accentColor: Colors.orange,
    fontFamily: 'Roboto',
    textTheme: TextTheme(
      headline: TextStyle(fontSize: 45.0, fontWeight: FontWeight.bold),
      title: TextStyle(fontSize: 40.0, fontStyle: FontStyle.normal),
      caption: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold, color: Colors.black),
      subhead: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
      subtitle: TextStyle(fontSize: 14.0, color: Colors.grey),
      body1: TextStyle(fontSize: 14.0, fontFamily: 'Roboto'),
      body2: TextStyle(fontSize: 16.0, fontFamily: 'Roboto', color: ThemeData.dark().primaryColor)
    ));
