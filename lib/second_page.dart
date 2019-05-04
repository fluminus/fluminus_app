import 'package:flutter/material.dart';
import 'luminus_api.dart';

class Second extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      child: createListView(context)
    );
  }

  Widget createCardWidget(Module module) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.class_),
            title: Text(module.toString()),
            subtitle: Text(module.description),
          ),
        ],
      ),
    );
  }

  Widget createListView(BuildContext context) {
    List<Module> modules = (new API()).modules(new Auth());
    return new ListView.builder(
      itemCount: modules.length,
      itemBuilder: (BuildContext context, int index) {
        return new Column(
          children: <Widget>[createCardWidget(modules[index])],
        );
      },
    );
  }
}
