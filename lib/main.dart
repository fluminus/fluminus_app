import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:fluminus/home_page.dart';
import 'package:fluminus/login_page.dart';
import 'package:fluminus/widgets/theme.dart' as theme;

/// Disabling the scroll glow.
/// Source: https://stackoverflow.com/questions/51119795/how-to-remove-scroll-glow/51119796#51119796

void main() async {
  Brightness brightness;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  brightness =
      (prefs.getBool('isDark') ?? false) ? Brightness.dark : Brightness.light;
  await DotEnv().load('.env');
  runApp(App(
    brightness: brightness,
  ));
}

class App extends StatelessWidget {
  final Brightness brightness;
  final routes = <String, WidgetBuilder>{
    LoginPage.tag: (context) => LoginPage(),
    HomePage.tag: (context) => HomePage(),
  };
  App({this.brightness});
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
            home: LoginPage(),
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
