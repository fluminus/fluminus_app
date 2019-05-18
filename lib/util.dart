import 'package:intl/intl.dart';

String datetimeToString(DateTime time) {
  return DateFormat('EEE, d/M/y ').format(time) + DateFormat.jm().format(time);
}
