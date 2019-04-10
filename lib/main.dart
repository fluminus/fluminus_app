import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'post_services.dart';

void main() => runApp(MyApp(photos: fetchPhotos()));

class MyApp extends StatelessWidget {
  final Future<List<Photos>> photos;

  MyApp({Key key, this.photos}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Fetch Data Example'),
        ),
        body: Center(
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