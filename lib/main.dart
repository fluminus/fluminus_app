import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'module_page.dart';
import 'forum_page.dart';
import 'profile_page.dart';
import 'file_page.dart';
import 'announcement_page.dart';

/// Disabling the scroll glow.
/// Source: https://stackoverflow.com/questions/51119795/how-to-remove-scroll-glow/51119796#51119796

void main() async {
  await DotEnv().load('.env');
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    builder: (context, child) {
      return ScrollConfiguration(behavior: MyBehavior(), child: child);
    },
    theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.lightBlue[800],
        accentColor: Colors.orange,
        
        fontFamily: 'Roboto',

        textTheme: TextTheme(
          headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.normal),
          body1: TextStyle(fontSize: 14.0, fontFamily: 'Roboto'),
        ),
      ),
    home: BottomNavBar(),
  ));
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _page = 0;
  final _pageOptions = [
    AnnouncementPage(),
    ModulePage(),
    ForumPage(),
    FilePage(),
    ProfilePage()
  ];
  bool showCondition(int index) {
    return index == 2;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: CurvedNavigationBar(
          index: 0,
          height: 60.0,
          items: <Widget>[
            Icon(Icons.home, size: 30),
            Icon(Icons.alarm_on, size: 30),
            Icon(Icons.question_answer, size: 30),
            Icon(Icons.insert_drive_file, size: 30),
            Icon(Icons.perm_identity, size: 30),
          ],
          color: Theme.of(context).primaryColor,
          buttonBackgroundColor: Theme.of(context).accentColor,
          backgroundColor: Colors.white,
          animationCurve: Curves.easeInOut,
          animationDuration: Duration(milliseconds: 200),
          onTap: (index) {
            setState(() {
              _page = index;
            });
          },
        ),
        body: _pageOptions[_page]);
  }
}
