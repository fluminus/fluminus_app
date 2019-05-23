import 'package:flutter/material.dart';
import 'package:luminus_api/luminus_api.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
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
    Future<void> onRefresh() async {
      _refreshedAnnouncements = await util.onLoading(
          _refreshController,
          _announcements,
          () => API.getAnnouncements(data.authentication, widget.module));

      if (_refreshedAnnouncements == null) {
        _refreshController.refreshFailed();
      } else {
        setState(() {
          _announcements = _refreshedAnnouncements;
        });
        _refreshController.refreshCompleted();
      }
    }

    Widget announcementList(List<Announcement> announcements) {
      return list.refreshableAndDismissibleListView(
          _refreshController,
          () => onRefresh(),
          announcements,
          () => list.CardType.announcementCardType, (index) {
        setState(() {
          announcements.removeAt(index);
        });
      }, (index, context) {
        util.showPickerNumber(context);
      }, context, null);
    }

    if (_announcements != null) {
      return announcementList(_announcements);
    } else {
      return FutureBuilder<List<Announcement>>(
        future: API.getAnnouncements(data.authentication, widget.module),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _announcements = snapshot.data;
            return announcementList(_announcements);
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return common.processIndicator;
        },
      );
    }
  }

  @override
  bool get wantKeepAlive => true;
}
