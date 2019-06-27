import 'package:fluminus/model/task_list_model.dart';
import 'package:flutter/rendering.dart';
import 'package:luminus_api/luminus_api.dart';

class AddTaskAction{
  static int _id = 0;
  final String title;
  final String detail;
  final String date;
  final String dayOfWeek;
  final int weekNum;
  final String startTime;
  final String endTime;
  final bool isAllDay;
  final String location;
  final String tag;
  final int colorIndex;

  AddTaskAction(this.title, this.detail, this.date, this.dayOfWeek, this.weekNum, this.startTime, this.endTime, this.isAllDay, this.location, this.tag, this.colorIndex) {
    _id++;
  }

  int get id => _id;
}

class RemoveTaskAction{
  final Task task;
  RemoveTaskAction(this.task);

}

class GetTasksAction{}

class LoadedTasksAction{
  final List<Task> tasks;
  LoadedTasksAction(this.tasks);
}