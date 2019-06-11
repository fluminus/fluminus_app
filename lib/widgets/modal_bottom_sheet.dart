import 'dart:convert';

import 'package:fluminus/file_page.dart';
import 'package:fluminus/util.dart';
import 'package:flutter/material.dart';
import 'package:luminus_api/luminus_api.dart';
import 'package:groovin_widgets/groovin_widgets.dart';

Widget fileDetailSheet(BuildContext context, File file,
    {FileStatus status = FileStatus.normal, DateTime lastDownloaded}) {
  return Container(
    height: 500.0,
    color: Colors.transparent,
    child: Container(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: ModalDrawerHandle(
            handleColor: Theme.of(context).accentColor,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(14.0),
          child: Text(jsonEncode(file.toJson())),
        ),
        Text('Last download time: ' +
            (lastDownloaded == null
                ? 'not downloaded'
                : datetimeToFormattedString(lastDownloaded)))
      ]),
    ),
  );
}
