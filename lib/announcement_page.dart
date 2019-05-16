import 'package:flutter/material.dart';
import 'card_scroll_widget.dart';
import 'data.dart';

class AnnouncementPage extends StatefulWidget {
  @override
  _APState createState() => new _APState();
}

class _APState extends State<AnnouncementPage> {
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
            8.0, 35.0, 8.0, 20.0), // try and fix this number later
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
                      return InkWell(
                        child: Container(),
                        onLongPress: () {
                          _selectDate();
                          //for debug purpose
                          print(selectedDate.toString());
                        }
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

  DateTime selectedDate = DateTime.now();

  Future<Null> _selectDate() async {
    final DateTime pickedDate = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(2018,1,1),
        lastDate: new DateTime(2019,12,31)
    );
    if(pickedDate != null) setState(() => selectedDate = pickedDate);
  }
}


