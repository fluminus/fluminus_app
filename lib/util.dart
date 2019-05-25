import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:collection/collection.dart';
import 'package:html/parser.dart';
import 'package:flutter_picker/flutter_picker.dart';

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

String formatDate(DateTime date) {
  return new DateFormat("dd / MMM / yyyy").format(date);
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

showPickerNumber(BuildContext context) {
    new Picker(
        adapter: NumberPickerAdapter(data: [
          NumberPickerColumn(begin: 0, end: 4),
          NumberPickerColumn(begin: 0, end: 10),
          NumberPickerColumn(begin: 0, end: 20),
        ]),
        delimiter: [
          PickerDelimiter(
            column: 1,
            child: Container(
            width: 30.0,
            alignment: Alignment.center,
            child: Text("M")
          )),
          PickerDelimiter(
            column: 3,
            child: Container(
            width: 30.0,
            alignment: Alignment.center,
            child: Text("W")
          )),
          PickerDelimiter(
            column: 5,
            child: Container(
            width: 30.0,
            alignment: Alignment.center,
            child: Text("D")
          )),
        ],
        hideHeader: true,
        title: new Text(
          "Schedule task in\n(month : week : day)",
          style: Theme.of(context).textTheme.title),
        onConfirm: (Picker picker, List value) {
          print(value.toString());
          print(picker.getSelectedValues());
        }
    ).showDialog(context);
  }

