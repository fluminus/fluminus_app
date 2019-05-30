import 'package:fluminus/model/task_list_model.dart';
import 'package:luminus_api/luminus_api.dart';

class AddTaskAction{
  static int _id = 0;
  final String summary;
  final String date;
  final Announcement announcement;

  AddTaskAction(this.summary, this.date, this.announcement) {
    _id++;
    print("Added");
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