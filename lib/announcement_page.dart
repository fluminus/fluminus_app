import 'package:fluminus/announcement_list_page.dart';
import 'package:flutter/material.dart';
import 'package:luminus_api/luminus_api.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:fluminus/data.dart' as data;
import 'package:fluminus/util.dart' as util;
import 'package:fluminus/widgets/common.dart' as common;
import 'package:fluminus/widgets/list.dart' as list;

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
                      return AnnouncementListPage(module:module);
                    }).toList(),
                  ),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return common.processIndicator;
        });
  }
}
