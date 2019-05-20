import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:collection/collection.dart';
import 'package:html/parser.dart';

Function twoListsAreDeepEqual = const DeepCollectionEquality().equals;

String datetimeToFormattedString(DateTime time) {
  return DateFormat('EEE, d/M/y ').format(time) + DateFormat.jm().format(time);
}

String formatLastUpdatedTime(String lastUpdatedTime) {
  return 'Last updated: ' + datetimeStringToFormattedString(lastUpdatedTime);
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

String parsedHtmlText(String htmlText) {
  var document = parse(htmlText);
  return parse(document.body.text).documentElement.text;
}

GestureTapCallback onTapNextPage(Widget nextPage, BuildContext context) {
  return () => {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return nextPage;
        }))
      };
}


