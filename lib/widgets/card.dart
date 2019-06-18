import 'package:fluminus/db/db_file.dart';
import 'package:fluminus/widgets/modal_bottom_sheet.dart';
import 'package:fluminus/widgets/theme.dart';
import 'package:flutter/material.dart';
import 'package:luminus_api/luminus_api.dart';
import 'package:fluminus/model/task_list_model.dart';
import 'package:fluminus/new_task_page.dart';
import 'package:fluminus/redux/store.dart';
import 'package:groovin_widgets/groovin_widgets.dart';
import 'package:fluminus/util.dart' as util;

import '../file_page.dart';
// import 'dart:math';

BorderRadius _borderRadius = BorderRadius.circular(16.0);

Widget _basicCard(Widget child) {
  return Card(
    shape: RoundedRectangleBorder(borderRadius: _borderRadius),
    elevation: 3.0,
    child: child,
  );
}

Widget infoCardWithFullBody(
    String title, String subtitle, String body, BuildContext context) {
  return _basicCard(Padding(
    padding: const EdgeInsets.all(3.0),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          title: Text(
            title,
          ),
          subtitle: Text(
            subtitle,
            style: Theme.of(context).textTheme.subtitle,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 20.0),
          child: Text(body.trim()),
        )
      ],
    ),
  ));
}

Widget infoCardWithFixedHeight(
    String title, String subtitle, String body, BuildContext context) {
  return infoCardWithFullBody(title, subtitle, _getExcerpt(body), context);
}

// TODO: Try not to cut words in this function.
String _getExcerpt(String body, {int excerptLength = 100}) {
  String withoutNewline = body.replaceAll('\n', ' ');
  if (withoutNewline.length <= excerptLength) {
    return withoutNewline;
  } else {
    return withoutNewline.substring(0, excerptLength - 1) + ' ...';
  }
}

Widget inkWellCard(String title, String subtitle, BuildContext context,
    GestureTapCallback onTap,
    {Icon leading,
    Icon trailing,
    IconButton leadingButton,
    IconButton trailingButton,
    GestureLongPressCallback onLongPress}) {
  const double _verticalPadding = 6.0;
  Widget child = InkWell(
    borderRadius: _borderRadius,
    onTap: onTap,
    onLongPress: onLongPress,
    child: Padding(
      padding: const EdgeInsets.only(
          top: _verticalPadding, bottom: _verticalPadding),
      child: ListTile(
        leading: leading ?? leadingButton,
        trailing: trailing ?? trailingButton,
        title: Text(title),
        subtitle: Text(subtitle, style: Theme.of(context).textTheme.body1),
      ),
    ),
  );
  return _basicCard(child);
}

Widget inkWellCardWithFutureBuilder(String title, String subtitle,
    BuildContext context, GestureTapCallback onTap,
    {FutureBuilder leading, FutureBuilder trailing}) {
  const double _verticalPadding = 6.0;
  Widget child = InkWell(
    borderRadius: _borderRadius,
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.only(
          top: _verticalPadding, bottom: _verticalPadding),
      child: ListTile(
        leading: leading,
        trailing: trailing,
        title: Text(title),
        subtitle: Text(subtitle, style: TextStyle(fontSize: 13.0)),
      ),
    ),
  );
  return _basicCard(child);
}

Widget moduleCard(Module module, BuildContext context) {
  return Card(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.class_),
          title: Text(module.name),
          subtitle: Text(module.courseName),
        ),
      ],
    ),
  );
}

Widget moduleDirectoryCard(Directory dir, BuildContext context, Module module) {
  Widget nextPage = SubdirectoryPage(dir, module.name + ' - ' + dir.name);
  return inkWellCard(dir.name, util.formatLastUpdatedTime(dir.lastUpdatedDate),
      context, util.onTapNextPage(nextPage, context),
      leading: Icon(Icons.folder));
}

Widget directoryCard(Directory dir, BuildContext context) {
  Widget nextPage = SubdirectoryPage(dir, dir.name);
  return inkWellCard(dir.name, util.formatLastUpdatedTime(dir.lastUpdatedDate),
      context, util.onTapNextPage(nextPage, context),
      leading: Icon(Icons.folder), trailing: Icon(Icons.arrow_right));
}

