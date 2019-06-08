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
  TextEditingController titleTextController; 
  TextEditingController detailTextController; 
  TextEditingController dateTextController; 
  TextEditingController startTimeTextController; 
  TextEditingController endTimeTextController; 
  TextEditingController locationTextController; 
  TextEditingController tagTextController; 

  DateTime dateTime = DateTime.now();

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

  Future<void> _selectedDate(BuildContext context) async {
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
          startTimeTextController.text = picked.format(context);
        } else if (target == 'endTime') {
          endTimeTextController.text = picked.format(context);
        }
      });
  }

  @override
  void initState() {
    super.initState();
    titleTextController = new TextEditingController(text: widget.task.title ?? "");
    detailTextController = new TextEditingController(text:widget.task.detail ?? "");
    dateTextController = new TextEditingController(text:widget.task.date ?? util.formatDate(DateTime.now()));
    startTimeTextController = new TextEditingController(text:widget.task.startTime ?? "00 : 00");
    endTimeTextController = new TextEditingController(text:widget.task.endTime ?? "00: 00");
    locationTextController = new TextEditingController(text:widget.task.location ?? "00: 00");
    tagTextController = new TextEditingController(text:widget.task.tag ?? "");
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
    
    return Scaffold(
        appBar: AppBar(
          title: Text('New Task'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.check),
              onPressed: () {
                model.onRemoveTask(widget.task);
                model.onAddTask(
                    title: titleTextController.text,
                    detail: detailTextController.text,
                    date: dateTextController.text,
                    dayOfWeek: util.formatDateAsDayOfWeek(dateTime),
                    weekNum: util.weekNum(data.smsStartDate, dateTime),
                    startTime: startTimeTextController.text,
                    endTime: endTimeTextController.text,
                    location: locationTextController.text,
                    tag: tagTextController.text);
                Navigator.pop(context);
              },
            ),
          ],
        ),
        body: Column(children: <Widget>[
          basicTextField('TITLE', titleTextController),
          basicTextField('DETAIL', detailTextController),
          clickableText('DATE', () {
            _selectedDate(context);
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
