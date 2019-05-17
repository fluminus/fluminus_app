import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:open_file/open_file.dart';
import '';
import 'data.dart' as Data;

Widget createCardInkWellWidget(String title, String subtitle, Icon icon,
    BuildContext context, Widget nextPage) {
  return Padding(
    padding: const EdgeInsets.only(left: 5.0, right: 5.0),
    child: Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          InkWell(
            onTap: () => {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return nextPage;
                  }))
                },
            child: ListTile(
              leading: icon,
              title: Text(title),
              subtitle: Text(
                subtitle,
                style: TextStyle(fontSize: 13.0),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

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
    Widget nextPage = SubdirectoryPage(dir, module.name + ' - ' + dir.name);
    return createCardInkWellWidget(
        dir.name, dir.lastUpdatedDate, Icon(Icons.folder), context, nextPage);
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

class FileDownloadPage extends StatefulWidget {
  final File file;
  final String filename;

  FileDownloadPage(this.file, this.filename);

  @override
  _FileDownloadPageState createState() {
    Future<String> url = API.getDownloadUrl(Data.auth, file);
    return _FileDownloadPageState(
        url,
        filename);
  }
}

class _FileDownloadPageState extends State<FileDownloadPage> {
  final Future<String> downloadUrl;
  final String filename;
  bool downloading = false;
  bool completed = false;
  var progressString = "";

  _FileDownloadPageState(this.downloadUrl, this.filename);

  @override
  void initState() {
    super.initState();
    downloadFile();
  }

  Future<void> downloadFile() async {
    Dio dio = Dio();

    try {
      var dir = await getApplicationDocumentsDirectory();
      var url = await downloadUrl;
      await dio.download(url, dir.path + '/' + filename,
          onReceiveProgress: (rec, total) {
        print("Rec: $rec , Total: $total");

        setState(() {
          downloading = true;
          progressString = ((rec / total) * 100).toStringAsFixed(0) + "%";
        });
      });
    } catch (e) {
      print(e);
    }

    setState(() {
      downloading = false;
      completed = true;
      progressString = "Completed";
    });
    print("Download completed");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("File Download"),
      ),
      body: Center(
        child: downloading
            ? Container(
                height: 120.0,
                width: 200.0,
                child: Card(
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircularProgressIndicator(),
                      SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        "Downloading File: $progressString",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      )
                    ],
                  ),
                ),
              )
            : completed
                ? Container(
                    height: 120.0,
                    width: 200.0,
                    child: Column(children: <Widget>[
                      RaisedButton(
                        onPressed: openFile,
                        child: Text("Open"),
                      ),
                      Text("Completed")
                    ]))
                : Text("Initializing"),
      ),
    );
  }

  Future<void> openFile() async {
    var dir = await getApplicationDocumentsDirectory();
    await OpenFile.open(dir.path + '/' + filename);
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
    // TODO: null is bad!
    Widget nextPage = SubdirectoryPage(dir, dir.name);
    return createCardInkWellWidget(
        dir.name, dir.lastUpdatedDate, Icon(Icons.folder), context, nextPage);
  }

  Widget createFileCardWidget(File file, BuildContext context) {
    // TODO: null is bad!
    Widget nextPage = FileDownloadPage(file, file.fileName);
    return createCardInkWellWidget(file.name, file.lastUpdatedDate,
        Icon(Icons.attach_file), context, nextPage);
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
