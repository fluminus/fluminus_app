import 'package:flutter/material.dart';
import 'package:luminus_api/luminus_api.dart';

import 'data.dart' as Data;

class ModulePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
        decoration: new BoxDecoration(
            // borderRadius: new BorderRadius.circular(20.0),
            color: Colors.white),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: FutureBuilder<List<Module>>(
            future: Data.getModules(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return createListView(context, snapshot);
              } else if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }
              return Center(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: CircularProgressIndicator(),
                    ),
                  ],
                ),
              );
            },
          ),
        ));
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

  static List<Module> values;

  Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
    values = snapshot.data;
    return new ListView.builder(
      itemCount: values.length,
      itemBuilder: (BuildContext context, int index) {
        return new Column(
          children: <Widget>[createCardWidget(values[index])],
        );
      },
    );
  }
}
