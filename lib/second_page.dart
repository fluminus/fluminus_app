import 'package:flutter/material.dart';
import 'luminus_api.dart';

class Second extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future<List<Module>> modules = (new API()).modules(new Auth());

    return new Container(
      child: FutureBuilder<List<Module>>(
        future: modules,
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            return createListView(context, snapshot);
          } else if(snapshot.hasError) {
            return Text("Error");
          }
          return CircularProgressIndicator();
        },
      )
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

  Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
    List<Module> values = snapshot.data;
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
