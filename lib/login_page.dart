import 'package:fluminus/data.dart';
import 'package:fluminus/home_page.dart';
import 'package:fluminus/widgets/dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:luminus_api/luminus_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluminus/data.dart' as data;

const double _signinButtonWidth = 200.0;
const double _signinButtonHeight = 60.0;
const Color _signinButtonColor = const Color.fromRGBO(247, 64, 106, 1.0);
var _signinTextStyle =
    (BuildContext context) => Theme.of(context).textTheme.subhead;
DecorationImage logo = DecorationImage(
  image: ExactAssetImage('assets/logo.png'),
  fit: BoxFit.cover,
);

class LoginPage extends StatefulWidget {
  static String tag = 'login-page';
  const LoginPage({Key key}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  String _id;
  String _password;
  String _buttonText = 'Sign in';
  final _formKey = GlobalKey<FormState>();

  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                'Are you sure?',
                style: TextStyle(fontSize: 30.0),
              ),
              content: Text(
                "You won't be able to enjoy Fluminus without providing valid credentials for us to sign in to Luminus...",
                style: Theme.of(context).textTheme.body1,
              ),
              actions: <Widget>[
                FlatButton(
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, HomePage.tag),
                  child: Text(
                    "Quit",
                    style: TextStyle(
                        color: Theme.of(context).unselectedWidgetColor),
                  ),
                ),
                FlatButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(
                    "I'll stay...",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                  ),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 0.4;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return (WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          body: Container(
              decoration: BoxDecoration(
                  // TODO: background image
                  // image: backgroundImage,
                  ),
              child: Container(
                  child: ListView(
                padding: const EdgeInsets.all(0.0),
                children: <Widget>[
                  Stack(
                    alignment: AlignmentDirectional.bottomCenter,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 60.0, bottom: 20.0),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  width: 140.0,
                                  height: 140.0,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    image: logo,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20.0),
                                  child: Text(
                                    'Welcome to Fluminus!',
                                    style: Theme.of(context).textTheme.caption,
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 20.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Form(
                                    key: _formKey,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        TextFormField(
                                          obscureText: false,
                                          autofocus: true,
                                          decoration: InputDecoration(
                                            labelText: 'NUSNET ID',
                                            hintText: 'e.g. e0261888',
                                            icon: Icon(Icons.person_outline),
                                          ),
                                          onSaved: (value) {
                                            setState(() {
                                              _id = value;
                                            });
                                          },
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 20.0),
                                        ),
                                        TextFormField(
                                          obscureText: true,
                                          decoration: InputDecoration(
                                            labelText: 'PASSWORD',
                                            hintText: 'Password',
                                            icon: Icon(Icons.lock_outline),
                                          ),
                                          onSaved: (value) {
                                            setState(() {
                                              _password = value;
                                            });
                                          },
                                        ),
                                      ],
                                    )),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 160.0),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 50.0),
                        child: InkWell(
                            onTap: () async {
                              final storage = FlutterSecureStorage();
                              this._formKey.currentState.save();
                              await storage.write(key: 'nusnet_id', value: _id);
                              await storage.write(
                                  key: 'nusnet_password', value: _password);
                              updateCredentials();
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              prefs.setBool('hasCred', true);
                              try {
                                setState(() {
                                  this._buttonText = "Signing in...";
                                });
                                data.modules =
                                    await API.getModules(data.authentication());
                                // print('module = ${data.modules}');
                                setState(() {
                                  this._buttonText = "Signed in!";
                                });
                                Navigator.pushReplacementNamed(
                                    context, HomePage.tag);
                              } catch (e) {
                                setState(() {
                                  this._buttonText = "Sign in";
                                });
                                // TODO: This part is pretty messy
                                if (e is WrongCredentialsException) {
                                  displayDialog(
                                      'Wrong credentials',
                                      'Please provide correct NUSNET ID and password and try again.',
                                      context);
                                } else if (e is RestartAuthException) {
                                  await prefs.setBool('hasCred', false);
                                  await data.deleteCredentials();
                                  displayDialog(
                                      'Log in error',
                                      'If you just logged out, you may need to restart the app and log in again.',
                                      context);
                                } else {
                                  displayDialog('Error', e.toString(), context);
                                }
                              }
                            },
                            child: SignInButton(this._buttonText)),
                      ),
                    ],
                  ),
                ],
              ))),
        )));
  }
}

class SignInButton extends StatelessWidget {
  final String content;
  SignInButton(this.content);
  @override
  Widget build(BuildContext context) {
    return (Container(
      width: _signinButtonWidth,
      height: _signinButtonHeight,
      alignment: FractionalOffset.center,
      decoration: BoxDecoration(
        color: _signinButtonColor,
        borderRadius:
            BorderRadius.all(const Radius.circular(_signinButtonHeight / 2.0)),
      ),
      child: Text(
        content,
        style: _signinTextStyle(context),
      ),
    ));
  }
}
