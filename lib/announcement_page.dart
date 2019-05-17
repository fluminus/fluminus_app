import 'package:flutter/material.dart';
import 'data.dart' as Data;

class AnnouncementPage extends StatefulWidget {
  @override
  _AnnouncementPageState createState() => new _AnnouncementPageState();
}

class _AnnouncementPageState extends State<AnnouncementPage> {
  

  @override
  Widget build(BuildContext context) {
    return null;
  }

  DateTime selectedDate = DateTime.now();

  Future<Null> _selectDate() async {
    final DateTime pickedDate = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(2018,1,1),
        lastDate: new DateTime(2019,12,31)
    );
    if(pickedDate != null) setState(() => selectedDate = pickedDate);
  }
}


