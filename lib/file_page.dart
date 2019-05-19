import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:open_file/open_file.dart';
import 'package:luminus_api/luminus_api.dart';
import 'package:fluminus/widgets/card.dart' as card;
import 'package:fluminus/util.dart' as util;
import 'package:fluminus/data.dart' as data;
import 'package:fluminus/widgets/dialog.dart' as dialog;

final EdgeInsets _padding = const EdgeInsets.fromLTRB(14.0, 10.0, 14.0, 0.0);

FloatingActionButton _backToHomeFloatingActionButton(BuildContext context) {
  return FloatingActionButton(
    child: Icon(Icons.home),
    onPressed: () {
      // Pop to the front page
      // reference: https://stackoverflow.com/questions/49672706/flutter-navigation-pop-to-index-1
      Navigator.popUntil(
          context, ModalRoute.withName(Navigator.defaultRouteName));
    },
  );
}

Widget _paddedfutureBuilder(Future future, AsyncWidgetBuilder builder) {
  return Padding(
    padding: _padding,
    child: FutureBuilder(future: future, builder: builder),
  );
}

GestureTapCallback _onTapNextPage(Widget nextPage, BuildContext context) {
  return () => {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return nextPage;
        }))
      };
}

String _formatLastUpdatedTime(String lastUpdatedTime) {
  return 'Last updated: ' +
      util.datetimeStringToFormattedString(lastUpdatedTime);
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
      body: _paddedfutureBuilder(
          API.getModuleDirectories(data.authentication, module),
          (context, snapshot) {
        if (snapshot.hasData) {
          return fileListView(context, snapshot);
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
      }),
    );
  }

  Widget directoryCardWidget(Directory dir, BuildContext context) {
    Widget nextPage = SubdirectoryPage(dir, module.name + ' - ' + dir.name);

    return card.inkWellCard(
        dir.name,
        _formatLastUpdatedTime(dir.lastUpdatedDate),
        context,
        _onTapNextPage(nextPage, context),
        leading: Icon(Icons.folder));
  }

  Widget fileListView(BuildContext context, AsyncSnapshot snapshot) {
    List<Directory> values = snapshot.data;
    return new ListView.builder(
      itemCount: values.length,
      itemBuilder: (BuildContext context, int index) {
        return new Column(
          children: <Widget>[directoryCardWidget(values[index], context)],
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
    Future<String> url = API.getDownloadUrl(data.authentication, file);
    return _FileDownloadPageState(url, filename);
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
        // print("Rec: $rec , Total: $total");

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
    var fullPath = dir.path + '/' + filename;
    print(fullPath);
    try {
      await OpenFile.open(fullPath);
    } catch (e) {
      // TODO: support opening files in other apps
      dialog.displayUnsupportedFileTypeDialog(e.toString(), context);
    }
  }
}

class SubdirectoryPage extends StatefulWidget {
  final String title;
  final Directory parent;

  SubdirectoryPage(this.parent, this.title);

  @override
  _SubdirectoryPageState createState() => _SubdirectoryPageState();
}

class _SubdirectoryPageState extends State<SubdirectoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _backToHomeFloatingActionButton(context),
      appBar: AppBar(
        title: Text(this.widget.title),
      ),
      body: _paddedfutureBuilder(
          API.getItemsFromDirectory(data.authentication, widget.parent),
          (context, snapshot) {
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
      }),
    );
  }

  Widget directoryCardWidget(Directory dir, BuildContext context) {
    Widget nextPage = SubdirectoryPage(dir, dir.name);
    return card.inkWellCard(
        dir.name,
        _formatLastUpdatedTime(dir.lastUpdatedDate),
        context,
        _onTapNextPage(nextPage, context),
        leading: Icon(Icons.folder),
        trailing: Icon(Icons.arrow_right));
  }

  Widget fileCardWidget(File file, BuildContext context, {Icon trailing}) {
    // TODO: null is bad!

    Widget nextPage = FileDownloadPage(file, file.fileName);
    return card.inkWellCard(
        file.name,
        _formatLastUpdatedTime(file.lastUpdatedDate),
        context,
        _onTapNextPage(nextPage, context),
        leading: Icon(Icons.attach_file),
        trailing: trailing);
  }

  Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
    List<BasicFile> items = snapshot.data;
    return new ListView.builder(
      itemCount: items.length,
      itemBuilder: (BuildContext context, int index) {
        return new Column(
          children: <Widget>[
            items[index] is File
                ? fileCardWidget(items[index], context)
                : directoryCardWidget(items[index], context)
          ],
        );
      },
    );
  }
}

class FilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Files")),
      body: Container(
        decoration: new BoxDecoration(
            // borderRadius: new BorderRadius.circular(20.0),
            color: Colors.white),
        child: _paddedfutureBuilder(API.getModules(data.authentication),
            (context, snapshot) {
          if (snapshot.hasData) {
            return moduleRootDirectoyListView(context, snapshot);
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
        }),
      ),
    );
  }

  Widget moduleRootDirectoryCard(Module module, BuildContext context) {
    Widget nextPage = ModuleRootDirectoryPage(module);
    return card.inkWellCard(
      module.name,
      module.courseName,
      context,
      _onTapNextPage(nextPage, context),
      leading: Icon(Icons.class_),
    );
  }

  Widget moduleRootDirectoyListView(
      BuildContext context, AsyncSnapshot snapshot) {
    List<Module> values = snapshot.data;
    return new ListView.builder(
      itemCount: values.length,
      itemBuilder: (BuildContext context, int index) {
        return new Column(
          children: <Widget>[moduleRootDirectoryCard(values[index], context)],
        );
      },
    );
  }
}
