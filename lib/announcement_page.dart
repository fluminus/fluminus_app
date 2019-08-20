import 'dart:convert';

import 'package:fluminus/widgets/list.dart';
import 'package:flutter/material.dart';
import 'package:luminus_api/luminus_api.dart';
import 'package:fluminus/announcement_list_page.dart';
import 'package:fluminus/data.dart' as data;
import 'util.dart' as util;
import 'widgets/common.dart' as common;

class AnnouncementPage extends StatefulWidget {
  const AnnouncementPage({Key key}) : super(key: key);
  @override
  _AnnouncementPageState createState() => new _AnnouncementPageState();
}

class _AnnouncementPageState extends State<AnnouncementPage> {
  final String appBarTitle = "Announcements";
  final List<String> tabBarNames = new List()
    ..addAll(data.modules.map((m) => m.name))
    ..add('Archived')
    ..add('All');

  @override
  void initState() {
    super.initState();
  }

  void dispose() {
    _write();
    super.dispose();
  }

  ValueNotifier<List<Announcement>> _archived =
      ValueNotifier<List<Announcement>>(data.archivedAnnouncements);

  sortAnnouncements(List<Announcement> announcements) {
    announcements.sort((a, b) =>
        DateTime.parse(b.createdDate).compareTo(DateTime.parse(a.createdDate)));
  }

  @override
  Widget build(BuildContext context) {
    if (data.modules == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(appBarTitle),
        ),
      );
    } else {
      return DefaultTabController(
          length: tabBarNames.length,
          child: Scaffold(
              body: NestedScrollView(
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                    return <Widget>[
                      SliverAppBar(
                        title: Text(appBarTitle),
                        pinned: true,
                        floating: true,
                        snap: true,
                        forceElevated: innerBoxIsScrolled,
                        bottom: TabBar(
                          isScrollable: true,
                          tabs: tabBarNames.map((tabName) {
                            return Tab(
                              text: tabName,
                            );
                          }).toList(),
                        ),
                      )
                    ];
                  },
                  body: TabBarView(
                      children: new List()
                        ..addAll(data.modules.map((Module module) {
                          return AnnouncementListPage(module: module);
                        }).toList())
                        ..add(ValueListenableBuilder(
                          builder: (BuildContext context,
                              List<Announcement> value, Widget child) {
                            return dismissibleListView(
                                value, () => CardType.announcementCardType,
                                (index) {
                              setState(() {
                                Announcement removedOne = value.removeAt(index);
                                Scaffold.of(context).showSnackBar(SnackBar(
                                    content: Text("Announcement deleted"),
                                    action: SnackBarAction(
                                        label: "UNDO",
                                        onPressed: () {
                                          setState(() {
                                            data.archivedAnnouncements
                                                .remove(removedOne);
                                            value.insert(index, removedOne);
                                          });
                                        })));
                              });
                            }, (index, context) {
                              Announcement announcement = value[index];
                              util.showPickerThreeNumber(
                                  context,
                                  data.modules.firstWhere(
                                      (m) => m.id == announcement.parentID),
                                  announcement);
                            }, context, Icon(Icons.schedule),
                                Icon(Icons.delete), null);
                          },
                          valueListenable: _archived,
                        ))
                        ..add(FutureBuilder<List<Announcement>>(
                          future:
                              API.getActiveAnnouncements(data.authentication()),
                          builder: (context, snapshot) {
                            List<Announcement> allAnnouncements;
                            if (snapshot.hasData) {
                              allAnnouncements = snapshot.data;
                              data.sp.setString('lastRefreshedDateStr',
                                  DateTime.now().toString());
                              return refreshableListView(() async {
                                List<Announcement> _newAnnouncements =
                                    await util.refreshWithSnackBars(
                                        () => API.getActiveAnnouncements(
                                            data.authentication()),
                                        context);
                                sortAnnouncements(_newAnnouncements);
                                String lastRefreshedDateStr =
                                    data.sp.getString('lastRefreshedDateStr');
                                DateTime lastRefreshedDate;
                                lastRefreshedDateStr == null
                                    ? lastRefreshedDate = DateTime.now()
                                    : lastRefreshedDate =
                                        DateTime.parse(lastRefreshedDateStr);
                                _newAnnouncements =
                                    _newAnnouncements.takeWhile((x) {
                                  return (DateTime.parse(x.createdDate).isAfter(
                                      lastRefreshedDate ?? DateTime.now()));
                                }).toList();
                                setState(() {
                                  data.sp.setString('lastRefreshedDateStr',
                                      DateTime.now().toString());
                                  allAnnouncements.addAll(_newAnnouncements);
                                });
                              },
                                  allAnnouncements,
                                  () => CardType.announcementCardType,
                                  context,
                                null, isSeparated: true);
                            } else if (snapshot.hasError) {
                              return Text(snapshot.error.toString());
                            }
                            return common.progressIndicator;
                          },
                        ))))));
    }
  }

  _write() async {
    List<Map> maps = new List();
    for (Announcement announcement in data.archivedAnnouncements) {
      maps.add(announcement.toJson());
    }
    String encodedList = json.encode(maps);
    data.sp.setString('archivedAnnouncements', encodedList);
  }
}
