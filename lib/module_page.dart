import 'package:flutter/material.dart';
import 'package:luminus_api/luminus_api.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'data.dart' as Data;

class ModulePage extends StatefulWidget {
  const ModulePage({Key key}) : super(key: key);
  @override
  _ModulePageState createState() => new _ModulePageState();
}

class _ModulePageState extends State<ModulePage> {
  List<Module> _modules;
  List<Module> _refreshedModules;

  @override
  Widget build(BuildContext context) {
    void updateList(List<Module> updatedModules) {
      setState(() {
        _modules = updatedModules;
      });
    }

    Future<void> _onRefresh() async {
      bool needToRefresh = await _onLoading();
      if (needToRefresh) {
        if (_refreshedModules == null) {
          _refreshController.refreshFailed();
        } else {
          updateList(_refreshedModules);
        }
      }
      _refreshController.refreshCompleted();
    }

    return SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: ListView.builder(
            itemCount: 1,
            itemBuilder: (context, index) {
              return FutureBuilder<List<Module>>(
                future: API.getModules(Data.authentication),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                    case ConnectionState.active:
                      return Align(
                          alignment: Alignment.center,
                          child: Data.processIndicator);
                      break;
                    case ConnectionState.done:
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        if (_modules == null) {
                          _modules = snapshot.data;
                        }
                        return createListView(_modules);
                      }
                      break;
                  }
                },
              );
            }));
  }

  Widget createCardWidget(Module module) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.class_),
            title: Text(module.name),
            subtitle: Text(module.courseName),
          ),
        ],
      ),
    );
  }

  ListView createListView(List<Module> modules) {
    return new ListView.builder(
      shrinkWrap: true,
      itemCount: modules.length,
      itemBuilder: (BuildContext context, int index) {
        return new Column(
          children: <Widget>[createCardWidget(modules[index])],
        );
      },
    );
  }

  RefreshController _refreshController;

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController();
  }

  Future<bool> _onLoading() async {
    List<Module> temp = new List();
    temp.add(_modules[0]);
    _refreshedModules = temp;
    if (Data.twoListsAreDeepEqual(_modules, _refreshedModules)) {
      print("load no data");
      _refreshController.loadNoData();
      return false;
    } else {
      print("load: got data");
      _refreshController.loadComplete();
      return true;
    }
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }
}
