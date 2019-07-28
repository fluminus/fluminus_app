// import 'dart:convert';

import 'package:flutter/material.dart';
// import 'package:luminus_api/luminus_api.dart';

class Task {
  final int id;
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

  Task(
      {@required this.id,
      @required this.title,
      this.detail,
      @required this.date,
      @required this.dayOfWeek,
      @required this.weekNum,
      this.startTime,
      this.endTime,
      @required this.isAllDay,
      this.location,
      this.tag,
      this.colorIndex, String appBar});

  Task copyWith(
      {int id, String title, String detail, String date, String dayOfWeek, int weekNum, String startTime, 
      String endTime, bool, isAllDay, String location, String tag, int color}) {
    return Task(
        id: id ?? this.id,
        title: title ?? this.title,
        detail: detail??this.detail,
        date: date ?? this.date,
        dayOfWeek: dayOfWeek??this.dayOfWeek,
        weekNum: weekNum??this.weekNum,
        startTime: startTime??this.startTime,
        endTime: endTime??this.endTime,
        isAllDay: isAllDay??this.isAllDay,
        location: location??this.location,
        tag: tag??this.tag,
        colorIndex: color??this.colorIndex
        );
  }

  Task.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        detail = json['detail'],
        date = json['date'],
        dayOfWeek = json['dayOfWeek'],
        weekNum = json['weekNum'],
        startTime = json['startTime'],
        endTime = json['endTime'],
        isAllDay = json['isAllDay'],
        location = json['location'],
        tag = json['tag'],
        colorIndex = json['color'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = new Map<String, dynamic>();
    map['id'] = this.id;
    map['title'] = this.title;
    map['detail'] = this.detail??'';
    map['date'] = this.date;
    map['dayOfWeek'] = this.dayOfWeek;
    map['weekNum'] = this.weekNum;
    map['startTime'] = this.startTime??'';
    map['endTime'] = this.endTime??'';
    map['isAllDay'] = this.isAllDay;
    map['location'] = this.location??'';
    map['tag'] = this.tag??'';
    map['color'] = this.colorIndex??0;
    return map;
  }
}

class TaskListState {
  final List<Task> tasks;

  TaskListState({@required this.tasks});

  TaskListState.initialState() : tasks = List.unmodifiable(<Task>[]);

  TaskListState.fromJson(Map json)
      : tasks = (json['tasks'] as List).map((x) => Task.fromJson(x)).toList();

  Map<String, dynamic> toJson() {
    List<Map> maps = new List();
    for (Task task in tasks) {
      maps.add(task.toJson());
    }
    return {'tasks': maps};
  }
}
