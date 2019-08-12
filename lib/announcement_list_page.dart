import 'package:flutter/material.dart';
import 'package:luminus_api/luminus_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

class _AnnouncementListPageState extends State<AnnouncementListPage>
    with AutomaticKeepAliveClientMixin<AnnouncementListPage> {
  List<Announcement> _announcements;
  List<Announcement> _newAnnouncements;
  Future<SharedPreferences> _sprefs = SharedPreferences.getInstance();
  DateTime lastRefreshedDate = data.smsStartDate;
  bool isLuminusStupid = true;
  List<Announcement> _defaultList = [Announcement(id:'1', title: 'Welcome to Fluminus!', description: 'The name of Fluminus means the combination of Flutter and Luminus=)',createdDate: '20190812',expireAfter: '20190912'),
      Announcement(id:'2',title: 'Welcome to Fluminus!!', description: 'The name of Fluminus means the combination of Flutter and Luminus=)',createdDate: '20190812',expireAfter: '20190912'),
      Announcement(id:'3',title: 'Welcome to Fluminus!!!', description: 'The name of Fluminus means the combination of Flutter and Luminus=)',createdDate: '20190812',expireAfter: '20190912'),
      Announcement(id:'4',title: 'Welcome to Fluminus!!!!', description: 'The name of Fluminus means the combination of Flutter and Luminus=)',createdDate: '20190812',expireAfter: '20190912'),
      Announcement(id:'5',title: 'Welcome to Fluminus!!!!!', description: 'The name of Fluminus means the combination of Flutter and Luminus=)',createdDate: '20190812',expireAfter: '20190912'),
      Announcement(id:'6',title: 'Welcome to Fluminus!!!!!!!', description: 'The name of Fluminus means the combination of Flutter and Luminus=)',createdDate: '20190812',expireAfter: '20190912'),
      Announcement(id:'7',title: 'Welcome to Fluminus!!!!!!!!!!', description: 'The name of Fluminus means the combination of Flutter and Luminus=)',createdDate: '20190812',expireAfter: '20190912'),];

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
    if (isLuminusStupid) {
      _announcements = _defaultList;
    }
    Widget announcementList(List<dynamic> announcements) {
      return list.refreshableAndDismissibleListView(
          () async {
            _newAnnouncements = await util.refreshWithSnackBars(
                () =>
                    API.getAnnouncements(data.authentication(), widget.module),
                context);
            sortAnnouncements(_newAnnouncements);
            _newAnnouncements = _newAnnouncements.takeWhile((x) {
              return (DateTime.parse(x.createdDate).isAfter(lastRefreshedDate));
            }).toList();
            setState(() {
              lastRefreshedDate = DateTime.now();
              _announcements.addAll(_newAnnouncements);
              
            });
          },
          announcements,
          () => list.CardType.announcementCardType,
          (index) {
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
          (index, context) async {
            Announcement announcement = announcements[index];
            util.showPickerThreeNumber(
                context, data.smsStartDate, widget.module, announcement, index, _announcements);
          },
          context,
          Icon(Icons.schedule),
          Icon(Icons.archive),
          {'module': widget.module});
    }

    super.build(context);

    if (_announcements != null) {
      sortAnnouncements(_announcements);
      return announcementList(_announcements);
    } else {
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

  @override
  bool get wantKeepAlive => true;

  sortAnnouncements(List<Announcement> announcements) {
    announcements.sort((a, b) =>
        DateTime.parse(b.createdDate).compareTo(DateTime.parse(a.createdDate)));
  }

  Future<List<dynamic>> _read() async {
    final prefs = await _sprefs;
    String result =
        prefs.getString('encodedAnnouncementList' + widget.module.name);
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

  _write() async {
    final prefs = await _sprefs;
    List<Map> maps = new List();
    for (Announcement announcement in _announcements) {
      maps.add(announcement.toJson());
    }
    String encodedList = json.encode(maps);
    prefs.setString(
        'encodedAnnouncementList' + widget.module.name, encodedList);
  }
}
