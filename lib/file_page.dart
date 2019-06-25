import 'dart:async';
import 'dart:io' as prefix0;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart' as path_dart;
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:open_file/open_file.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'package:luminus_api/luminus_api.dart';
import 'package:fluminus/widgets/list.dart' as list;
import 'package:fluminus/widgets/common.dart' as common;
import 'package:fluminus/util.dart' as util;
import 'package:fluminus/data.dart' as data;
import 'package:fluminus/widgets/dialog.dart' as dialog;
import 'package:fluminus/db/db_helper.dart' as db;

final EdgeInsets _padding = const EdgeInsets.only(left: 14.0, right: 14.0);
Widget _paddedfutureBuilder(Future future, AsyncWidgetBuilder builder) {
  return Padding(
    padding: _padding,
    child: FutureBuilder(future: future, builder: builder),
  );
}

enum _SortMethod {
  normal,
  name,
  lastUpdated,
  createdAt,
  // downloadedAt,
  fileSize
}

Widget _filePageFloatingActionButton(
    BuildContext context, void Function() sort) {
  SpeedDialChild _actionButton(
      {@required IconData icon,
      @required Color backgroundColor,
      @required String label,
      @required void Function() onTap}) {
    return SpeedDialChild(
        child: Icon(icon),
        backgroundColor: backgroundColor,
        label: label,
        labelBackgroundColor: Theme.of(context).backgroundColor,
        labelStyle: Theme.of(context).primaryTextTheme.body1,
        onTap: onTap);
  }

  return SpeedDial(
    animatedIcon: AnimatedIcons.menu_close,
    animatedIconTheme: Theme.of(context).accentIconTheme,
    closeManually: false,
    curve: Curves.bounceIn,
    overlayColor: Colors.black,
    overlayOpacity: 0.5,
    backgroundColor: Theme.of(context).accentColor,
    foregroundColor: Theme.of(context).accentIconTheme.color,
    elevation: 8.0,
    shape: CircleBorder(),
    children: [
      _actionButton(
          icon: Icons.home,
          backgroundColor: Colors.amberAccent,
          label: 'Back to modules',
          onTap: () {
            Navigator.popUntil(
                context, ModalRoute.withName(Navigator.defaultRouteName));
          }),
      _actionButton(
          icon: MdiIcons.sort,
          backgroundColor: Theme.of(context).buttonColor,
          label: 'Sort',
          onTap: () {
            sort();
            // print("sort");
          })
    ],
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
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

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
      try {
        _refreshedDirectories = await util.onLoading(
            _refreshController,
            _directories,
            () => db.refreshAndGetModuleDirectories(widget.module));
        // print('refreshed');
        setState(() {
          _directories = _refreshedDirectories;
        });
        _refreshController.refreshCompleted();
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text('Refreshed'),
          duration: Duration(milliseconds: 500),
        ));
      } catch (e) {
        _refreshController.refreshFailed();
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text('Refresh failed'),
          duration: Duration(seconds: 2),
          action: SnackBarAction(
            label: 'Details',
            onPressed: () {
              dialog.displayDialog('Detail', e.toString(), context);
            },
          ),
        ));
      }
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.module.name),
      ),
      body: _paddedfutureBuilder(
        db.getModuleDirectories(widget.module),
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
        },
      ),
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

enum FileStatus { normal, downloading, downloaded, deleted }

