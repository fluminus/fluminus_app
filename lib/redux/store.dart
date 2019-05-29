import 'package:fluminus/model/task_list_model.dart';
import 'package:luminus_api/luminus_api.dart';
import 'package:redux/redux.dart';
import 'package:redux_dev_tools/redux_dev_tools.dart';
import 'actions.dart';
import 'reducers.dart';
import 'middleware.dart';

DevToolsStore<TaskListState> store = DevToolsStore<TaskListState>(
    taskListReducer,
    initialState: TaskListState.initialState(),
    middleware: [middleware],
  );

ViewModel model = ViewModel.create(store);


class ViewModel {
  final List<Task> tasks;
  final Function(String, DateTime, Announcement) onAddTask;
  final Function(Task) onRemoveTask;

  ViewModel({this.tasks, this.onAddTask, this.onRemoveTask});

  factory ViewModel.create(Store<TaskListState> store) {
    _onAddTask(String summary, DateTime date, Announcement announcement) {
      store.dispatch(AddTaskAction(summary, date, announcement));
    }

    _onRemoveTask(Task task) {
      store.dispatch(RemoveTaskAction(task));
    }
  
    return ViewModel(
        tasks: store.state.tasks,
        onAddTask: _onAddTask,
        onRemoveTask: _onRemoveTask);
  }
}