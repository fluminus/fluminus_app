import 'package:fluminus/model/task_list_model.dart';
import 'package:fluminus/redux/store.dart';
import 'package:flutter/material.dart';
import 'package:fluminus/util.dart' as util;
import 'data.dart' as data;
import 'package:luminus_api/luminus_api.dart';

class TaskDetail extends StatefulWidget {
  final Task task;

  TaskDetail(this.task);
  @override
  _TaskDetailState createState() => new _TaskDetailState();
}

class _TaskDetailState extends State<TaskDetail> {
  String title;
  String detail;
  String date;
  String startTime;
  String endTime;
  String location;
  String tag;
  TextEditingController titleTextController = new TextEditingController();
  TextEditingController detailTextController = new TextEditingController();
  TextEditingController dateTextController = new TextEditingController();
  TextEditingController startTimeTextController = new TextEditingController();
  TextEditingController endTimeTextController = new TextEditingController();
  TextEditingController locationTextController = new TextEditingController();
  TextEditingController tagTextController = new TextEditingController();

  DateTime dateTime;

  Widget basicTextField(String label, TextEditingController textController,
      {String target}) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              label,
              style: Theme.of(context).textTheme.body2,
              textAlign: TextAlign.left,
            ),
            TextField(
              controller: textController,
              autofocus: true,
              maxLines: null,
            )
          ]),
    );
  }

  Widget clickableText(
      String label, VoidCallback onTap, TextEditingController textController) {
    return InkWell(
        onTap: onTap,
        child: IgnorePointer(child: basicTextField(label, textController)));
  }

  Future<void> _selectedDate(BuildContext context, String content) async {
    final DateTime pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2019),
        lastDate: DateTime(2050));
    if (pickedDate != null) {
      setState(() {
        dateTime = pickedDate;
        dateTextController.text = util.formatDate(pickedDate);
      });
    }
  }

  Future<void> _selectTime(BuildContext context, String target) async {
    final TimeOfDay picked =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (picked != null)
      setState(() {
        if (target == 'startTime') {
          startTime = picked.format(context);
          startTimeTextController.text = startTime;
        } else if (target == 'endTime') {
          endTimeTextController.text = picked.format(context);
        }
      });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    titleTextController.dispose();
    detailTextController.dispose();
    dateTextController.dispose();
    startTimeTextController.dispose();
    endTimeTextController.dispose();
    locationTextController.dispose();
    tagTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    title = widget.task.title ?? "";
    detail = widget.task.detail ?? "";
    date = widget.task.date ?? util.formatDate(DateTime.now());
    startTime = widget.task.startTime ?? "00 : 00";
    endTime = widget.task.endTime ?? "00: 00";
    location = widget.task.location ?? "00: 00";
    tag = widget.task.tag ?? "";

    return Scaffold(
        appBar: AppBar(
          title: Text('New Task'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.check),
              onPressed: () {
                title = titleTextController.text;
                detail = detailTextController.text;
                date = dateTextController.text;
                startTime = startTimeTextController.text;
                endTime = endTimeTextController.text;
                location = locationTextController.text;
                tag = tagTextController.text;
                model.onAddTask(
                    title: title,
                    detail: detail,
                    date: date,
                    dayOfWeek: util.formatDateAsDayOfWeek(dateTime),
                    weekNum: util.weekNum(data.smsStartDate, dateTime),
                    startTime: startTime,
                    endTime: endTime,
                    location: location,
                    tag: tag);
                Navigator.pop(context);
              },
            ),
          ],
        ),
        body: Column(children: <Widget>[
          basicTextField('TITLE', titleTextController),
          basicTextField('DETAIL', detailTextController),
          clickableText('DATE', () {
            _selectedDate(context, date);
          }, dateTextController),
          Row(
            children: <Widget>[
              new Expanded(
                  flex: 1,
                  child: clickableText('From', () {
                    _selectTime(context, 'startTime');
                  }, startTimeTextController)),
              new Expanded(
                  flex: 1,
                  child: clickableText('To', () {
                    _selectTime(context, 'endTime');
                  }, endTimeTextController)),
            ],
          ),
          basicTextField('LOCATION', locationTextController),
          new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Expanded(
                  child:
                      clickableText('TAG', () {}, new TextEditingController()),
                ),
                Icon(Icons.arrow_drop_down)
              ])
        ]));
  }
}
