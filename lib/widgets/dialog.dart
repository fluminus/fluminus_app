import 'package:flutter/material.dart';

void displayDialog(String title, String content, BuildContext context) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            FlatButton(
              onPressed: () {},
              child: Text('Button'),
            ),
          ],
        );
      });
}

void displayRefreshTokenDialog(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Oops!',
            style: Theme.of(context).textTheme.title,
          ),
          content: Text(
            "It seems that LumiNUS rejected the old authentication token. But that may be fixed by refreshing it, would you give it a try?",
            style: Theme.of(context).textTheme.body1,
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                // refresh token here
              },
              child: Text(
                'OK',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Ignore')),
          ],
        );
      });
}
