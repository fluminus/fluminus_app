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
  content.addAll([
    ListTile(
      title: Text('File name'),
      subtitle: Text(file.fileName),
    ),
    ListTile(
      title: Text('File size'),
      subtitle:
          Text((file.fileSize.toInt() / 1048576).toStringAsFixed(2) + ' MB'),
    ),
    ListTile(
      title: Text('Last updated at'),
      subtitle: Text(datetimeStringToFormattedString(file.lastUpdatedDate)),
    ),
    ListTile(
      title: Text('Created at'),
      subtitle: Text(datetimeStringToFormattedString(file.createdDate)),
    ),
  ]);
  if (lastDownloaded != null) {
    content.add(ListTile(
      title: Text('Downloaded at'),
      subtitle: Text(datetimeToFormattedString(lastDownloaded)),
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
