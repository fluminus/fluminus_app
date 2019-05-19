import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:luminus_api/luminus_api.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:collection/collection.dart';

Function twoListsAreDeepEqual = const DeepCollectionEquality().equals;

String datetimeToFormattedString(DateTime time) {
  return DateFormat('EEE, d/M/y ').format(time) + DateFormat.jm().format(time);
}

String datetimeStringToFormattedString(String timeString) {
  return datetimeToFormattedString(DateTime.parse(timeString));
}

Future<List> onLoading(RefreshController controller, List currList, Function getData) async {
    List refreshedList = await getData();
    if (twoListsAreDeepEqual(currList, refreshedList)) {
      controller.loadNoData();
    } else {
      print("load: got data");
      controller.loadComplete();
    }
    return refreshedList;
  }

  Future<List> onLoadingTest(RefreshController controller, List currList) async {
    List refreshedList;
    List temp = new List();
    temp.add(currList[0]);
    refreshedList = temp;
    if (twoListsAreDeepEqual(currList, refreshedList)) {
      print("load no data");
      controller.loadNoData();
    } else {
      print("load: got data");
      controller.loadComplete();
    }
    return refreshedList;
  }

  List<Tab> getModuleTitlesAsTextTabs(List<Module> modules) {
  List<Tab> textWidgets = new List();
  for (Module mod in modules) {
    textWidgets.add(new Tab(text: mod.courseName));
  }
  return textWidgets;
}

