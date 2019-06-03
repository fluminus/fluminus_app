import 'package:fluminus/model/task_list_model.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:side_header_list_view/side_header_list_view.dart';
import 'card.dart';
import 'package:fluminus/util.dart' as util;

enum CardType {
  announcementCardType,
  moduleCardType,
  directoryCardType,
  moduleDirectoryCardType,
  moduleRootDirectoryCardType,
  taskCardType
}

Widget _certainCard(var item, CardType type, BuildContext context, Map params) {
  switch (type) {
    case CardType.announcementCardType:
      return announcementCard(item, context);
      break;
    case CardType.moduleCardType:
      return moduleCard(item, context);
      break;
    case CardType.directoryCardType:
      return directoryCard(item, context);
      break;
    case CardType.moduleDirectoryCardType:
      return moduleDirectoryCard(item, context, params['module']);
      break;
    case CardType.moduleRootDirectoryCardType:
      return moduleRootDirectoryCard(item, context);
      break;
    case CardType.taskCardType:
      return taskCard(item, context, null);
      break;
  }
  return null;
}

Widget itemListView(
    List itemList, Function getCardType, BuildContext context, Map params) {
  return new ListView.builder(
    shrinkWrap: true,
    itemCount: itemList.length,
    itemBuilder: (context, index) {
      return new Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.only(bottom: 6.0),
              child:
                  _certainCard(itemList[index], getCardType(), context, params))
        ],
      );
    },
  );
}

Widget refreshableListView(
    RefreshController refreshController,
    Function onRefresh,
    List itemList,
    Function getCardType,
    BuildContext context,
    Map params) {
  return SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      controller: refreshController,
      onRefresh: onRefresh,
      child: itemListView(itemList, getCardType, context, params));
}

Widget dismissibleListView(
    List itemList,
    Function getCardType,
    Function afterSwipingLeft,
    Function afterSwipingRight,
    BuildContext context,
    Map params) {
  return new ListView.builder(
    shrinkWrap: true,
    itemCount: itemList.length,
    itemBuilder: (context, index) {
      final item = itemList[index];
      return Dismissible(
          //TODO: ensure that item has id =)
          key: Key(item.id),
          onDismissed: (direction) {
            switch (direction) {
              case DismissDirection.endToStart:
                afterSwipingLeft(index);
                break;
              case DismissDirection.startToEnd:
                afterSwipingRight(index, context);
                break;
              default:
                break;
            }
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.only(bottom: 6.0),
                  child: _certainCard(
                      itemList[index], getCardType(), context, params))
            ],
          ));
    },
  );
}

Widget refreshableAndDismissibleListView(
    RefreshController refreshController,
    Function onRefresh,
    List itemList,
    Function getCardType,
    Function afterSwipingLeft,
    Function afterSwipingRight,
    BuildContext context,
    Map params) {
  return SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      controller: refreshController,
      onRefresh: onRefresh,
      child: dismissibleListView(itemList, getCardType, afterSwipingLeft,
          afterSwipingRight, context, params));
}

class sideHeaderList {
  final DateTime smsStartDate;

  sideHeaderList(this.smsStartDate);

  Widget sideHeaderListView(
      List<Task> tasks, Function getCardType, BuildContext context, Map params) {
    return new Scaffold(
      body: new SideHeaderListView(
        itemCount: tasks.length,
        padding: new EdgeInsets.all(16.0),
        itemExtend: 48.0,
        headerBuilder: (BuildContext context, int index) {
          return new SizedBox(
              width: 32.0,
              child: new Text(
                tasks[index].dayOfWeek,
                style: Theme.of(context).textTheme.headline,
              ));
        },
        itemBuilder: (BuildContext context, int index) {
          return taskCard(tasks[index], context, null);
        },
        hasSameHeader: (int a, int b) {
          return tasks[a].dayOfWeek == tasks[b].dayOfWeek;
        },
      ),
    );
  } 
}

abstract class ListItem {}

class HeadingItem implements ListItem {
  final int weekNum;

  HeadingItem(this.weekNum);
}

List<Widget> weekHeaders(DateTime smsStartDate, BuildContext context) {
  List<Widget> weekHeaders = new List();
  int totalWeeks = 18;
  int weekNum = smsStartDate.month == 8 ? 0 : 1;
  String info;
  DateTime startDate = smsStartDate;
  DateTime endDate = smsStartDate.add(new Duration(days: 7));
  for (int i = weekNum; i <= totalWeeks; i++, weekNum++) {
    if (weekNum == 7) {
      info = "Recess Week";
      weekNum--;
    } else if (weekNum == 14) {
      info = "Reading Week";
    } else if (weekNum > 14 && weekNum <= 16) {
      info = "Examination";
    } else if (weekNum > 16) {
      info = "Vacation";
    } else {
      info = "Week $weekNum";
    }
    weekHeaders.add(Container(
        child: Row(
      children: <Widget>[
        Text(
          info,
          style: Theme.of(context).textTheme.headline,
        ),
        Text(
          util.formatTowDates(startDate, endDate),
          style: Theme.of(context).textTheme.headline,
          textAlign: TextAlign.end,
        )
      ],
    )));
  }
  return weekHeaders;
}
