import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_crashlytics/flutter_crashlytics.dart';
// import 'package:luminus_api/luminus_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:fluminus/home_page.dart';
import 'package:fluminus/login_page.dart';
import 'package:fluminus/widgets/theme.dart' as theme;
import 'data.dart' as data;

// Source: https://stackoverflow.com/questions/51119795/how-to-remove-scroll-glow/51119796#51119796
// Disabling the scroll glow.
void main() async {
  Brightness brightness;
  bool hasCredentials;
  SharedPreferences prefs = await SharedPreferences.getInstance();

  brightness =
      (prefs.getBool('isDark') ?? false) ? Brightness.dark : Brightness.light;
  hasCredentials = (prefs.getBool('hasCred') ?? false);
  if (hasCredentials) {
    await data.loadData();
  }

  bool isInDebugMode = false;
  FlutterError.onError = (FlutterErrorDetails details) {
    if (isInDebugMode) {
      // In development mode simply print to console.
      FlutterError.dumpErrorToConsole(details);
    } else {
      // In production mode report to the application zone to report to
      // Crashlytics.
      Zone.current.handleUncaughtError(details.exception, details.stack);
    }
  };
  FlutterCrashlytics().initialize().then((val) {
    print('Crashlytics initialized.');
  });
  runZoned(() {
    runApp(App(
      brightness: brightness,
      hasCredentials: hasCredentials,
    ));
  }, onError: (error, stackTrace) {
    // Whenever an error occurs, call the `reportCrash` function. This will send
    // Dart errors to our dev console or Crashlytics depending on the environment.
    FlutterCrashlytics().reportCrash(error, stackTrace, forceCrash: false);
  });
}

class App extends StatelessWidget {
  final Brightness brightness;
  final bool hasCredentials;
  final routes = <String, WidgetBuilder>{
    LoginPage.tag: (context) => LoginPage(),
    HomePage.tag: (context) => HomePage(),
  };
  App({this.brightness, this.hasCredentials});
  @override
  Widget build(BuildContext context) {
    return new DynamicTheme(
        defaultBrightness: brightness,
        data: (brightness) =>
            brightness == Brightness.light ? theme.lightTheme : theme.darkTheme,
        themedWidgetBuilder: (context, theme) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: theme,
            builder: (context, child) {
              return ScrollConfiguration(behavior: MyBehavior(), child: child);
            },
            home: hasCredentials ? HomePage() : LoginPage(),
            routes: routes,
          );
        });
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
