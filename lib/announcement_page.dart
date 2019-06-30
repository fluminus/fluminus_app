import 'dart:convert';

import 'package:fluminus/widgets/list.dart';
import 'package:flutter/material.dart';
import 'package:luminus_api/luminus_api.dart';
import 'package:fluminus/announcement_list_page.dart';
import 'package:fluminus/data.dart' as data;

class AnnouncementPage extends StatefulWidget {
  const AnnouncementPage({Key key}) : super(key: key);
  @override
  _AnnouncementPageState createState() => new _AnnouncementPageState();
}

class _AnnouncementPageState extends State<AnnouncementPage>
    with
        SingleTickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<AnnouncementPage> {
  final String appBarTitle = "Announcements";
  final List<String> tabBarNames = new List()
    ..addAll(data.modules.map((m) => m.name))
    ..add('Archived');

  @override
  void initState() {
    super.initState();
  }

  void dispose() {
    _write();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
          appBar: AppBar(
            title: Text(appBarTitle),
            bottom: TabBar(
              isScrollable: true,
              tabs: tabBarNames.map((tabName) {
                return Tab(
                  text: tabName,
                );
              }).toList(),
            ),
          ),
          body: TabBarView(
              children: new List()
                ..addAll(data.modules.map((Module module) {
                  return AnnouncementListPage(module: module);
                }).toList())
                ..add(dismissibleListView(
                    data.archivedAnnouncements,
                    () => CardType.announcementCardType,
                    () {},
                    () {},
                    context,
                    null))),
        ),
      );
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
  @override
  bool get wantKeepAlive => true;
}
