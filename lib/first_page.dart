import 'dart:async';
import 'package:flutter/material.dart';
import 'post_services.dart';

class First extends StatelessWidget {
  final Future<List<Photos>> photos = fetchPhotos();

  First({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: Center(
          child: FutureBuilder<List<Photos>> (
            future: photos,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return createListView(context, snapshot);
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              // By default, show a loading spinner
              return CircularProgressIndicator();
            },
          ),
        ),
    );
  }

  Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
    List<Photos> values = snapshot.data;
    return new ListView.builder(
        itemCount: values.length,
        itemBuilder: (BuildContext context, int index) {
          return new Column(
            children: <Widget>[
              new ListTile(
                title: Image.network(values[index].thumbnailUrl),
              ),
              new Divider(height: 2.0,),
            ],
          );
        },
    );
  }
}