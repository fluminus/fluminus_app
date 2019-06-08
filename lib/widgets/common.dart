import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget progressIndicator = Center(
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

void toggleBrightness(BuildContext context){
  if (Theme.of(context).brightness == Brightness.dark) {
    DynamicTheme.of(context).setThemeData(ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.lightBlue[800],
        unselectedWidgetColor: Colors.blueGrey,
        accentColor: Colors.orange,
        fontFamily: 'Roboto',
        textTheme: TextTheme(
          headline: TextStyle(fontSize: 45.0, fontWeight: FontWeight.bold),
          title: TextStyle(fontSize: 40.0, fontStyle: FontStyle.normal),
          caption: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
          subhead: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
          subtitle: TextStyle(fontSize: 14.0, color: Colors.grey),
          body1: TextStyle(fontSize: 14.0, fontFamily: 'Roboto'),
        )));
  } else {
    DynamicTheme.of(context).setThemeData(ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.black,
        unselectedWidgetColor: Colors.white,
        accentColor: Colors.orange,
        fontFamily: 'Roboto',
        textTheme: TextTheme(
          headline: TextStyle(fontSize: 45.0, fontWeight: FontWeight.bold),
          title: TextStyle(fontSize: 40.0, fontStyle: FontStyle.normal),
          caption: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
          subhead: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
          subtitle: TextStyle(fontSize: 14.0, color: Colors.grey),
          body1: TextStyle(fontSize: 14.0, fontFamily: 'Roboto'),
        )));
  }
}
