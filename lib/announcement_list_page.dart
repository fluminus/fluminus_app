import 'package:flutter/material.dart';
import 'package:luminus_api/luminus_api.dart';
import 'dart:convert';
import 'package:fluminus/widgets/common.dart' as common;
import 'package:fluminus/widgets/list.dart' as list;
import 'util.dart' as util;
import 'data.dart' as data;

class AnnouncementListPage extends StatefulWidget {
  const AnnouncementListPage({Key key, this.module}) : super(key: key);
  final Module module;

  @override
  _AnnouncementListPageState createState() => new _AnnouncementListPageState();
}

class _AnnouncementListPageState extends State<AnnouncementListPage> {
  List<Announcement> _announcements;
  List<Announcement> _newAnnouncements;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _write();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget announcementList(List<dynamic> announcements) {
      return list.refreshableAndDismissibleListView(
          onRefresh: () async {
            _newAnnouncements = await util.refreshWithSnackBars(
                () =>
                    API.getAnnouncements(data.authentication(), widget.module),
                context);
            sortAnnouncements(_newAnnouncements);
            String lastRefreshedDateStr =
                data.sp.getString(widget.module.name + 'lastRefreshedDateStr');
            DateTime lastRefreshedDate;
            lastRefreshedDateStr == null
                ? lastRefreshedDate = DateTime.now()
                : lastRefreshedDate = DateTime.parse(lastRefreshedDateStr);
            _newAnnouncements = _newAnnouncements.takeWhile((x) {
              return (DateTime.parse(x.createdDate)
                  .isAfter(lastRefreshedDate ?? DateTime.now()));
            }).toList();
            setState(() {
              data.sp.setString(widget.module.name + 'lastRefreshedDateStr',
                  DateTime.now().toString());
              announcements.addAll(_newAnnouncements);
            });
          },
          itemList: announcements,
          getCardType: () => list.CardType.announcementCardType,
          afterSwipingLeft: (index) {
            setState(() {
              Announcement removedOne = announcements.removeAt(index);
              data.archivedAnnouncements.add(removedOne);
              Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text("Announcement archived"),
                  action: SnackBarAction(
                      label: "UNDO",
                      onPressed: () {
                        setState(() {
                          data.archivedAnnouncements.remove(removedOne);
                          announcements.insert(index, removedOne);
                        });
                      })));
            });
          },
          afterSwipingRight: (index, context) async {
      
            util.showPickerThreeNumber(
                context, widget.module, announcements[index]
            );
          },
          context: context,
          leftHint: Icon(Icons.schedule),
          rightHint: Icon(Icons.archive),
          params: {'module': widget.module});
    }

    if (_announcements != null) {
      // print('not null');
      sortAnnouncements(_announcements);
      return announcementList(_announcements);
    } else {
      // print('is null');
      return FutureBuilder<List<dynamic>>(
        future: _read(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _announcements = snapshot.data;
            sortAnnouncements(_announcements);
            return announcementList(_announcements);
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return common.progressIndicator;
        },
      );
    }
  }

  void sortAnnouncements(List<Announcement> announcements) {
    announcements.sort((a, b) =>
        DateTime.parse(b.createdDate).compareTo(DateTime.parse(a.createdDate)));
  }

  Future<List<dynamic>> _read() async {
    String result =
        data.sp.getString('encodedAnnouncementList' + widget.module.name);
    if (result != null) {
      List maps = json.decode(result);
      _announcements = new List();
      for (int i = 0; i < maps.length; i++) {
        _announcements.add(Announcement.fromJson(maps[i]));
      }
      return _announcements;
    } else {
      return API.getAnnouncements(data.authentication(), widget.module);
    }
  }

  void _write() async {
    List<Map> maps = new List();
    for (Announcement announcement in _announcements) {
      maps.add(announcement.toJson());
    }
    String encodedList = json.encode(maps);
    data.sp
        .setString('encodedAnnouncementList' + widget.module.name, encodedList);
  }
}
