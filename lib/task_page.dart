import 'package:fluminus/model/task_list_model.dart';
import 'package:flutter/material.dart';
// import 'package:luminus_api/luminus_api.dart';
// import 'package:fluminus/data.dart' as data;
import 'package:fluminus/widgets/list.dart' as list;
import 'package:fluminus/widgets/dialog.dart' as dialog;
import 'package:fluminus/widgets/placeholder.dart' as ph;
import 'package:fluminus/redux/reducers.dart';
import 'package:fluminus/redux/actions.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:luminus_api/luminus_api.dart';
import 'package:redux/redux.dart';

class TaskPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Store<TaskListState> store = Store<TaskListState>(
      taskListReducer,
      initialState: TaskListState.initialState(),
    );
    return StoreProvider<TaskListState>(
        store: store,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Task'),
          ),
          body: StoreConnector<TaskListState, _ViewModel>(
            converter: (Store<TaskListState> store) => _ViewModel.create(store),
            builder: (BuildContext context, _ViewModel viewModel) => 
              list.itemListView(viewModel.tasks, () => list.CardType.announcementCardType, context, null)
            )
          ), 
        );
  }
}

class _ViewModel {
  final List<Task> tasks;
  final Function(DateTime, Announcement) onAddTask;
  final Function(Task) onRemoveTask;
  

  _ViewModel({
    this.tasks,
    this.onAddTask,
    this.onRemoveTask
    
  });

  factory _ViewModel.create(Store<TaskListState> store) {
    _onAddTask(DateTime date, Announcement announcement) {
      store.dispatch(AddTaskAction(date, announcement));
    }
    _onRemoveTask(Task task) {
      store.dispatch(RemoveTaskAction(task));
    }

    return _ViewModel(
      tasks: store.state.tasks,
      onAddTask: _onAddTask,
      onRemoveTask: _onRemoveTask
    );
  }
}