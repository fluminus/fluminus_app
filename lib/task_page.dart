import 'package:fluminus/model/task_list_model.dart';
import 'package:flutter/material.dart';
import 'package:fluminus/redux/reducers.dart';
import 'package:fluminus/redux/actions.dart';
import 'package:fluminus/redux/middleware.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:luminus_api/luminus_api.dart';
import 'package:redux/redux.dart';
import 'package:redux_dev_tools/redux_dev_tools.dart';
import 'package:flutter_redux_dev_tools/flutter_redux_dev_tools.dart';
import 'package:fluminus/widgets/list.dart' as list;

class TaskPage extends StatelessWidget {
  static DevToolsStore<TaskListState> store = DevToolsStore<TaskListState>(
    taskListReducer,
    initialState: TaskListState.initialState(),
    middleware: [middleware],
  );
  static _ViewModel model = _ViewModel.create(store);

  @override
  Widget build(BuildContext context) {
    return StoreProvider<TaskListState>(
      store: store,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Task'),
        ),
        body: StoreBuilder<TaskListState>(
          onInit: (store) => store.dispatch(GetTasksAction()),
          builder: (BuildContext context, Store<TaskListState> store) =>
              StoreConnector<TaskListState, _ViewModel>(
                  converter: (Store<TaskListState> store) => model,
                  builder: (BuildContext context, _ViewModel viewModel) =>
                      list.itemListView(viewModel.tasks,
                          () => list.CardType.taskCardType, context, null)),
        ),
        drawer: Container(child: ReduxDevTools(store)),
      ),
    );
  }
}

class _ViewModel {
  final List<Task> tasks;
  final Function(String, DateTime, Announcement) onAddTask;
  final Function(Task) onRemoveTask;

  _ViewModel({this.tasks, this.onAddTask, this.onRemoveTask});

  factory _ViewModel.create(Store<TaskListState> store) {
    _onAddTask(String summary, DateTime date, Announcement announcement) {
      store.dispatch(AddTaskAction(summary, date, announcement));
    }

    _onRemoveTask(Task task) {
      store.dispatch(RemoveTaskAction(task));
    }
  
    return _ViewModel(
        tasks: store.state.tasks,
        onAddTask: _onAddTask,
        onRemoveTask: _onRemoveTask);
  }
}

class AddItemWidget extends StatefulWidget {
  final _ViewModel model;

  AddItemWidget(this.model);

  @override
  _AddItemState createState() => _AddItemState();
}

class _AddItemState extends State<AddItemWidget> {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: 'add an Item',
      ),
      onSubmitted: (String s) {
        widget.model.onAddTask(s,DateTime.now(),null);
        controller.text = '';
      },
    );
  }
}