import 'package:fluminus/model/task_list_model.dart';
import 'package:fluminus/redux/store.dart';
import 'package:flutter/material.dart';
import 'package:fluminus/redux/actions.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux_dev_tools/flutter_redux_dev_tools.dart';
import 'package:collection/collection.dart';
import 'package:fluminus/widgets/card.dart' as card;
import 'package:fluminus/util.dart' as util;
import 'data.dart' as data;

class TaskPage extends StatelessWidget {
  Widget taskListView(List<Task> taskList, BuildContext context) {
    List<Task> sortedTaskList = new List.of(taskList);
    sortedTaskList.sort((x, y) => x.date.compareTo(y.date));
    Map<int, List<Task>> tasksListByWeekNum =
        groupBy(sortedTaskList, (task) => task.weekNum);
    List<Widget> headers = weekHeaders(data.smsStartDate, context);
    List<int> keys = tasksListByWeekNum.keys.toList();
    keys.sort((x, y) => x - y);
    return CustomScrollView(slivers: <Widget>[
      SliverList(
          delegate: SliverChildListDelegate(keys.map((weekNum) {
        return sideHeaderListView(
            tasksListByWeekNum[weekNum], headers[weekNum], context);
      }).toList()))
    ]);
  }

  Widget sideHeaderListView(
      List<Task> tasks, Widget header, BuildContext context) {
    return SideHeaderListView(
      itemCount: tasks.length,
      padding: const EdgeInsets.only(top: 10.0, left: 25.0, right: 10.0, bottom: 10.0),
      itemExtend: 90.0,
      header: header,
      headerBuilder: (BuildContext context, int index) {
        return new SizedBox(
            width: 50.0,
            child: new Text(
              tasks[index].dayOfWeek,
              style: Theme.of(context).textTheme.body1,
            ));
      },
      itemBuilder: (BuildContext context, int index) {
        return card.taskCard(tasks[index], context, null);
      },
      hasSameHeader: (int a, int b) {
        return tasks[a].dayOfWeek == tasks[b].dayOfWeek;
      },
    );
  }

  List<Widget> weekHeaders(DateTime smsStartDate, BuildContext context) {
    List<Widget> weekHeaders = new List();
    int totalWeeks = 18;
    int weekNum = smsStartDate.month == 8 ? 0 : 1;
    String info;
    DateTime startDate = smsStartDate;
    DateTime endDate = smsStartDate.add(new Duration(days: 7));
    for (int i = weekNum; i <= totalWeeks; i++, weekNum++) {
      if (weekNum == 7) {
        info = "Recess Week";
        weekNum--;
      } else if (weekNum == 14) {
        info = "Reading Week";
      } else if (weekNum > 14 && weekNum <= 16) {
        info = "Examination";
      } else if (weekNum > 16) {
        info = "Vacation";
      } else {
        info = "Week $weekNum";
      }
      weekHeaders.add(new Container(
        padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0, bottom: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, 
        children: <Widget>[
          Text(
            info,
            style: Theme.of(context).textTheme.caption,
          ),
          Text(
            util.formatTowDates(startDate, endDate),
            style: Theme.of(context).textTheme.subtitle,
            textAlign: TextAlign.right,
          )
        ],
      )));
      startDate = startDate.add(new Duration(days: 8));
      endDate = startDate.add(new Duration(days: 7));
    }
    return weekHeaders;
  }

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
                    return taskListView(store.state.tasks, context);
                  }),
        ),
        drawer: Container(child: ReduxDevTools(store)),
      ),
    );
  }
}

/**
 *  SideHeaderListView for Flutter
 *
 *  Copyright (c) 2017 Rene Floor
 *
 *  Released under BSD License.
 */

typedef HasSameHeader = bool Function(int a, int b);

class SideHeaderListView extends StatefulWidget {
  final int itemCount;
  final Widget header;
  final IndexedWidgetBuilder headerBuilder;
  final IndexedWidgetBuilder itemBuilder;
  final EdgeInsets padding;
  final HasSameHeader hasSameHeader;
  final itemExtend;

  SideHeaderListView({
    Key key,
    this.itemCount,
    @required this.header,
    @required this.itemExtend,
    @required this.headerBuilder,
    @required this.itemBuilder,
    @required this.hasSameHeader,
    this.padding,
  }) : super(key: key);

  @override
  _SideHeaderListViewState createState() => new _SideHeaderListViewState();
}

class _SideHeaderListViewState extends State<SideHeaderListView> {
  int currentPosition = 0;

  @override
  Widget build(BuildContext context) {
    return 
    Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
        widget.header,
        new Stack(
      children: <Widget>[
        new Positioned(
          child: new Opacity(
            opacity: _shouldShowHeader(currentPosition) ? 0.0 : 1.0,
            child: widget.headerBuilder(
                context, currentPosition >= 0 ? currentPosition : 0),
          ),
          top: 0.0 + (widget.padding?.top ?? 0),
          left: 0.0 + (widget.padding?.left ?? 0),
        ),
        
       
          ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            padding: widget.padding,
            itemCount: widget.itemCount,
            itemExtent: widget.itemExtend,
            controller: _getScrollController(),
            itemBuilder: (BuildContext context, int index) {
              return new Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new FittedBox(
                    child: new Opacity(
                      opacity: _shouldShowHeader(index) ? 1.0 : 0.0,
                      child: widget.headerBuilder(context, index),
                    ),
                  ),
                  new Expanded(child: widget.itemBuilder(context, index))
                ],
              );
            }),
        ],
    )],);
  }

  bool _shouldShowHeader(int position) {
    if (position < 0) {
      return true;
    }
    if (position == 0 && currentPosition < 0) {
      return true;
    }
    if (position != 0 &&
        position != currentPosition &&
        !widget.hasSameHeader(position, position - 1)) {
      return true;
    }

    if (position != widget.itemCount - 1 &&
        !widget.hasSameHeader(position, position + 1) &&
        position == currentPosition) {
      return true;
    }
    return false;
  }

  ScrollController _getScrollController() {
    var controller = new ScrollController();
    controller.addListener(() {
      var pixels = controller.offset;
      var newPosition = (pixels / widget.itemExtend).floor();

      if (newPosition != currentPosition) {
        setState(() {
          currentPosition = newPosition;
        });
      }
    });
    return controller;
  }
}
