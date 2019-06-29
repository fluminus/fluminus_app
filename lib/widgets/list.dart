import 'package:fluminus/file_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:luminus_api/luminus_api.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
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
    List itemList, Function getCardType, BuildContext context, Map params) {
  return new ListView.builder(
    shrinkWrap: true,
    itemCount: itemList.length,
    itemBuilder: (context, index) {
      return new Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.only(top: 6.0),
              child: _certainCard(itemList[index], getCardType(itemList[index]),
                  context, params))
        ],
      );
    },
  );
}

// Widget refreshableListView(
//     RefreshController refreshController,
//     Function onRefresh,
//     List itemList,
//     Function getCardType,
//     BuildContext context,
//     Map params,
//     ) {
//   return SmartRefresher(
//       enablePullDown: true,
//       enablePullUp: true,
//       controller: refreshController,
//       onRefresh: onRefresh,
//       onLoading: (){
//         refreshController.loadNoData();
//         refreshController.loadComplete();
//       },
//       child: itemListView(itemList, getCardType, context, params));
// }

Widget refreshableListView(
    RefreshController refreshController,
    Function onRefresh,
    List itemList,
    Function getCardType,
    BuildContext context,
    Map params,
    ) {
  return Container(
      child: prefix0.RefreshIndicator(
        onRefresh: onRefresh,
      child: itemListView(itemList, getCardType, context, params)
      ));
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
  return Container(
      child: prefix0.RefreshIndicator(
        onRefresh: onRefresh,
      child: dismissibleListView(itemList, getCardType, afterSwipingLeft,
          afterSwipingRight, context, params)));
}