Widget fileCard(
    File file,
    BuildContext context,
    FileStatus status,
    Map<BasicFile, FileStatus> statusMap,
    Future<void> Function(File, Map<BasicFile, FileStatus>) downloadFile,
    Future<void> Function(File) openFile,
    Future<void> Function(File, Map<BasicFile, FileStatus>) deleteFile) {
  Icon getFileCardIcon() {
    switch (status) {
      case FileStatus.normal:
        return Icon(Icons.attach_file);
      case FileStatus.downloaded:
        return Icon(Icons.done);
      case FileStatus.downloading:
        return Icon(Icons.cloud_download);
      case FileStatus.deleted:
        return Icon(Icons.remove_from_queue);
      default:
        // TODO: error handling
        return Icon(Icons.error_outline);
    }
  }

  return inkWellCard(
      file.name,
      util.formatLastUpdatedTime(file.lastUpdatedDate),
      context,
      () async {
        if (status == FileStatus.normal) {
          await downloadFile(file, statusMap);
        } else if (status == FileStatus.downloaded ||
            status == FileStatus.deleted) {
          await openFile(file);
        }
      },
      leading: getFileCardIcon(),
      onLongPress: () async {
        DateTime lastDownloaded =
            (status == FileStatus.downloaded || status == FileStatus.deleted)
                ? await getLastUpdated(file)
                : null;
        showModalBottomSheet(
            context: context,
            builder: (context) {
              return fileDetailSheet(context, file,
                  lastDownloaded: lastDownloaded,
                  downloadFile: (File file) => downloadFile(file, statusMap),
                  openFile: openFile,
                  deleteFile: (File file) => deleteFile(file, statusMap));
            });
      });
}

Widget moduleRootDirectoryCard(Module module, BuildContext context) {
  Widget nextPage = ModuleRootDirectoryPage(module);
  return inkWellCard(
    module.name,
    module.courseName,
    context,
    util.onTapNextPage(nextPage, context),
    leading: Icon(Icons.class_),
  );
}

Widget paddedRowInfo(
  String label,
  String info,
  EdgeInsetsGeometry padding,
  BuildContext context, {
  TextStyle lableStyle,
  TextStyle infoStyle,
}) {
  return Padding(
      padding: padding,
      child: Row(
        children: <Widget>[Text(label, style: lableStyle), Text(info)],
      ));
}

Widget announcementCard(Announcement announcemnt, BuildContext context) {
  String title = announcemnt.title;
  String subtitle = "Expire After: " +
      util.datetimeToFormattedString(DateTime.parse(announcemnt.expireAfter));
  String body = util.parsedHtmlText(announcemnt.description);
  return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      elevation: 3.0,
      child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            ListTile(
              title: Text(title),
              subtitle: Text(subtitle),
              onTap: () {
                _showDetail(context, title, body);
              },
            ),
            ListTile(
              subtitle: Text(
                body,
                maxLines: 5,
                style: Theme.of(context).textTheme.body1,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () {
                _showDetail(context, title, body);
              },
            )
          ])));
}

void _showDetail(BuildContext context, String title, String fullContent) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        // double width = MediaQuery.of(context).size.width * 6 / 7;
        // double height = MediaQuery.of(context).size.height * 2 / 3;
        // return Container(
        //   width: width,
        //   height: height,
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          elevation: 3.0,
          title: Text(
            title,
            style: Theme.of(context).textTheme.subhead,
          ),
          content: SingleChildScrollView(
            child: Text(
              fullContent,
              style: Theme.of(context).textTheme.body1,
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      });
}

// return card.infoCardWithFixedHeight(title, subtitle, body, context);

Widget taskCard(Task task, BuildContext context) {
  final TextStyle lableStyle = Theme.of(context).textTheme.body2;
  final EdgeInsetsGeometry padding =
      EdgeInsets.only(left: 20, right: 20, bottom: 7);
  final colors = Theme.of(context).brightness == Brightness.light
      ? lightColors
      : darkColors;
  return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: GroovinExpansionTile(
        title: Text(task.title),
        subtitle: Text(task.date),
        boxDecoration: BoxDecoration(
          border: new Border.all(
              color: colors[task.colorIndex],
              width: 2.5,
              style: BorderStyle.solid),
          borderRadius: new BorderRadius.all(new Radius.circular(20.0)),
        ),
        inkwellRadius: _borderRadius,
        children: <Widget>[
          paddedRowInfo('TIME:  ', task.startTime + ' - ' + task.endTime,
              padding, context,
              lableStyle: lableStyle),
          paddedRowInfo('LOCATION:  ', task.location, padding, context,
              lableStyle: lableStyle),
          paddedRowInfo('DETAIL:  ', '', padding, context,
              lableStyle: lableStyle),
          Container(
              padding: padding,
              alignment: Alignment.centerLeft,
              child: Text(task.detail)),
          Row(
            children: <Widget>[
              Expanded(
                  flex: 1,
                  child: FlatButton.icon(
                    icon: Icon(
                      Icons.delete,
                    ),
                    label: Text('DELETE'),
                    onPressed: () => model.onRemoveTask(task),
                  )),
              Expanded(
                  flex: 1,
                  child: FlatButton.icon(
                      icon: Icon(
                        Icons.edit,
                      ),
                      label: Text('EDIT'),
                      onPressed: () => Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return TaskDetail(task);
                          })))),
            ],
          )
        ],
      ));
}