class _SubdirectoryPageState extends State<SubdirectoryPage> {
  Future<List<BasicFile>> _fileListFuture;
  Future<Map<BasicFile, FileStatus>> _statusFuture;
  RefreshController _refreshController;
  List<BasicFile> _fileList;
  List<BasicFile> _refreshedFileList;
  // TODO: store last used sorting method
  _SortMethod _sortMethod = _SortMethod.normal;
  bool _sortAscend = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

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
      FutureOr<List<BasicFile>> list) async {
    var t = await list;
    Map<BasicFile, FileStatus> map = new Map();
    for (var file in t) {
      if (!(file is File)) continue;
      var query = await db.selectFile(file);
      // print(query);
      if (query['file_location'] == null) {
        map[file] = FileStatus.normal;
      } else {
        if (query['deleted'] == 1) {
          map[file] = FileStatus.deleted;
        } else {
          map[file] = FileStatus.downloaded;
        }
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
    /// forced refresh before downloading for edge cases like
    /// if you deleted a file before manually refresh the page
    /// and the file is removed from the server before you try to re-download it
    /// since the file isn't marked deleted in the database
    /// you will receive an error trying to download it
    await refresh();
    if ((await db.selectFile(file)) == null) {
      dialog.displayDialog('Oops', 'This file no longer exists 😱', context);
    } else {
      var loc = await db.getFileLocation(file);
      if (loc == null) {
        Dio dio = Dio();
        try {
          // TODO: use once instance of Dio
          var dir = await getApplicationDocumentsDirectory();
          var url = await API.getDownloadUrl(await data.authentication(), file);
          // TODO: compose a meaningful path
          var path = path_dart.join(dir.path, file.fileName);
          try {
            await dio.download(url, path, onReceiveProgress: (rec, total) {
              // print("Rec: $rec , Total: $total");
              updateStatus(file, FileStatus.downloading);
            });
          } catch (e) {
            // TODO: error handling
            dialog.displayDialog('hehe', e.toString(), context);
            updateStatus(file, FileStatus.normal);
          }
          await db.updateFileLocation(file, path, DateTime.now());
          updateStatus(file, FileStatus.downloaded);
        } catch (e) {
          dialog.displayDialog(
              'Error',
              "Try to pull and refresh the current list.\n\nError message: " +
                  e.toString(),
              context);
        }
      } else {
        updateStatus(file, FileStatus.downloaded);
        // print('cached file loc');
      }
    }
  }

  Future<void> deleteFile(
      File file, Map<BasicFile, FileStatus> statusMap) async {
    var loc = await db.getFileLocation(file);
    if (loc == null) {
      throw Exception("Can't delete a file that doesn't exist");
    } else {
      await prefix0.File(loc).delete();
      await db.deleteDownloadedFile(file);
      var t = await db.getItemsFromDirectory(widget.parent);
      setState(() {
        _fileList = t;
        _fileListFuture = Future.value(_fileList);
      });
      updateStatus(file, FileStatus.normal);
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

  Future<void> refresh() async {
    _refreshedFileList = await util.onLoading(_refreshController, _fileList,
        () => db.refreshAndGetItemsFromDirectory(widget.parent));
    setState(() {
      _fileList = _refreshedFileList;
      _fileListFuture = Future.value(_refreshedFileList);
    });
    _statusFuture = _initStatus(_fileList);
  }

  @override
  Widget build(BuildContext context) {
    Future<void> onRefresh() async {
      try {
        await refresh();
        _refreshController.refreshCompleted();
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text('Refreshed!'),
          duration: Duration(milliseconds: 500),
        ));
        // print('refreshed');
      } catch (e) {
        _refreshController.refreshFailed();
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text('Refresh failed!'),
          duration: Duration(seconds: 2),
          action: SnackBarAction(
            label: 'Details',
            onPressed: () {
              dialog.displayDialog('Detail', e.toString(), context);
            },
          ),
        ));
      }
    }

    void sortItems(BuildContext context,
        {_SortMethod method = _SortMethod.normal, bool isAscend = true}) {
      final c = isAscend ? 1 : -1;
      setState(() {
        int Function(BasicFile, BasicFile) comparator;
        switch (method) {
          case _SortMethod.normal:
            comparator = (BasicFile fileA, BasicFile fileB) =>
                c * fileA.name.compareTo(fileB.name);
            break;
          case _SortMethod.name:
            comparator = (BasicFile fileA, BasicFile fileB) =>
                c * fileA.name.compareTo(fileB.name);
            break;
          case _SortMethod.lastUpdated:
            comparator = (BasicFile fileA, BasicFile fileB) {
              var a = DateTime.parse(fileA.lastUpdatedDate);
              var b = DateTime.parse(fileB.lastUpdatedDate);
              return a.compareTo(b);
            };
            break;
          case _SortMethod.fileSize:
            comparator = (BasicFile fileA, BasicFile fileB) {
              if (fileA is File && fileB is File) {
                return ((fileA.fileSize - fileB.fileSize) * c).toInt();
              } else if (fileA is File && !(fileB is File)) {
                return -1;
              } else if (!(fileA is File) && fileB is File) {
                return 1;
              } else {
                return fileA.name.compareTo(fileB.name);
              }
            };
            break;
          case _SortMethod.createdAt:
            comparator = (BasicFile fileA, BasicFile fileB) {
              var a = DateTime.parse(fileA.createdDate);
              var b = DateTime.parse(fileB.createdDate);
              return a.compareTo(b);
            };
            break;
            break;
          default:
            break;
        }
        _fileList.sort(comparator);
        _fileListFuture = Future.value(_fileList);
      });
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Sorted!'),
        duration: Duration(milliseconds: 500),
      ));
    }

    void showSortMethods() {
      var sms = SortMethodSelect(
        _SortMethod.values,
        onMethodChanged: (selection) {
          setState(() {
            _sortMethod = selection;
            // print(_sortMethod.toString());
          });
        },
        onAscendChanged: (checked) {
          setState(() {
            _sortAscend = checked;
            // print(_sortAscend);
          });
        },
        initAscend: _sortAscend,
        initMethod: _sortMethod,
      );
      showDialog(
          context: context,
          builder: (BuildContext context) {
            //Here we will build the content of the dialog
            return AlertDialog(
              title: Text('Sort Method'),
              content: SingleChildScrollView(
                child: sms,
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text("Confirm"),
                  onPressed: () {
                    sortItems(context,
                        method: _sortMethod, isAscend: _sortAscend);
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    }

    return Scaffold(
      key: _scaffoldKey,
      floatingActionButton:
          _filePageFloatingActionButton(context, showSortMethods),
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
                'openFile': openFile,
                'deleteFile': deleteFile
              },
              enablePullUp: false);
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        return common.progressIndicator;
      }),
    );
  }
}

