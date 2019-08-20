import 'package:fluminus/file_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:luminus_api/luminus_api.dart';
import 'card.dart';

enum CardType {
  announcementCardType,
  moduleCardType,
  directoryCardType,
  moduleDirectoryCardType,
  moduleRootDirectoryCardType,
  taskCardType,
  fileCardType
}

Widget _certainCard(var item, CardType type, BuildContext context, Map params) {
  // TODO: make this type safe
  switch (type) {
    case CardType.announcementCardType:
      return announcementCard(item, context);
    case CardType.moduleCardType:
      return moduleCard(item, context);
    case CardType.directoryCardType:
      return directoryCard(item, context);
    case CardType.moduleDirectoryCardType:
      return moduleDirectoryCard(item, context, params['module']);
    case CardType.moduleRootDirectoryCardType:
      return moduleRootDirectoryCard(item, context);
    case CardType.taskCardType:
      return taskCard(item, context);
    case CardType.fileCardType:
      File file = item;
      Map<BasicFile, FileStatus> statusMap = params['status'];
      Future<void> Function(File, Map<BasicFile, FileStatus>) downloadFile =
          params['downloadFile'];
      Future<void> Function(File) openFile = params['openFile'];
      Future<void> Function(File, Map<BasicFile, FileStatus>) deleteFile =
          params['deleteFile'];
      return fileCard(file, context, statusMap[item], statusMap, downloadFile,
          openFile, deleteFile);
  }
  return null;
}

Widget itemListView(
    List itemList, Function getCardType, BuildContext context, Map params,
    {bool isSeparated = false}) {
  if (itemList.length == 0) {
    return ListView(
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height * 3 / 4,
          alignment: Alignment(0.0, 0.0),
          child: Text(
            'No new items here.\n(You may pull down to refresh tho...)',
            textAlign: TextAlign.center,
          ),
        )
      ],
    );
  } else {
    if (isSeparated) {
      return ListView.separated(
        separatorBuilder: (context, index) => Divider(
              color: Colors.blueGrey,
              height: 0.0,
            ),
        padding: EdgeInsets.all(0.0),
        shrinkWrap: true,
        itemCount: itemList.length,
        itemBuilder: (context, index) {
          return Padding(
              padding: const EdgeInsets.only(bottom: 0.0),
              child: _certainCard(
                  itemList[index], getCardType(), context, params));
        },
      );
    } else {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: itemList.length,
        itemBuilder: (context, index) {
          return new Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: _certainCard(
                      itemList[index], getCardType(), context, params))
            ],
          );
        },
      );
    }
  }
}

Widget refreshableListView(
  Function onRefresh,
  List itemList,
  Function getCardType,
  BuildContext context,
  Map params,
  {bool isSeparated = false}
) {
  return Container(
      child: RefreshIndicator(
          onRefresh: onRefresh,
          child: itemListView(itemList, getCardType, context, params, isSeparated: isSeparated)));
}

Widget dismissibleListView(
    List itemList,
    Function getCardType,
    Function afterSwipingLeft,
    Function afterSwipingRight,
    BuildContext context,
    Widget leftHint,
    Widget rightHint,
    Map params) {
  return new ListView.separated(
    separatorBuilder: (context, index) => Divider(
          color: Colors.blueGrey,
          height: 0.0,
        ),
    padding: EdgeInsets.all(0.0),
    shrinkWrap: true,
    itemCount: itemList.length,
    itemBuilder: (context, index) {
      final item = itemList[index];
      return Dismissible(
          background: new Container(
              color: Theme.of(context).accentColor,
              child: leftHint,
              alignment: Alignment(-0.8, 0)),
          secondaryBackground: new Container(
              color: Theme.of(context).backgroundColor,
              child: rightHint,
              alignment: Alignment(0.8, 0)),
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
                  padding: const EdgeInsets.only(bottom: 0.0),
                  child: _certainCard(
                      itemList[index], getCardType(), context, params))
            ],
          ));
    },
  );
}

Widget refreshableAndDismissibleListView(
    {Function onRefresh,
    List itemList,
    Function getCardType,
    Function afterSwipingLeft,
    Function afterSwipingRight,
    BuildContext context,
    Widget leftHint,
    Widget rightHint,
    Map params}) {
  if (itemList.length == 0) {
    return Container(
        child: RefreshIndicator(
            onRefresh: onRefresh,
            child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Container(
                  height: MediaQuery.of(context).size.height * 3 / 4,
                  alignment: Alignment(0.0, 0.0),
                  child: Text(itemList is List<Announcement>
                      ? 'No new announcements.'
                      : 'No new items.'),
                ))));
  } else {
    return Container(
        child: RefreshIndicator(
            onRefresh: onRefresh,
            child: dismissibleListView(itemList, getCardType, afterSwipingLeft,
                afterSwipingRight, context, leftHint, rightHint, params)));
  }
}
