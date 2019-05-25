import 'package:flutter/material.dart';
import 'package:luminus_api/luminus_api.dart';

class Task {
    final int id;
    final DateTime date;
    final Announcement announcement;

    Task({
      @required this.id,
      @required this.date,
      @required this.announcement
    });

    Task copyWith({int id, DateTime date, Announcement announcement}) {
      return Task(
        id: id?? this.id,
        date: date?? this.date,
        announcement: announcement?? this.announcement
      );
    }
}

class TaskListState {
  final List<Task> tasks;

  TaskListState({@required this.tasks});

  TaskListState.initialState():
    tasks = List.unmodifiable(<Task>[]);
}