import 'package:flutter/material.dart';
import 'card_scroll_widget.dart';
import 'data.dart';

class Third extends StatefulWidget {
  @override
  _ThirdState createState() => new _ThirdState();
}

class _ThirdState extends State<Third> {
  var currentPage = images.length - 1.0;

  @override
  Widget build(BuildContext context) {
    PageController controller = PageController(initialPage: images.length - 1);
    controller.addListener(() {
      setState(() {
        currentPage = controller.page;
      });
    });

    return Container(
      color: Colors.white,
      child: new SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.fromLTRB(
            8.0, 35.0, 8.0, 20000.0), // try and fix this number later
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                CardScrollWidget(currentPage),
                Positioned.fill(
                  child: PageView.builder(
                    itemCount: images.length,
                    controller: controller,
                    reverse: true,
                    itemBuilder: (context, index) {
                      // make the cards clickable
                      return InkWell(
                        child: Container(),
                        onTap: () {
                          print(index);
                        },
                      );
                    },
                  ),
                )
              ],
            ),
          ],
        ),
      )),
    );
  }
}
