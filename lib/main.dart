import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'module_page.dart';
import 'profile_page.dart';
import 'file_page.dart';
import 'third_page.dart';

import 'luminus_api/download_response.dart';

import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

/// Disabling the scroll glow.
/// Source: https://stackoverflow.com/questions/51119795/how-to-remove-scroll-glow/51119796#51119796
class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

class SecondRoute extends StatefulWidget {
  @override
  _SecondRouteState createState() => _SecondRouteState();
}

class _SecondRouteState extends State<SecondRoute> {
  String _openResult = 'Unknown';

  Future<void> openFile() async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    final filePath = dir + '/dummy.pdf';
    final message = await OpenFile.open(filePath);
    setState(() {
      _openResult = message;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Text('Plugin example app'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('open result: $_openResult\n'),
            FlatButton(
              child: Text('Tap to open file'),
              onPressed: openFile,
            ),
          ],
        ),
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
                    downloadFile(
                        "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf",
                        "dummy.pdf");
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
