import 'package:flutter/material.dart';
import 'package:luminus_api/luminus_api.dart';
import 'data.dart' as Data;

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<Profile> profile = API.getProfile(Data.authentication);

  Widget displayName(String name) {
    return Text(
      name,
      style: Theme.of(context).textTheme.body1,
    );
  }

  Widget displayMatricNumber(String number) {
    return Text(
      number,
      style: Theme.of(context).textTheme.body1,
    );
  }

  Widget displayPersonalParticular(String info) {
    return Text(
      info,
      style: Theme.of(context).textTheme.body1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: Container(
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
                          padding: EdgeInsets.only(
                              left: 20.0, right: 20.0, top: 20.0),
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
      ),
    );
  }
}
