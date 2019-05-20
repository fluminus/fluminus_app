import 'package:flutter/material.dart';
import 'package:luminus_api/luminus_api.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'card.dart';

enum CardType {
  announcementCardType,
  moduleCardType,
  //directoryCardType,
  moduleDirectoryCardType,
  moduleRootDirectoryCardType,
}

Widget _certainCard(var item, CardType type, BuildContext context, Map params) {
  switch (type) {
    case CardType.announcementCardType:
      return announcementCard(item, context);
      break;
    case CardType.moduleCardType:
      return moduleCard(item, context);
      break;
    /*case CardType.directoryCardType:
      return directoryCard(item, context);
      break;*/
    case CardType.moduleDirectoryCardType:
      return moduleDirectoryCard(item, context, params['module']);
      break;
    case CardType.moduleRootDirectoryCardType:
      return moduleRootDirectoryCard(item, context);
      break;
  }
  return null;
}

Widget itemListView(List itemList, CardType type, BuildContext context, Map params) {
  return new ListView.builder(
    shrinkWrap: true,
    itemCount: itemList.length,
    itemBuilder: (BuildContext context, int index) {
      return new Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.only(bottom: 6.0),
              child: _certainCard(itemList[index], type, context, params))
        ],
      );
    },
  );
}

Widget refreshableListView(
    Module module,
    RefreshController refreshController,
    Function onRefresh,
    Widget listDisplay(Module module, BuildContext context)) {
  return SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      controller: refreshController,
      onRefresh: onRefresh,
      child: ListView.builder(
          itemCount: 1,
          itemBuilder: (context, index) {
            return listDisplay(module, context);
          }));
}
