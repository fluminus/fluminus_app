import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'module_page.dart';
import 'profile_page.dart';
import 'third_page.dart';

/**
 * Disabling the scroll glow.
 * Source: https://stackoverflow.com/questions/51119795/how-to-remove-scroll-glow/51119796#51119796
 */
class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

void main() async {
  await DotEnv().load('.env');
  runApp(MaterialApp(
    builder: (context, child) {
      return ScrollConfiguration(behavior: MyBehavior(), child: child);
    },
    home: BottomNavBar(),
  ));
}

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _page = 0;
  final _pageOptions = [
    Third(),
    ModulePage(),
    ModulePage(),
    ModulePage(),
    ProfilePage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: CurvedNavigationBar(
          index: 0,
          height: 60.0,
          items: <Widget>[
            Icon(Icons.add, size: 30),
            Icon(Icons.list, size: 30),
            Icon(Icons.compare_arrows, size: 30),
            Icon(Icons.call_split, size: 30),
            Icon(Icons.perm_identity, size: 30),
          ],
          color: Colors.greenAccent,
          buttonBackgroundColor: Colors.lightBlueAccent,
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
