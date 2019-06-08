
import 'package:fluminus/redux/actions.dart';
import 'package:fluminus/model/task_list_model.dart';


TaskListState taskListReducer(TaskListState state, action) {
  return TaskListState(
    tasks: taskReducer(state.tasks, action),
  );
}

List<Task> taskReducer(List<Task> state, action) {
  if (action is AddTaskAction) {
    print("reducer: added");
    List<Task> tasks = []
      .. addAll(state)
      .. add(Task(id: action.id, summary: action.summary, date: action.date, announcement: action.announcement));
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

