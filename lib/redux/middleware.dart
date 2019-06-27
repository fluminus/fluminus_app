import 'dart:async';
import 'dart:convert';

import 'package:fluminus/model/task_list_model.dart';
import 'package:fluminus/redux/actions.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';

void saveToPrefs(TaskListState state) async {
  SharedPreferences sp = await SharedPreferences.getInstance();
  String encodedList = json.encode(state.toJson());
  await sp.setString('tasks', encodedList);
}

Future<TaskListState> loadFromPrefs() async {
  SharedPreferences sp = await SharedPreferences.getInstance();
  String encodedLsit = sp.getString('tasks');
  if (encodedLsit != null) {
    Map map = json.decode(encodedLsit);
    return TaskListState.fromJson(map);
  }
  return TaskListState.initialState();
}

void middleware(Store<TaskListState> store, action, NextDispatcher next) async {
  next(action);
  if (action is AddTaskAction || action is RemoveTaskAction) {
    saveToPrefs(store.state);
  }
  if (action is GetTasksAction) {
    await loadFromPrefs().then((state) => store.dispatch(LoadedTasksAction(state.tasks)));
  }
}