import 'package:flutter/material.dart';

const blue = const Color(0xFF5a96be);
const lightBlue = Color(0xFFbbdefb);
const darkBlue = const Color(0xFF295771);
const greyGreen = const Color(0xFFaec980);
const orangeRed = const Color(0xFFfa7a54);
const pink = const Color(0xFFeb796f);

const blueGrey = Colors.blueGrey;
const lightBlueGrey = const Color(0xFFa3b6bf);
const darkBlueGrey = const Color(0xFF3e515a);
const backgroundGrey = const Color(0xFF4d4d4d);
const lightGrey = const Color(0xFFe4e4e4);
const darkGreyGreen = const Color(0xFF78aeaa);
const greyOrange = const Color(0xFFdc8061);
const greyRed = const Color(0xFFd75c53);


List<Color> lightColors = [
  blue,
  greyGreen,
  orangeRed,
  pink
];

List<Color> darkColors = [
  blue,
  darkGreyGreen,
  greyOrange,
  greyRed
];


ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: blue,
    primaryColorLight: lightBlue,
    primaryColorDark: darkBlue,
    accentColor: greyGreen,
    unselectedWidgetColor: Colors.blueGrey,
    fontFamily: 'Roboto',
    textTheme: TextTheme(
      headline: TextStyle(fontSize: 45.0, fontWeight: FontWeight.bold),
      title: TextStyle(fontSize: 40.0, fontStyle: FontStyle.normal),
      caption: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold, color: Colors.blueGrey),
      subhead: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold,),
      subtitle: TextStyle(fontSize: 14.0, color: Colors.grey),
      body1: TextStyle(fontSize: 14.0, fontFamily: 'Roboto'),
      body2: TextStyle(fontSize: 16.0, fontFamily: 'Roboto', color: ThemeData.light().primaryColor)
    ),
    buttonTheme: ButtonThemeData(
      shape: RoundedRectangleBorder(),

    )
    );
    

ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: blueGrey,
    primaryColorLight: lightBlueGrey,
    primaryColorDark: darkBlueGrey,
    accentColor: darkGreyGreen,
    unselectedWidgetColor: Color(0xFFbababa),
    fontFamily: 'Roboto',
    textTheme: TextTheme(
      headline: TextStyle(fontSize: 45.0, fontWeight: FontWeight.bold, color: lightGrey),
      title: TextStyle(fontSize: 40.0, fontStyle: FontStyle.normal, color: lightGrey),
      caption: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold,color: lightGrey),
      subhead: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: lightBlue),
      subtitle: TextStyle(fontSize: 18.0, color: lightGrey),
      body1: TextStyle(fontSize: 14.0, color: lightGrey),
      body2: TextStyle(fontSize: 16.0, color: lightGrey)
    ));
