import 'package:fluminus/model/task_list_model.dart';
import 'package:fluminus/redux/store.dart';
import 'package:flutter/material.dart';
import 'package:fluminus/redux/actions.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux_dev_tools/flutter_redux_dev_tools.dart';
import 'package:side_header_list_view/side_header_list_view.dart';
import 'package:fluminus/widgets/list.dart' as list;

class TaskPage extends StatelessWidget {
  
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
              StoreConnector<TaskListState, ViewModel>(
                  converter: (Store<TaskListState> store) => model,
                  builder: (BuildContext context, ViewModel viewModel) {
                      return list.itemListView(store.state.tasks,
                          () => list.CardType.taskCardType, context, null);}
                          ),
        ),
        drawer: Container(child: ReduxDevTools(store)),
      ),
    );
  }
}
