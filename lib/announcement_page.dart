import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:luminus_api/luminus_api.dart';
import 'data.dart' as Data;

class AnnouncementPage extends StatefulWidget {
  const AnnouncementPage({Key key}) : super(key: key);
  @override
  _AnnouncementPageState createState() => new _AnnouncementPageState();
}

class _AnnouncementPageState extends State<AnnouncementPage>
    with SingleTickerProviderStateMixin {
  List<Module> _modules;
  @override
  Widget build(BuildContext context) {
    print(_modules);
    return FutureBuilder<List<Module>>(
        future: API.getModules(Data.authentication),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _modules = snapshot.data;
            return DefaultTabController(
              length: _modules.length,
              child: Scaffold(
                appBar: AppBar(
                  title: const Text("Announcemnts"),
                  bottom: TabBar(
                    isScrollable: true,
                    tabs: _modules.map((Module module) {
                      return Tab(
                        text: module.name,
                      );
                    }).toList(),
                  ),
                ),
                body: TabBarView(
                  children: _modules.map((Module module) {
                    return announcementList(module);
                  }).toList(),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return Scaffold(
            appBar: AppBar(title: const Text("Announcemnts")),
            body: Center(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: CircularProgressIndicator(),
                  ),
                ],
              ),
            ),
          );
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
            subtitle: Text("Expire After: " +
                announcemnt.expireAfter +
                '\n' +
                '\n' +
                parsedHtmlText(announcemnt.description)),
          ),
        ],
      ),
    );
  }
}

List<Tab> getModuleTitlesAsTextTabs(List<Module> modules) {
  List<Tab> textWidgets = new List();
  for (Module mod in modules) {
    textWidgets.add(new Tab(text: mod.courseName));
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
