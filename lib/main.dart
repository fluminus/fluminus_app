import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:fluminus/announcement_page.dart';
import 'package:fluminus/task_page.dart';
import 'package:fluminus/forum_page.dart';
import 'package:fluminus/file_page.dart';
import 'package:fluminus/profile_page.dart';
import 'package:fluminus/widgets/theme.dart' as theme;

/// Disabling the scroll glow.
/// Source: https://stackoverflow.com/questions/51119795/how-to-remove-scroll-glow/51119796#51119796

void main() async {
  Brightness brightness;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  brightness =
      (prefs.getBool('isDark') ?? false) ? Brightness.dark : Brightness.light;
  await DotEnv().load('.env');
  runApp(MyApp(
    brightness: brightness,
  ));
}

class MyApp extends StatelessWidget {
  final Brightness brightness;
  MyApp({this.brightness});
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
                return ScrollConfiguration(
                    behavior: MyBehavior(), child: child);
              },
              home: MyHomePage());
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

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  final _pages = [
    AnnouncementPage(),
    TaskPage(),
    ForumPage(),
    FilePage(),
    ProfilePage()
  ];

  BottomNavigationBarItem _navBarItem(
      IconData activeIcon, IconData defaultIcon, String title) {
    return BottomNavigationBarItem(
        icon: Icon(defaultIcon,
            size: 30, color: Theme.of(context).unselectedWidgetColor),
        activeIcon: Icon(
          activeIcon,
          size: 30,
          color: Theme.of(context).brightness == Brightness.light
              ? Theme.of(context).primaryColor
              : Theme.of(context).accentColor,
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.button,
        ));
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
          showSelectedLabels: false,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
          items: <BottomNavigationBarItem>[
            _navBarItem(MdiIcons.home, MdiIcons.homeOutline, 'Home'),
            _navBarItem(
                MdiIcons.calendarCheck, MdiIcons.calendarCheckOutline, 'Task'),
            _navBarItem(MdiIcons.forum, MdiIcons.forumOutline, 'Forum'),
            _navBarItem(MdiIcons.fileFind, MdiIcons.fileFindOutline, 'File'),
            _navBarItem(MdiIcons.settings, MdiIcons.settingsOutline, 'Profile'),
          ]),
      body: _pages[_currentIndex],
    );
  }
}
