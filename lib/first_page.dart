import 'package:flutter/material.dart';

import 'data.dart' as Data;
import 'luminus_api/profile_response.dart';

class First extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      child: FutureBuilder(
        future: Data.getProfile(),
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            Profile profile = snapshot.data;
            return new Text(profile.userNameOriginal);
          } else if(snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return Center(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: CircularProgressIndicator(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}