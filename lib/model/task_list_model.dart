import 'package:flutter/material.dart';
import 'package:luminus_api/luminus_api.dart';

class Task {
  final int id;
  final String summary;
  final String date;
  final String dayOfWeek;
  final Announcement announcement;

  Task(
      {@required this.id,
      @required this.summary,
      @required this.date,
      @required this.dayOfWeek,
      @required this.announcement});

  Task copyWith(
      {int id, String summary, String date, Announcement announcement}) {
    return Task(
        id: id ?? this.id,
        summary: summary ?? this.summary,
        date: date ?? this.date,
        announcement: announcement ?? this.announcement);
  }

  Task.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        summary = json['summary'],
        date = json['date'],
        dayOfWeek = json['dayOfWeek'],
        announcement = Announcement.fromJson(json['announcement']);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = new Map<String, dynamic>();
    map['id'] = this.id;
    map['summary'] = this.summary;
    map['date'] = this.date;
    map['dayOfWeek'] = this.dayOfWeek;
    map['announcement'] = this.announcement.toJson();
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
