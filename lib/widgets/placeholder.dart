import 'package:flutter/material.dart';

Widget placeholder() {
  return Center(
    child: Column(
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          height: 100.0,
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Text(
              "Oops!\nYou found me (´；ω；`)",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0),
            child: Text(
              'This page is currently under construction... You are welcome to take a look later =)',
              textAlign: TextAlign.justify,
            ),
          ),
        ),
        Expanded(
          child: Container(
            width: double.infinity,
            child: DecoratedBox(
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: AssetImage('assets/404.gif'),
              )),
            ),
          ),
        ),
        Container(
          height: 100.0,
        )
      ],
    ),
  );
}
