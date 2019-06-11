import 'dart:async';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:open_file/open_file.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:luminus_api/luminus_api.dart';
import 'package:fluminus/widgets/card.dart' as card;
import 'package:fluminus/widgets/list.dart' as list;
import 'package:fluminus/widgets/common.dart' as common;
import 'package:fluminus/util.dart' as util;
import 'package:fluminus/data.dart' as data;
import 'package:fluminus/widgets/dialog.dart' as dialog;
import 'package:fluminus/db/db_helper.dart' as db;

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

class FilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Files")),
      body: Container(
        child: _paddedfutureBuilder(db.getAllModules(), (context, snapshot) {
          if (snapshot.hasData) {
            return moduleRootDirectoyListView(context, snapshot);
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return common.progressIndicator;
        }),
      ),
    );
  }

  Widget moduleRootDirectoyListView(
      BuildContext context, AsyncSnapshot snapshot) {
    return list.itemListView(snapshot.data,
        (arg) => list.CardType.moduleRootDirectoryCardType, context, null);
  }
}

class ModuleRootDirectoryPage extends StatefulWidget {
  final Module module;

  ModuleRootDirectoryPage(this.module);

  @override
  _ModuleRootDirectoryPageState createState() =>
      _ModuleRootDirectoryPageState();
}

class _ModuleRootDirectoryPageState extends State<ModuleRootDirectoryPage> {
  List<Directory> _directories;
  List<Directory> _refreshedDirectories;
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

  @override
  Widget build(BuildContext context) {
    Future<void> onRefresh() async {
      _refreshedDirectories = await util.onLoading(_refreshController,
          _directories, () => db.refreshAndGetModuleDirectories(widget.module));

      if (_refreshedDirectories == null) {
        _refreshController.refreshFailed();
      } else {
        print('refreshing');
        setState(() {
          _directories = _refreshedDirectories;
        });
        _refreshController.refreshCompleted();
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.module.name),
      ),
      body: _paddedfutureBuilder(db.getModuleDirectories(widget.module),
          (context, snapshot) {
        if (snapshot.hasData) {
          _directories = snapshot.data;
          return list.refreshableListView(
              _refreshController,
              onRefresh,
              _directories,
              (arg) => list.CardType.moduleDirectoryCardType,
              context,
              {"module": widget.module},
              enablePullUp: false);
        } else if (snapshot.hasError) {
          return Text(snapshot.error);
        }
        return common.progressIndicator;
      }),
    );
  }
}

class SubdirectoryPage extends StatefulWidget {
  final String title;
  final Directory parent;

  SubdirectoryPage(this.parent, this.title);

  @override
  _SubdirectoryPageState createState() => _SubdirectoryPageState();
}

enum FileStatus { normal, downloading, downloaded }

class _SubdirectoryPageState extends State<SubdirectoryPage> {
  Future<List<BasicFile>> _fileListFuture;
  Future<Map<BasicFile, FileStatus>> _statusFuture;
  RefreshController _refreshController;
  List<BasicFile> _fileList;
  List<BasicFile> _refreshedFileList;

