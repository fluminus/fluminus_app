import 'package:flutter/material.dart';
import 'package:luminus_api/luminus_api.dart';
import 'dart:math';
import 'data.dart' as Data;

var cardAspectRatio = 12.0 / 16.0;
var widgetAspectRatio = cardAspectRatio * 1.2;

class CardScrollWidget extends StatelessWidget {
  final double currentPage;
  final double padding = 20.0;
  final double verticalInset = 20.0;
 
  

  CardScrollWidget(this.currentPage);
  @override
  Widget build(BuildContext context) {
    //写得不太好这种方法虽然方便
    Data.getAllAnnouncements();
    List<Announcement> announcements = Data.announcements;
    
    return new AspectRatio(
      aspectRatio: widgetAspectRatio,
      child: LayoutBuilder(builder: (context, contraints) {
        var width = contraints.maxWidth;
        var height = contraints.maxHeight;

        var safeWidth = width - 2 * padding;
        var safeHeight = height - 2 * padding;

        var heightOfPrimaryCard = safeHeight;
        var widthOfPrimaryCard = heightOfPrimaryCard * cardAspectRatio;

        var primaryCardLeft = safeWidth - widthOfPrimaryCard;
        var horizontalInset = primaryCardLeft / 2;

        List<Widget> cardList = new List();
        
        for (var i = 0; i < announcements.length; i++) {
          var delta = i - currentPage;
          bool isOnRight = delta > 0;

          var start = padding +
              max(
                  primaryCardLeft -
                      horizontalInset * -delta * (isOnRight ? 15 : 1),
                  0.0);

          var cardItem = Positioned.directional(
            top: padding + verticalInset * max(-delta, 0.0),
            bottom: padding + verticalInset * max(-delta, 0.0),
            start: start,
            textDirection: TextDirection.rtl,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: Container(
                decoration: BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                      color: Colors.black12,
                      offset: Offset(3.0, 6.0),
                      blurRadius: 10.0)
                ]),
                child: AspectRatio(
                  aspectRatio: cardAspectRatio,
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      Image.asset(Data.images[i%4], fit: BoxFit.cover),
                      Align(
                        alignment: Alignment.topRight,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              child: Text(announcements[i].title,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0,
                                      fontFamily: "SF-Pro-Text-Regular")),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              child: Text("Expire After:" + announcements[i].expireAfter.toString(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14.0,
                                      fontFamily: "SF-Pro-Text-Regular")),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              child: Text(announcements[i].description,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14.0,
                                      fontFamily: "SF-Pro-Text-Regular")),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
          cardList.add(cardItem);
        }
        return Stack(
          children: cardList,
        );
      }),
    );
  }
}
