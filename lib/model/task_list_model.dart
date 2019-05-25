import 'package:flutter/material.dart';
import 'package:luminus_api/luminus_api.dart';

class TaskDetail {
}

class Task {
    final int id;
    final String summary;
    final DateTime date;
    final Announcement announcement;
    

    Task({
      @required this.id,
      @required this.summary,
      @required this.date,
      @required this.announcement
    });

    Task copyWith({int id, String summary, DateTime date, Announcement announcement}) {
      return Task(
        id: id?? this.id,
        summary: summary?? this.summary,
        date: date?? this.date,
        announcement: announcement?? this.announcement
      );
    }

    Task.fromJson(Map<String, dynamic> json) :
      id = json['id'],
      summary = json['summary'],
      date = json['date'],
      announcement = json['announcement'];
    

    Map<String, dynamic> toJson() {
      final Map<String, dynamic> data = new Map<String, dynamic>();
      data['id'] = this.id;
      data['summary'] = this.summary;
      data['date'] = this.date;
      data['announcement'] = this.announcement;
      return data;
    }
}

class TaskListState {
  final List<Task> tasks;

  TaskListState({@required this.tasks});

  TaskListState.initialState():
    tasks = List.unmodifiable(<Task>[]);

    TaskListState.fromJson(Map json) : 
        tasks = (json['tasks'] as List).map((x) => Task.fromJson(x)).toList();

    Map<String, dynamic> toJson() => {'tasks': tasks};
}