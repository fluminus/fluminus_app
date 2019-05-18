import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:luminus_api/luminus_api.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'data.dart' as Data;

class AnnouncementPage extends StatefulWidget {
  @override
  _AnnouncementPageState createState() => new _AnnouncementPageState();
}

class _AnnouncementPageState extends State<AnnouncementPage> {
  int _choice = 0;
  List<Module> _modules;
  @override
  Widget build(BuildContext context) {
    print(_modules);
    return FutureBuilder<List<Module>>(
        future: API.getModules(Data.authentication),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _modules = snapshot.data;
            return MaterialApp(
              home: Scaffold(
                  bottomNavigationBar: CurvedNavigationBar(
                    index: 0,
                    height: 30.0,
                    items: getModuleTitlesAsTextWidgets(_modules),
                    color: Theme.of(context).accentColor,
                    buttonBackgroundColor: Theme.of(context).primaryColor,
                    backgroundColor: Colors.white,
                    animationCurve: Curves.easeInOut,
                    animationDuration: Duration(milliseconds: 200),
                    onTap: (index) {
                      setState(() {
                        _choice = index;
                      });
                    },
                  ),
                  body: announcementList(_modules[_choice])),
            );
          } else {
            return Text(snapshot.error.toString());
          }
        });
  }

  List<Announcement> announcements;

  Widget announcementList(Module module) {
    return new Container(
        decoration: new BoxDecoration(color: Colors.white),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: FutureBuilder<List<Announcement>>(
            future: API.getAnnouncements(Data.authentication, module),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                announcements = snapshot.data;
                return new ListView.builder(
                  itemCount: announcements.length,
                  itemBuilder: (BuildContext context, int index) {
                    return new Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        announcementCard(announcements[index])
                      ],
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }
              return Center(
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
            },
          ),
        ));
  }

  Widget announcementCard(Announcement announcemnt) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: Text(announcemnt.title),
            subtitle: Text("Expire After: " + announcemnt.expireAfter + '\n' + '\n' + parsedHtmlText(announcemnt.description)),
          ),
        ],
      ),
    );
  }
}

List<Widget> getModuleTitlesAsTextWidgets(List<Module> modules) {
  List<Widget> textWidgets = new List();
  for (Module mod in modules) {
    textWidgets.add(new Text(mod.courseName));
  }
  return textWidgets;
}

class ChoiceCard extends StatelessWidget {
  const ChoiceCard({Key key, this.module}) : super(key: key);

  final Module module;

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = Theme.of(context).textTheme.body1;
    return Card(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(module.courseName, style: textStyle),
          ],
        ),
      ),
    );
  }
}

String parsedHtmlText(String htmlText) {
  var document = parse(htmlText);
  return parse(document.body.text).documentElement.text;
}

/*String formatedDate(DateTime expireDate) {
    return new DateFormat("EEE, dd MMM, yyyy").format(expireDate);
}
*/

/*DateTime selectedDate = DateTime.now();

Future<Null> _selectDate() async {
    final DateTime pickedDate = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(2018, 1, 1),
        lastDate: new DateTime(2019, 12, 31));
    if (pickedDate != null) setState(() => selectedDate = pickedDate);
  }
}*/
