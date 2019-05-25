
import 'package:fluminus/redux/actions.dart';
import 'package:fluminus/model/task_list_model.dart';


TaskListState taskListReducer(TaskListState state, action) {
  return TaskListState(
    tasks: taskReducer(state.tasks, action),
  );
}

List<Task> taskReducer(List<Task> state, action) {
  if (action is AddTaskAction) {
    return []
      .. addAll(state)
      .. add(Task(id: action.id, date: action.date, announcement: action.announcement));
  }
  if (action is RemoveTaskAction) {
    return List.unmodifiable(List.from(state)..remove(action.task));
  }
  return state;
}