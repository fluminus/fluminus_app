import 'package:fluminus/redux/store.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:luminus_api/luminus_api.dart';
import 'package:collection/collection.dart';
import 'package:html/parser.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:fluminus/widgets/dialog.dart' as dialog;
import 'data.dart' as data;


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

String formatDateAsTitle(DateTime date) {
  return new DateFormat("dd MMMM  yyyy").format(date) + "\n" + new DateFormat("EEEE").format(date);
}

String formatTowDates(DateTime startDate, DateTime endDate) {
  return DateFormat("dd MMM yy").format(startDate) +
      " - " +
      DateFormat("dd MMM yy").format(endDate);
}

String formatDateAsDayOfWeek(DateTime date) {
  return DateFormat("E").format(date).substring(0, 3).toUpperCase();
}

Future<List> refreshWithSnackBars(Function getData, BuildContext context) async {
    List refreshedList;
    try {
      refreshedList = await getData();
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Refreshed'),
        duration: Duration(milliseconds: 500),
      ));
    } catch (e) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Refresh failed'),
        duration: Duration(seconds: 2),
        action: SnackBarAction(
          label: 'Details',
          onPressed: () {
            dialog.displayDialog('Detail', e.toString(), context);
          },
        ),
      ));
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

 showPickerThreeNumber(BuildContext context, Module module, Announcement announcement, {Function onCancel}) async {
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
                width: 30.0, alignment: Alignment.center, child: Text("M"))),
        PickerDelimiter(
            column: 3,
            child: Container(
                width: 30.0, alignment: Alignment.center, child: Text("W"))),
        PickerDelimiter(
            column: 5,
            child: Container(
                width: 30.0, alignment: Alignment.center, child: Text("D"))),
      ],
      hideHeader: true,
      title: ListTile(
        title: Text("Schedule in",
         style: Theme.of(context).textTheme.caption),
         subtitle: Text('month : week : day', 
         style: Theme.of(context).textTheme.subhead),
      ),    
      onConfirm: (Picker picker, List value) {
        DateTime date = getPickedDate(value);
        model.onAddTask(
            title: announcement.title,
            detail: parsedHtmlText(announcement.description),
            date: formatDate(date),
            dayOfWeek: formatDateAsDayOfWeek(date),
            weekNum: weekNum(data.smsStartDate, date),
            tag:module.name,
            colorIndex: 0);
      },
      onCancel: onCancel).showDialog(context);
      
}

DateTime getPickedDate(List diffOfMWD) {
  DateTime now = new DateTime.now();
  DateTime scheduledDate =
      new DateTime(now.year, now.month + diffOfMWD[0], now.day);
  var duration = diffOfMWD[1] * 7 + diffOfMWD[2];
  return scheduledDate.add(new Duration(days: duration));
}

int weekNum(DateTime startDate, DateTime givenDate) {
  return (givenDate.difference(startDate).inDays / 7).floor();
}

Future<String> showPickerTwoNumber(BuildContext context) async {
  String result = '';
  new Picker(
      adapter: NumberPickerAdapter(data: [
        NumberPickerColumn(begin: 00, end: 24),
        NumberPickerColumn(begin: 00, end: 24),
      ]),
      delimiter: [
        PickerDelimiter(
            column: 1,
            child: Container(
                width: 30.0, alignment: Alignment.center, child: Text(" : "))),
      ],
      hideHeader: true,
      onConfirm: (Picker picker, List value) {
        result = value[0] + " : " + value[1];
      }).showDialog(context);
  return result;
}

SnackBar snackBar(String info, {String actionName, Function action}) {
  return SnackBar(
    content: Text(info, textAlign: TextAlign.center,),
    /*action: SnackBarAction(
      label: actionName,
      onPressed: action
    ),*/
  );
}




