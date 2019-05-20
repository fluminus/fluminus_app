import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:open_file/open_file.dart';
import 'package:luminus_api/luminus_api.dart';
import 'package:fluminus/widgets/card.dart' as card;
import 'package:fluminus/widgets/list.dart' as list;
import 'package:fluminus/widgets/common.dart' as common;
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
        return common.processIndicator;
      }),
    );
  }

  Widget fileListView(BuildContext context, AsyncSnapshot snapshot) {
    return list.itemListView(snapshot.data, list.CardType.moduleDirectoryCardType, context, {"module": module});
  }
}

class SubdirectoryPage extends StatefulWidget {
  final String title;
  final Directory parent;

  SubdirectoryPage(this.parent, this.title);

  @override
  _SubdirectoryPageState createState() => _SubdirectoryPageState();
}

enum _FileStatus { normal, downloading, downloaded }

class _SubdirectoryPageState extends State<SubdirectoryPage> {
  Future<List<BasicFile>> _listFuture;
  Future<Map<BasicFile, _FileStatus>> _statusFuture;

  @override
  void initState() {
    super.initState();
    _listFuture = API.getItemsFromDirectory(data.authentication, widget.parent);
    _statusFuture = _initStatus(_listFuture);
  }

  Future<Map<BasicFile, _FileStatus>> _initStatus(
      Future<List<BasicFile>> list) async {
    var t = await list;
    Map<BasicFile, _FileStatus> map = new Map();
    for (var file in t) {
      map[file] = _FileStatus.normal;
    }
    return map;
  }

  Future<void> updateStatus(File file, _FileStatus status) async {
    var t = await _statusFuture;
    if (!t.containsKey(file)) {
      // TODO: error handling
    } else {
      setState(() {
        t[file] = status;
      });
    }
  }

  Future<_FileStatus> getStatus(File file) async {
    var t = await _statusFuture;
    if (!t.containsKey(file)) {
      // TODO: error handling
      throw Error();
    } else {
      return t[file];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _backToHomeFloatingActionButton(context),
      appBar: AppBar(
        title: Text(this.widget.title),
      ),
      body: _paddedfutureBuilder(
          Future.wait([_listFuture, _statusFuture]).then((response) => {
                'listFuture': response[0],
                'statusFuture': response[1]
              }), (context, snapshot) {
        // print('building...');
        if (snapshot.hasData) {
          // print(snapshot.data['statusFuture']);
          return createListView(context, snapshot);
        } else if (snapshot.hasError) {
          return Text(snapshot.error);
        }
        return common.processIndicator;
      }),
    );
  }

  Widget directoryCardWidget(Directory dir, BuildContext context) {
    Widget nextPage = SubdirectoryPage(dir, dir.name);
    return card.inkWellCard(
        dir.name,
        util.formatLastUpdatedTime(dir.lastUpdatedDate),
        context,
        util.onTapNextPage(nextPage, context),
        leading: Icon(Icons.folder),
        trailing: Icon(Icons.arrow_right));
  }

  Future<void> downloadFile(
      File file, Map<BasicFile, _FileStatus> statusList) async {
    // TODO: use once instance of Dio
    Dio dio = Dio();

    try {
      var dir = await getApplicationDocumentsDirectory();
      var url = await API.getDownloadUrl(data.authentication, file);
      await dio.download(url, dir.path + '/' + file.fileName,
          onReceiveProgress: (rec, total) {
        // print("Rec: $rec , Total: $total");
        updateStatus(file, _FileStatus.downloading);
      });
    } catch (e) {
      print(e);
    }
    updateStatus(file, _FileStatus.downloaded);
    // print("Download completed");
  }

  Future<void> openFile(File file) async {
    var dir = await getApplicationDocumentsDirectory();
    var fullPath = dir.path + '/' + file.fileName;
    // print(fullPath);
    try {
      await OpenFile.open(fullPath);
    } catch (e) {
      // TODO: support opening files in other apps
      dialog.displayUnsupportedFileTypeDialog(e.toString(), context);
    }
  }

  Widget fileCardWidget(
      File file, Map<BasicFile, _FileStatus> statusList, BuildContext context,
      {Icon trailing}) {
    _FileStatus status;
    Icon normal = Icon(Icons.attach_file);
    Icon downloaded = Icon(Icons.done);
    Icon downloading = Icon(Icons.cloud_download);
    Icon getFileCardIcon() {
      if (statusList.containsKey(file)) {
        status = statusList[file];
        switch (status) {
          case _FileStatus.normal:
            return normal;
          case _FileStatus.downloaded:
            return downloaded;
          case _FileStatus.downloading:
            return downloading;
          default:
            // TODO: error handling
            return Icon(Icons.error_outline);
        }
      } else {
        // TODO: error handling
        return Icon(Icons.error_outline);
      }
    }
    return card.inkWellCard(
        file.name, util.formatLastUpdatedTime(file.lastUpdatedDate), context, () {
      if (status == _FileStatus.normal) {
        downloadFile(file, statusList);
      } else if (status == _FileStatus.downloaded) {
        openFile(file);
      }
    }, leading: getFileCardIcon());
  }

  // try this; https://stackoverflow.com/questions/52021205/usage-of-futurebuilder-with-setstate
  Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
    // _initFileState(snapshot.data);
    var fileList = snapshot.data['listFuture'];
    var statusMap = snapshot.data['statusFuture'];
    return new ListView.builder(
      itemCount: fileList.length,
      itemBuilder: (BuildContext context, int index) {
        return new Column(
          children: <Widget>[
            fileList[index] is File
                ? fileCardWidget(fileList[index], statusMap, context)
                : directoryCardWidget(fileList[index], context)
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
          return common.processIndicator;
        }),
      ),
    );
  }

  Widget moduleRootDirectoyListView(
      BuildContext context, AsyncSnapshot snapshot) {
    return list.itemListView(snapshot.data, list.CardType.moduleRootDirectoryCardType, context, null);
  }
}