class SortMethodSelect extends StatefulWidget {
  final List<_SortMethod> choices;
  final Function(_SortMethod) onMethodChanged;
  final Function(bool) onAscendChanged;
  bool initAscend;
  _SortMethod initMethod;
  SortMethodSelect(
    this.choices, {
    @required this.onMethodChanged,
    @required this.onAscendChanged,
    @required this.initAscend,
    @required this.initMethod,
  });
  @override
  _SortMethodSelectState createState() =>
      _SortMethodSelectState(initMethod, initAscend);
}

class _SortMethodSelectState extends State<SortMethodSelect> {
  _SortMethod selectedChoice;
  bool checked;
  _SortMethodSelectState(this.selectedChoice, this.checked);
  // this function will build and return the choice list
  _buildChoiceList() {
    List<Widget> choices = List();
    widget.choices.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: ChoiceChip(
          selectedColor: Theme.of(context).accentColor,
          label: Text(describeEnum(item)),
          selected: selectedChoice == item,
          onSelected: (selected) {
            setState(() {
              selectedChoice = item;
              widget.onMethodChanged(selectedChoice);
            });
          },
        ),
      ));
    });
    return choices;
  }

  @override
  Widget build(BuildContext context) {
    var checkbox = Row(
      children: <Widget>[
        Checkbox(
          checkColor: Theme.of(context).backgroundColor,
          activeColor: Theme.of(context).accentColor,
          onChanged: (bool value) {
            setState(() {
              checked = value;
              widget.onAscendChanged(value);
            });
          },
          value: checked,
        ),
        Text('In ascending order')
      ],
    );
    return Column(
      children: <Widget>[
        Wrap(
          children: _buildChoiceList(),
        ),
        checkbox,
      ],
    );
  }
}
