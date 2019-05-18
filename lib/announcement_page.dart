import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:luminus_api/luminus_api.dart';
import 'package:fluminus/data.dart' as data;
import 'package:fluminus/util.dart' as util;
import 'package:fluminus/widgets/card.dart' as card;

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
    return FutureBuilder<List<Module>>(
        future: API.getModules(data.authentication),
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
                    return announcementList(module, context);
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

  Widget announcementList(Module module, BuildContext context) {
    return new Container(
        decoration: new BoxDecoration(color: Colors.white),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: FutureBuilder<List<Announcement>>(
            future: API.getAnnouncements(data.authentication, module),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                announcements = snapshot.data;
                return new ListView.builder(
                  itemCount: announcements.length,
                  itemBuilder: (BuildContext context, int index) {
                    return new Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6.0),
                          child:
                              announcementCard(announcements[index], context),
                        )
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

  Widget announcementCard(Announcement announcemnt, BuildContext context) {
    String title = announcemnt.title;
    String subtitle = "Expire After: " +
        util.datetimeToFormattedString(DateTime.parse(announcemnt.expireAfter));
    String body = parsedHtmlText(announcemnt.description);
    return card.infoCardWithFullBody(title, subtitle, body, context);
    // return card.infoCardWithFixedHeight(title, subtitle, body, context);
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
