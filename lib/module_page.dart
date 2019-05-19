import 'package:flutter/material.dart';
import 'package:luminus_api/luminus_api.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'util.dart' as util;
import 'data.dart' as data;

class ModulePage extends StatefulWidget {
  const ModulePage({Key key}) : super(key: key);
  @override
  _ModulePageState createState() => new _ModulePageState();
}

class _ModulePageState extends State<ModulePage> {
  List<dynamic> _modules;
  List<dynamic> _refreshedModules;

  @override
  Widget build(BuildContext context) {
    void updateList(List<dynamic> updatedModules) {
      setState(() {
        _modules = updatedModules;
      });
    }

    Future<void> _onRefresh() async {
      _refreshedModules =
          await util.onLoadingTest(_refreshController, _modules);
      if (_refreshedModules == null) {
        print("failed");
        _refreshController.refreshFailed();
      } else {
        print(_refreshedModules);
        updateList(_refreshedModules);
        _refreshController.refreshCompleted();
      }
    }

    return SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: util.onLoadingTest,
        child: ListView.builder(
            itemCount: 1,
            itemBuilder: (context, index) {
              return FutureBuilder<List<dynamic>>(
                future: API.getModules(data.authentication),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                    case ConnectionState.active:
                      return Align(
                          alignment: Alignment.center,
                          child: data.processIndicator);
                      break;
                    case ConnectionState.done:
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        if (_modules == null) {
                          _modules = snapshot.data;
                        }
                        return moduleList(_modules);
                      }
                      break;
                  }
                },
              );
            }));
  }

  Widget moduleCard(Module module) {
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

  ListView moduleList(List<dynamic> modules) {
    return new ListView.builder(
      shrinkWrap: true,
      itemCount: modules.length,
      itemBuilder: (BuildContext context, int index) {
        return new Column(
          children: <Widget>[moduleCard(modules[index])],
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

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }
}
