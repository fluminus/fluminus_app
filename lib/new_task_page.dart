import 'package:fluminus/model/task_list_model.dart';
import 'package:flutter/material.dart';
import 'package:fluminus/util.dart' as util;
import 'package:luminus_api/luminus_api.dart';

class TaskDetail extends StatefulWidget {
  final Task task;

  TaskDetail(this.task);
  @override
  _TaskDetailState createState() => new _TaskDetailState();
}

class _TaskDetailState extends State<TaskDetail> {
  
  @override
  Widget build(BuildContext context) {
  String title = widget.task.title??"";
  String detail = widget.task.detail??"";
  String date = widget.task.date??util.formatDate(DateTime.now());
  String startTime = widget.task.startTime??"00 : 00";
  String endTime = widget.task.endTime??"00: 00";
  String location = widget.task.location??"00: 00";
  String tag = widget.task.tag??"";
    return Scaffold(
        appBar: AppBar(
          title: Text('New Task'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.check),
              onPressed: () {},
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
          children: <Widget>[
            TextField(
            )
          ],
        ),
        )
        
        
        );
  }
}
