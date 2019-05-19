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

    Widget refreshableList(Module module) {
      void updateAMList(List<Announcement> refreshedAnnouncements) {
        setState(() {
          _announcements = refreshedAnnouncements;
        });
      }
      Future<void> onRefresh() async {
        _refreshedAnnouncements = await util.onLoading(
            _refreshController,
            _announcements,
            () => API.getAnnouncements(data.authentication, module));

        if (_refreshedAnnouncements == null) {
          _refreshController.refreshFailed();
        } else {
          updateAMList(_refreshedAnnouncements);
          _refreshController.refreshCompleted();
        }
      }

      return FutureBuilder<List<Announcement>>(
        future: API.getAnnouncements(data.authentication, module),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.active:
              return Align(
                  alignment: Alignment.center, child: common.processIndicator);
              break;
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                if (_announcements == null) {
                  _announcements = snapshot.data;
                }
                return list.refreshableListView(
                    module,
                    _refreshController,
                    () => onRefresh(),
                    (module, context) => announcementList(module, context));
              }
              break;
          }
        },
      );
    }

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
          return common.processIndicator;
        });
  }

  Widget announcementList(Module module, BuildContext context) {
    return FutureBuilder<List<Announcement>>(
            future: API.getAnnouncements(data.authentication, module),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                _announcements = snapshot.data;
                return list.itemListView(_announcements, context);
              } else if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }
              return common.processIndicator;
            },
          );
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