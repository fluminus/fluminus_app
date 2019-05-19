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
    return SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        controller: _refreshController,
        onRefresh: _onRresh,
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
                        _modules = snapshot.data;
                        _refreshedModules = _modules;
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

  void _onLoading() async {
    _refreshedModules.addAll(await API.getModules(Data.authentication));
    
    if (_refreshedModules == null) {
      print("load: null");
      _refreshController.loadNoData();
    } else {
      print("load: got data");
      _refreshController.loadComplete();
    }
  }

  void _onRresh() {
    print("called");
    print(_modules);
    print(_refreshedModules);
    if (Data.twoListsAreDeepEqual(_modules, _refreshedModules)) {
      print("refresh: no need");
      _refreshController.refreshCompleted();
    } else {
      _modules = _refreshedModules;
      build(context);
      print("Refreshed");
      _refreshController.refreshCompleted();
    }
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }
}
