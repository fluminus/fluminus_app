
import 'package:fluminus/redux/actions.dart';
import 'package:fluminus/model/task_list_model.dart';


TaskListState taskListReducer(TaskListState state, action) {
  return TaskListState(
    tasks: taskReducer(state.tasks, action),
  );
}

List<Task> taskReducer(List<Task> state, action) {
  if (action is AddTaskAction) {
    List<Task> tasks = []
      .. addAll(state)
      .. add(Task(id: action.id, title: action.title, detail: action.detail, date: action.date, dayOfWeek: action.dayOfWeek, weekNum: action.weekNum, startTime: action.startTime, endTime: action.endTime, isAllDay: action.isAllDay, location: action.location, tag: action.tag, colorIndex: action.colorIndex));
      print(tasks);
      return tasks;
  }
  if (action is RemoveTaskAction) {
    return List.unmodifiable(List.from(state)..remove(action.task));
  }
  if (action is LoadedTasksAction) {
    return action.tasks;
  }
  return state;
}

