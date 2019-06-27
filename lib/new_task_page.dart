import 'package:fluminus/model/task_list_model.dart';
import 'package:fluminus/redux/store.dart';
import 'package:fluminus/widgets/theme.dart';
import 'package:flutter/material.dart';
import 'package:fluminus/util.dart' as util;
import 'package:shared_preferences/shared_preferences.dart';
import 'data.dart' as data;

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
  String tag;
  int colorIndex;

  DateTime dateTime = DateTime.now();

  Widget basicTextField(TextEditingController textController) {
    return TextField(
      controller: textController,
      autofocus: true,
      maxLines: null,
    );
  }

  Widget basicField(String label, Widget child) {
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
            child
          ]),
    );
  }

  Widget clickableText(
      String label, VoidCallback onTap, TextEditingController textController) {
    return InkWell(
        onTap: onTap,
        child: IgnorePointer(
            child: basicField(label, basicTextField(textController))));
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
    titleTextController =
        new TextEditingController(text: widget.task.title ?? "");
    detailTextController =
        new TextEditingController(text: widget.task.detail ?? "");
    dateTextController = new TextEditingController(
        text: widget.task.date ?? util.formatDate(DateTime.now()));
    startTimeTextController =
        new TextEditingController(text: widget.task.startTime ?? "00 : 00");
    endTimeTextController =
        new TextEditingController(text: widget.task.endTime ?? "00: 00");
    locationTextController =
        new TextEditingController(text: widget.task.location ?? "");
    tag = widget.task.tag ?? 'General';
    colorIndex = widget.task.colorIndex ?? 0;
  }

  @override
  void dispose() {
    titleTextController.dispose();
    detailTextController.dispose();
    dateTextController.dispose();
    startTimeTextController.dispose();
    endTimeTextController.dispose();
    locationTextController.dispose();
    super.dispose();
  }

  Future<List<String>> getModuleStrs() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    List<String> moduleStrs = new List()
      ..addAll(sp.getStringList('moduleStrs'));
    return moduleStrs;
  }

  List<String> tags = new List()
    ..addAll(data.modules.map((module) => module.name).toList())
    ..add('General');


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('New Task'),
          actions: <Widget>[
            Builder(
                builder: (context) => IconButton(
                      icon: Icon(Icons.check),
                      onPressed: () {
                        if (titleTextController.text == '') {
                          Scaffold.of(context).showSnackBar(
                              util.snackBar('Please fill in the title.'));
                        } else {
                          model.onRemoveTask(widget.task);

                          model.onAddTask(
                              title: titleTextController.text,
                              detail: detailTextController.text,
                              date: dateTextController.text,
                              dayOfWeek: util.formatDateAsDayOfWeek(dateTime),
                              weekNum:
                                  util.weekNum(data.smsStartDate, dateTime),
                              startTime: startTimeTextController.text,
                              endTime: endTimeTextController.text,
                              location: locationTextController.text,
                              tag: tag,
                              colorIndex: colorIndex);
                          Navigator.pop(context);
                        }
                      },
                    )),
          ],
        ),
        body: ListView.builder(
            shrinkWrap: true,
            itemCount: 1,
            itemBuilder: (context, index) {
              List<Color> colors = Theme.of(context).brightness == Brightness.light?
              lightColors : darkColors;

              return Column(children: <Widget>[
                basicField('TITLE', basicTextField(titleTextController)),
                basicField('DETAIL', basicTextField(detailTextController)),
                clickableText('DATE', () {
                  _selectedDate(context);
                }, dateTextController),
                Row(
                  children: <Widget>[
                    new Expanded(
                        flex: 1,
                        child: clickableText('FROM', () {
                          _selectTime(context, 'startTime');
                        }, startTimeTextController)),
                    new Expanded(
                        flex: 1,
                        child: clickableText('TO', () {
                          _selectTime(context, 'endTime');
                        }, endTimeTextController)),
                  ],
                ),
                basicField('LOCATION', basicTextField(locationTextController)),
                Padding(
                  padding: EdgeInsets.only(left: 20),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                    child: Row(children: <Widget>[
                      Text('TAG     '),
                      DropdownButton<String>(
                        style: Theme.of(context).textTheme.subtitle,
                        value: tag,
                        onChanged: (String newValue) {
                          setState(() {
                            tag = newValue;
                          });
                        },
                        items: tags
                            .map((tag) => DropdownMenuItem<String>(
                                value: tag,
                                child: Container(
                                  width: 80.0,
                                  height: 20.0,
                                  child: Text(tag),
                                )))
                            .toList(),
                      )
                    ])),
                     
                     Expanded(
                      flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children:<Widget>[
                        Text('COLOR     '),
                        DropdownButton<int>(
                          style: Theme.of(context).textTheme.subtitle,
                          value: colorIndex,
                          onChanged: (int newColorIndex) {
                            setState(() {
                              colorIndex = newColorIndex;
                            });
                          },
                          items: colors
                              .map((color) => DropdownMenuItem<int>(
                                    value: colors.indexOf(color),
                                    child: Container(
                                      width: 40.0,
                                      height: 20.0,
                                      color: color,
                                    ),
                                  ))
                              .toList(),
                        )]
                        )
                     )],
                ),
              )]);
            }));
  }
}
