import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:fluminus/announcement_page.dart';
import 'package:fluminus/task_page.dart';
import 'package:fluminus/forum_page.dart';
import 'package:fluminus/file_page.dart';
import 'package:fluminus/profile_page.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);
  final String title;
  static String tag = 'home-page';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
            _navBarItem(MdiIcons.calendar, MdiIcons.calendarOutline, 'Profile'),
          ]),
      body: _pages[_currentIndex],
    );
  }
}
