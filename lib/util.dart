import 'package:intl/intl.dart';

String datetimeToFormattedString(DateTime time) {
  return DateFormat('EEE, d/M/y ').format(time) + DateFormat.jm().format(time);
}

String datetimeStringToFormattedString(String timeString) {
  return datetimeToFormattedString(DateTime.parse(timeString));
}