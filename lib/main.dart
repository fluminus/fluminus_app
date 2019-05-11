import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'module_page.dart';
import 'profile_page.dart';
import 'file_page.dart';
import 'third_page.dart';

/// Disabling the scroll glow.
/// Source: https://stackoverflow.com/questions/51119795/how-to-remove-scroll-glow/51119796#51119796
class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

class SecondRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Route test"),
      ),
    );
  }
}

void main() async {
  await DotEnv().load('.env');
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
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
    FilePage(),
    ModulePage(),
    ProfilePage()
  ];
  bool showFloatingActionButton = true;
  bool showCondition(int index) {
    return index == 2;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   title: Text(_page.toString()),
        // ),
        floatingActionButton: showFloatingActionButton
            ? FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return SecondRoute();
                  }));
                },
              )
            : Container(),
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
              if (showCondition(index))
                showFloatingActionButton = true;
              else
                showFloatingActionButton = false;
            });
          },
        ),
        body: _pageOptions[_page]);
  }
}