  @override
  void initState() {
    super.initState();
    _fileListFuture = db.getItemsFromDirectory(widget.parent);
    _statusFuture = _initStatus(_fileListFuture);
    _refreshController = RefreshController();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  // TODO: defer `_initStatus` after rendering out the list of files to optimize performance
  Future<Map<BasicFile, FileStatus>> _initStatus(
      Future<List<BasicFile>> list) async {
    var t = await list;
    Map<BasicFile, FileStatus> map = new Map();
    for (var file in t) {
      if (!(file is File)) continue;
      if (await db.getFileLocation(file) == null) {
        map[file] = FileStatus.normal;
      } else {
        map[file] = FileStatus.downloaded;
      }
    }
    return map;
  }

  Future<void> updateStatus(File file, FileStatus status) async {
    var t = await _statusFuture;
    if (!t.containsKey(file)) {
      // TODO: error handling
    } else {
      setState(() {
        t[file] = status;
      });
    }
  }

  Future<FileStatus> getStatus(File file) async {
    var t = await _statusFuture;
    if (!t.containsKey(file)) {
      // TODO: error handling
      throw Error();
    } else {
      return t[file];
    }
  }

  Future<void> downloadFile(
      File file, Map<BasicFile, FileStatus> statusMap) async {
    var loc = await db.getFileLocation(file);
    if (loc == null) {
      try {
        // TODO: use once instance of Dio
        Dio dio = Dio();
        var dir = await getApplicationDocumentsDirectory();
        var url = await API.getDownloadUrl(await data.authentication(), file);
        // TODO: compose a meaningful path
        var path = join(dir.path, file.fileName);
        await dio.download(url, path, onReceiveProgress: (rec, total) {
          // print("Rec: $rec , Total: $total");
          updateStatus(file, FileStatus.downloading);
        });
        await db.updateFileLocation(file, path, DateTime.now());
        updateStatus(file, FileStatus.downloaded);
      } catch (e) {
        // TODO: error handling
        print(e);
      }
    } else {
      updateStatus(file, FileStatus.downloaded);
      print('cached file loc');
    }
  }

  Future<void> openFile(File file) async {
    var fullPath = await db.getFileLocation(file);
    try {
      await OpenFile.open(fullPath);
    } catch (e) {
      // TODO: error handling
      print(e);
      // TODO: support opening files in other apps
      // dialog.displayUnsupportedFileTypeDialog(e.toString(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    Future<void> onRefresh() async {
      try {
        _refreshedFileList = await util.onLoading(_refreshController, _fileList,
            () => db.refreshAndGetItemsFromDirectory(widget.parent));
        print('refreshed');
        setState(() {
          _fileList = _refreshedFileList;
          _fileListFuture = Future.value(_refreshedFileList);
        });
        _refreshController.refreshCompleted();
      } catch (e) {
        print(e);
        _refreshController.refreshFailed();
      }
    }

    return Scaffold(
      floatingActionButton: _backToHomeFloatingActionButton(context),
      appBar: AppBar(
        title: Text(this.widget.title),
      ),
      body: _paddedfutureBuilder(
          Future.wait([_fileListFuture, _statusFuture]).then((response) => {
                'listFuture': response[0],
                'statusFuture': response[1]
              }), (context, snapshot) {
        if (snapshot.hasData) {
          // TODO: it looks like when refreshed this widget is rebuilt twice...
          _fileList = snapshot.data['listFuture'];
          Map<BasicFile, FileStatus> statusMap = snapshot.data['statusFuture'];
          return list.refreshableListView(
              _refreshController,
              onRefresh,
              _fileList,
              (BasicFile arg) => arg is File
                  ? list.CardType.fileCardType
                  : list.CardType.directoryCardType,
              context,
              {
                'status': statusMap,
                'downloadFile': downloadFile,
                'openFile': openFile
              },
              enablePullUp: false);
        } else if (snapshot.hasError) {
          return Text(snapshot.error);
        }
        return common.progressIndicator;
      }),
    );
  }

  Widget fileCardWidget(
      File file, Map<BasicFile, FileStatus> statusList, BuildContext context,
      {Icon trailing}) {
    FileStatus status;
    Icon normal = Icon(Icons.attach_file);
    Icon downloaded = Icon(Icons.done);
    Icon downloading = Icon(Icons.cloud_download);
    Icon getFileCardIcon() {
      if (statusList.containsKey(file)) {
        status = statusList[file];
        switch (status) {
          case FileStatus.normal:
            return normal;
          case FileStatus.downloaded:
            return downloaded;
          case FileStatus.downloading:
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
        file.name, util.formatLastUpdatedTime(file.lastUpdatedDate), context,
        () {
      if (status == FileStatus.normal) {
        downloadFile(file, statusList);
      } else if (status == FileStatus.downloaded) {
        openFile(file);
      }
    }, leading: getFileCardIcon());
  }

  // try this; https://stackoverflow.com/questions/52021205/usage-of-futurebuilder-with-setstate
  Widget fileListView(BuildContext context, List fileList, Map statusMap) {
    // _initFileState(snapshot.data);
    return new ListView.builder(
      itemCount: fileList.length,
      itemBuilder: (BuildContext context, int index) {
        return new Column(
          children: <Widget>[
            fileList[index] is File
                ? fileCardWidget(fileList[index], statusMap, context)
                : card.directoryCard(fileList[index], context)
          ],
        );
      },
    );
  }
}
