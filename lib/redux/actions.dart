import 'package:fluminus/model/task_list_model.dart';
import 'package:luminus_api/luminus_api.dart';

class AddTaskAction{
  static int _id = 0;
  final String summary;
  final String date;
  final String dayOfWeek;
  final int weekNum;
  final Announcement announcement;

  AddTaskAction(this.summary, this.date, this.dayOfWeek, this.weekNum,this.announcement) {
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