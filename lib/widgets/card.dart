import 'package:flutter/material.dart';
import 'package:luminus_api/luminus_api.dart';
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
    {Icon leading, Icon trailing}) {
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

Widget inkWellCardWithFutureBuilder(String title, String subtitle, BuildContext context,
    GestureTapCallback onTap,
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

Widget announcementCard(Announcement announcemnt, BuildContext context) {
    String title = announcemnt.title;
    String subtitle = "Expire After: " +
        util.datetimeToFormattedString(DateTime.parse(announcemnt.expireAfter));
    String body = util.parsedHtmlText(announcemnt.description);
    return infoCardWithFullBody(title, subtitle, body, context);
    // return card.infoCardWithFixedHeight(title, subtitle, body, context);
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
    return inkWellCard(
        dir.name,
        util.formatLastUpdatedTime(dir.lastUpdatedDate),
        context,
        util.onTapNextPage(nextPage, context),
        leading: Icon(Icons.folder));
  }

  Widget directoryCard(Directory dir, BuildContext context) {
    Widget nextPage = SubdirectoryPage(dir, dir.name);
    return inkWellCard(
        dir.name,
        util.formatLastUpdatedTime(dir.lastUpdatedDate),
        context,
        util.onTapNextPage(nextPage, context),
        leading: Icon(Icons.folder),
        trailing: Icon(Icons.arrow_right));
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





// Widget infoCardWithFixedHeight(
//     String title, String subtitle, String body, BuildContext context) {
//   return Card(
//     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
//     elevation: 3.0,
//     child: Padding(
//       padding: const EdgeInsets.all(3.0),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: <Widget>[
//           ListTile(
//             title: Text(title),
//             subtitle: Text(subtitle),
//           ),
//           Container(
//             height: 30.0,
//             width: double.infinity, // This is hacky... I should've used SizedBox.expand here.
//             child: Padding(
//               padding: const EdgeInsets.only(left: 16.0, right: 16.0),
//               child: Text(_getExcerpt(body), textAlign: TextAlign.justify,),
//             ),
//           )
//         ],
//       ),
//     ),
//   );
// }
