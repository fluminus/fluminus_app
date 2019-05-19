import 'package:flutter/material.dart';
// import 'package:luminus_api/luminus_api.dart';
// import 'package:fluminus/data.dart' as data;
import 'package:fluminus/widgets/dialog.dart' as dialog;
import 'package:fluminus/widgets/placeholder.dart' as ph;

class TaskPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.explore),
        onPressed: () {
          dialog.displayRefreshTokenDialog(context);
        },
      ),
      body: ph.placeholder(),
    );
  }
}
