import 'package:flutter/material.dart';

import 'luminus_api/module_response.dart';
import 'luminus_api/file_response.dart';
import 'luminus_api/luminus_api.dart';

import 'data.dart' as Data;

class ModuleRootDirectoryPage extends StatelessWidget {
  final Module module;

  ModuleRootDirectoryPage(this.module);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(module.name),
      ),
      body: FutureBuilder(
        future: API.getModuleDirectories(API.myAuth, module),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return createListView(context, snapshot);
          } else if (snapshot.hasError) {
            return Text(snapshot.error);
          }
          return Center(
              child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: CircularProgressIndicator(),
              ),
            ],
          ));
        },
      ),
    );
  }

  Widget createDirectoryCardWidget(Directory dir, BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          InkWell(
            onTap: () => {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    // TODO: For longer directory names this may overflow...
                    return SubdirectoryPage(
                        dir, module.name + ' - ' + dir.name);
                  }))
                },
            child: ListTile(
              leading: Icon(Icons.class_),
              title: Text(dir.name),
              subtitle: Text(
                // TODO: Parse the date and time into something meaningful
                dir.lastUpdatedDate,
                style: TextStyle(fontSize: 13.0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
    List<Directory> values = snapshot.data;
    return new ListView.builder(
      itemCount: values.length,
      itemBuilder: (BuildContext context, int index) {
        return new Column(
          children: <Widget>[createDirectoryCardWidget(values[index], context)],
        );
      },
    );
  }
}

class SubdirectoryPage extends StatelessWidget {
  final String title;
  final Directory parent;
  SubdirectoryPage(this.parent, this.title);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.title),
      ),
      body: FutureBuilder(
        future: API.getItemsFromDirectory(API.myAuth, parent),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return createListView(context, snapshot);
          } else if (snapshot.hasError) {
            return Text(snapshot.error);
          }
          return Center(
              child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: CircularProgressIndicator(),
              ),
            ],
          ));
        },
      ),
    );
  }

  Widget createDirectoryCardWidget(Directory dir, BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          InkWell(
            onTap: () => {},
            child: ListTile(
              leading: Icon(Icons.class_),
              title: Text(dir.name),
              subtitle: Text(
                // TODO: Parse the date and time into something meaningful
                dir.lastUpdatedDate,
                style: TextStyle(fontSize: 13.0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget createFileCardWidget(File file, BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          InkWell(
            onTap: () => {},
            child: ListTile(
              leading: Icon(Icons.class_),
              title: Text(file.name),
              subtitle: Text(
                file.lastUpdatedDate,
                style: TextStyle(fontSize: 13.0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
    // List<Directory> dirs = snapshot.data;
    List<BasicFile> items = snapshot.data;
    return new ListView.builder(
      itemCount: items.length,
      itemBuilder: (BuildContext context, int index) {
        return new Column(
          children: <Widget>[
            items[index] is File
                ? createFileCardWidget(items[index], context)
                : createDirectoryCardWidget(items[index], context)
          ],
        );
      },
    );
  }
}

class FilePage extends StatelessWidget {
  // var _listviewHeight = 1000.0;

  @override
  Widget build(BuildContext context) {
    return new Container(
      decoration: new BoxDecoration(
          // borderRadius: new BorderRadius.circular(20.0),
          color: Colors.white),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14.0, 0.0, 14.0, 0.0),
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
      ),
    );
  }

  Widget createCardWidget(Module module, BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          InkWell(
            onTap: () => {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ModuleRootDirectoryPage(module);
                  }))
                },
            child: ListTile(
              leading: Icon(Icons.class_),
              title: Text(module.name),
              subtitle: Text(
                module.courseName,
                style: TextStyle(fontSize: 13.0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
    List<Module> values = snapshot.data;
    return new ListView.builder(
      itemCount: values.length + 1,
      itemBuilder: (BuildContext context, int index) {
        if (index == 0)
          return new Container(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14.0, 40.0, 20.0, 20.0),
              child: Text('File Management',
                  style: TextStyle(
                      fontSize: 30.0,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left),
            ),
          );
        else
          return new Column(
            children: <Widget>[createCardWidget(values[index - 1], context)],
          );
      },
    );
  }
}
