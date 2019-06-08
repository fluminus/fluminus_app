import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:fluminus/widgets/theme.dart' as theme;

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

void toggleBrightness(BuildContext context) {
  if (Theme.of(context).brightness == Brightness.dark) {
    DynamicTheme.of(context).setThemeData(theme.lightTheme);
  } else {
    DynamicTheme.of(context).setThemeData(theme.darkTheme);
  }
}
