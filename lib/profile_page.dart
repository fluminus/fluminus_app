import 'package:flutter/material.dart';

import 'data.dart' as Data;
import 'luminus_api/profile_response.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<Profile> profile = Data.getProfile();

  Widget displayName(String name) {
    return Text(
      name,
      style: TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.bold,
          fontSize: 17.0),
    );
  }

  Widget displayMatricNumber(String number) {
    return Text(
      number,
      style: TextStyle(
          fontFamily: 'Montserrat', color: Colors.grey, fontSize: 15.0),
    );
  }

  Widget displayPersonalParticular(String info) {
    return Text(
      info,
      style: TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w300,
          fontSize: 15.0),
    );
  }

  Widget followerNonsense() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '1789',
              style: TextStyle(
                  fontFamily: 'Montserrat', color: Colors.red, fontSize: 17.0),
            ),
            Text(
              'Followers',
              style: TextStyle(
                fontFamily: 'Montserrat',
                color: Colors.grey,
              ),
            )
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '236',
              style: TextStyle(
                  fontFamily: 'Montserrat', color: Colors.blue, fontSize: 17.0),
            ),
            Text(
              'Following',
              style: TextStyle(
                fontFamily: 'Montserrat',
                color: Colors.grey,
              ),
            )
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '990',
              style: TextStyle(
                  fontFamily: 'Montserrat', color: Colors.red, fontSize: 17.0),
            ),
            Text(
              'Likes',
              style: TextStyle(
                fontFamily: 'Montserrat',
                color: Colors.grey,
              ),
            )
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: FutureBuilder(
          future: profile,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Profile data = snapshot.data;
              return ListView(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding:
                            EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
                        child: Container(
                          height: 50.0,
                          width: 50.0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25.0),
                              image: DecorationImage(
                                  image: AssetImage('assets/image_01.png'),
                                  fit: BoxFit.cover)),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(
                              left: 20.0, right: 20.0, top: 10.0),
                          child: displayName(data.userNameOriginal)),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: displayMatricNumber(data.userMatricNo),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, top: 20.0, right: 20.0),
                        child: displayPersonalParticular(data.email),
                      ),
                    ],
                  )
                ],
              );
            } else if (snapshot.hasError) {
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
          }),
    );
  }
}
