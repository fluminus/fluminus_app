import 'package:fluminus/model/task_list_model.dart';
import 'package:fluminus/redux/store.dart';
import 'package:flutter/material.dart';
import 'package:fluminus/redux/actions.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux_dev_tools/flutter_redux_dev_tools.dart';
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
                  builder: (BuildContext context, ViewModel viewModel) =>
                      list.itemListView(viewModel.tasks,
                          () => list.CardType.taskCardType, context, null)),
        ),
        drawer: Container(child: ReduxDevTools(store)),
      ),
    );
  }
}



/*class AddItemWidget extends StatefulWidget {
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
}*/