import 'package:flutter/material.dart';
import 'package:luminus_api/luminus_api.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
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
  List<dynamic> _announcements;
  List<dynamic> _refreshedAnnouncements;
  RefreshController _refreshController;
  Future<SharedPreferences> _sprefs = SharedPreferences.getInstance();

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    _write();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> onRefresh() async {
      _refreshedAnnouncements = await util.onLoading(
          _refreshController,
          _announcements,
          () => API.getAnnouncements(data.authentication(), widget.module));

      if (_refreshedAnnouncements == null) {
        _refreshController.refreshFailed();
      } else {
        setState(() {
          _announcements = _refreshedAnnouncements;
        });
        _refreshController.refreshCompleted();
      }
    }

    Widget announcementList(List<dynamic> announcements) {
      return list.refreshableAndDismissibleListView(
          _refreshController,
          () => onRefresh(),
          announcements,
          () => list.CardType.announcementCardType, (index) {
        setState(() {
          Announcement removedAnnouncement = announcements.removeAt(index);
          Scaffold.of(context).showSnackBar(
                              util.snackBar('Announcement archived'));
        });
      }, (index, context) async{
        Announcement announcement = announcements[index];
        util.showPickerThreeNumber(context, data.smsStartDate, widget.module,announcement);
        
      }, context, {'module': widget.module});
    }

    super.build(context);

    if (_announcements != null) {
      return announcementList(_announcements);
    } else {
      return FutureBuilder<List<dynamic>>(
        future: _read(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _announcements = snapshot.data;
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

  Future<List<dynamic>> _read() async {
    final prefs = await _sprefs;
    String result = prefs.getString('encodedAnnouncementList' + widget.module.name);
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
    prefs.setString('encodedAnnouncementList' + widget.module.name, encodedList);
  }
}
