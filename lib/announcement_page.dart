import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:luminus_api/luminus_api.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
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
  List<Announcement> _announcements;
  List<Announcement> _refreshedAnnouncements;

  RefreshController _refreshController;

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Module>>(
        future: API.getModules(data.authentication),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _modules = snapshot.data;
            return MaterialApp(
              home: DefaultTabController(
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
                      return refreshableList(module);
                    }).toList(),
                  ),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return Center(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: CircularProgressIndicator(),
                ),
              ],
            ),
          );
        });
  }
  
Widget refreshableList(Module module) {
      
      void updateAnnouncementList(List<Announcement> refreshedAnnouncements) {
      setState(() {
        _announcements = refreshedAnnouncements;
      });
    }

    Future<void> _onRefresh() async {
      _refreshedAnnouncements = await util.onLoading(
          _refreshController,
          _announcements,
          () => API.getAnnouncements(data.authentication, module));
      if (_refreshedAnnouncements == null) {
        _refreshController.refreshFailed();
      } else {
        updateAnnouncementList(_refreshedAnnouncements);
        _refreshController.refreshCompleted();
      }
    }

      return SmartRefresher(
          enablePullDown: true,
          enablePullUp: true,
          controller: _refreshController,
          onRefresh: _onRefresh,
          child: ListView.builder(
              itemCount: 1,
              itemBuilder: (context, index) {
                return FutureBuilder<List<Announcement>>(
                  future: API.getAnnouncements(data.authentication, module),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                      case ConnectionState.active:
                        return Align(
                            alignment: Alignment.center,
                            child: data.processIndicator);
                        break;
                      case ConnectionState.done:
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          if (_announcements == null) {
                            _announcements = snapshot.data;
                          }
                          return announcementList(module, context);
                        }
                        break;
                    }
                  },
                );
              }));
    }
  

  Widget announcementList(Module module, BuildContext context) {
    return new Container(
        decoration: new BoxDecoration(color: Colors.white),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: FutureBuilder<List<Announcement>>(
            future: API.getAnnouncements(data.authentication, module),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                _announcements = snapshot.data;
                return new ListView.builder(
                  shrinkWrap: true,
                  itemCount: _announcements.length,
                  itemBuilder: (BuildContext context, int index) {
                    return new Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6.0),
                          child:
                              announcementCard(_announcements[index], context),
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
