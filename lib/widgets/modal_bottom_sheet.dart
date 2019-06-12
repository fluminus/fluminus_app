import 'package:fluminus/file_page.dart';
import 'package:fluminus/util.dart';
import 'package:flutter/material.dart';
import 'package:luminus_api/luminus_api.dart';

Widget fileDetailSheet(BuildContext context, File file,
    {FileStatus status = FileStatus.normal,
    DateTime lastDownloaded,
    Future<void> Function(File) downloadFile,
    Future<void> Function(File) openFile,
    Future<void> Function(File) deleteFile}) {
  List<Widget> content = [];
  var _subtitleStyle = Theme.of(context).textTheme.body1;
  content.addAll([
    ListTile(
      title: Text('File name'),
      subtitle: Text(
        file.fileName,
        style: _subtitleStyle,
      ),
    ),
    ListTile(
      title: Text('File size'),
      subtitle: Text(
        (file.fileSize.toInt() / 1048576).toStringAsFixed(2) + ' MB',
        style: _subtitleStyle,
      ),
    ),
    ListTile(
      title: Text('Last updated at'),
      subtitle: Text(
        datetimeStringToFormattedString(file.lastUpdatedDate),
        style: _subtitleStyle,
      ),
    ),
    ListTile(
      title: Text('Created at'),
      subtitle: Text(
        datetimeStringToFormattedString(file.createdDate),
        style: _subtitleStyle,
      ),
    ),
  ]);
  if (lastDownloaded != null) {
    content.add(ListTile(
      title: Text('Downloaded at'),
      subtitle: Text(
        datetimeToFormattedString(lastDownloaded),
        style: _subtitleStyle,
      ),
    ));
    content.add(RaisedButton(
      color: Theme.of(context).accentColor,
      child: Text(
        'Open File',
      ),
      onPressed: () async {
        await openFile(file);
      },
    ));
    content.add(RaisedButton(
      color: Colors.blueAccent,
      child: Text(
        'Download Again',
      ),
      onPressed: () {
        downloadFile(file);
      },
    ));
    content.add(RaisedButton(
      color: Colors.redAccent,
      child: Text(
        'Delete',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      onPressed: () {
        deleteFile(file);
      },
    ));
  } else {
    content.add(RaisedButton(
      color: Colors.blueAccent,
      child: Text(
        'Download',
      ),
      onPressed: () async {
        await downloadFile(file);
      },
    ));
  }
  return Container(
    color: Colors.transparent,
    child: ListView(
      children: content,
      padding: const EdgeInsets.all(10.0),
    ),
  );
}
