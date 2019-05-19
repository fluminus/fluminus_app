import 'package:flutter/material.dart';
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
        subtitle: Text(subtitle, style: Theme.of(context).textTheme.body1),
      ),
    ),
  );
  return _basicCard(child);
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