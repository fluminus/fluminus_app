import 'package:fluminus/model/task_list_model.dart';
import 'package:luminus_api/luminus_api.dart';

class AddTaskAction{
  static int _id = 0;
  final DateTime date;
  final Announcement announcement;

  AddTaskAction(this.date, this.announcement) {
    _id++;
  }

  int get id => _id;
}

class RemoveTaskAction{
  final Task task;
  RemoveTaskAction(this.task);

}