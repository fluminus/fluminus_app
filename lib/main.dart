import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluminus/announcement_page.dart';
// import 'package:fluminus/home_page.dart';
import 'package:fluminus/module_page.dart';
import 'package:fluminus/forum_page.dart';
import 'package:fluminus/file_page.dart';
import 'package:fluminus/profile_page.dart';

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
          headline: TextStyle(fontSize: 45.0, fontWeight: FontWeight.bold),
          title: TextStyle(fontSize: 40.0, fontStyle: FontStyle.normal),
          caption: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
          subhead: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
          subtitle: TextStyle(fontSize: 14.0, color: Colors.grey),
          body1: TextStyle(fontSize: 14.0, fontFamily: 'Roboto'),
        ),
      ),
      home: BottomNavBar()));
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
  int _currentIndex = 0;
  final _pages = [
    AnnouncementPage(),
    ModulePage(),
    ForumPage(),
    FilePage(),
    ProfilePage()
  ];

  BottomNavigationBarItem _navBarItem(IconData icon, String title) {
    return BottomNavigationBarItem(
        icon: Icon(
          icon,
          size: 30,
          color: Theme.of(context).primaryColor,
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
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
          items: <BottomNavigationBarItem>[
            _navBarItem(Icons.home, 'Home'),
            _navBarItem(Icons.alarm_on, 'Task'),
            _navBarItem(Icons.question_answer, 'Forum'),
            _navBarItem(Icons.insert_drive_file, 'File'),
            _navBarItem(Icons.perm_identity, 'Profile'),
          ]),
      body: _pages[_currentIndex],
    );
  }
}
