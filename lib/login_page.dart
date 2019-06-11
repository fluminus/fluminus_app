import 'package:fluminus/data.dart';
import 'package:fluminus/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/animation.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

const double _signinButtonWidth = 200.0;
const double _signinButtonHeight = 60.0;
const Color _signinButtonColor = const Color.fromRGBO(247, 64, 106, 1.0);
var _signinTextStyle =
    (BuildContext context) => Theme.of(context).textTheme.subhead;

class LoginPage extends StatefulWidget {
  static String tag = 'login-page';
  const LoginPage({Key key}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  AnimationController _loginButtonController;
  var animationStatus = 0;
  String _id;
  String _password;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loginButtonController = AnimationController(
        duration: Duration(milliseconds: 3000), vsync: this);
  }

  @override
  void dispose() {
    _loginButtonController.dispose();
    super.dispose();
  }

  Future<Null> _playAnimation() async {
    try {
      await _loginButtonController.forward();
      await _loginButtonController.reverse();
    } on TickerCanceled {}
  }

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
                      animationStatus == 0
                          ? Padding(
                              padding: const EdgeInsets.only(bottom: 50.0),
                              child: InkWell(
                                  onTap: () async {
                                    final storage = FlutterSecureStorage();
                                    this._formKey.currentState.save();
                                    await storage.write(
                                        key: 'nusnet_id', value: _id);
                                    await storage.write(
                                        key: 'nusnet_password',
                                        value: _password);
                                    updateCredentials();
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    prefs.setBool('hasCred', true);
                                    setState(() {
                                      animationStatus = 1;
                                    });
                                    _playAnimation();
                                  },
                                  child: SignInButton()),
                            )
                          : StaggerAnimation(
                              buttonController: _loginButtonController.view),
                    ],
                  ),
                ],
              ))),
        )));
  }
}

class StaggerAnimation extends StatelessWidget {
  StaggerAnimation({Key key, this.buttonController})
      : buttonSqueezeanimation = Tween(
          begin: _signinButtonWidth,
          end: _signinButtonHeight,
        ).animate(
          CurvedAnimation(
            parent: buttonController,
            curve: Interval(
              0.0,
              0.150,
            ),
          ),
        ),
        buttomZoomOut = Tween(
          begin: _signinButtonHeight,
          end: 1000.0,
        ).animate(
          CurvedAnimation(
            parent: buttonController,
            curve: Interval(
              0.550,
              0.999,
              curve: Curves.bounceOut,
            ),
          ),
        ),
        containerCircleAnimation = EdgeInsetsTween(
          begin: const EdgeInsets.only(bottom: 50.0),
          end: const EdgeInsets.only(bottom: 0.0),
        ).animate(
          CurvedAnimation(
            parent: buttonController,
            curve: Interval(
              0.500,
              0.800,
              curve: Curves.ease,
            ),
          ),
        ),
        super(key: key);

  final AnimationController buttonController;
  final Animation<EdgeInsets> containerCircleAnimation;
  final Animation buttonSqueezeanimation;
  final Animation buttomZoomOut;

  Future<Null> _playAnimation() async {
    try {
      await buttonController.forward();
      await buttonController.reverse();
    } on TickerCanceled {}
  }

  Widget _buildAnimation(BuildContext context, Widget child) {
    return Padding(
      padding: buttomZoomOut.value == _signinButtonHeight
          ? const EdgeInsets.only(bottom: 50.0)
          : containerCircleAnimation.value,
      child: InkWell(
          onTap: () {
            _playAnimation();
          },
          child: buttomZoomOut.value <= 300
              ? Container(
                  width: buttomZoomOut.value == _signinButtonHeight
                      ? buttonSqueezeanimation.value
                      : buttomZoomOut.value,
                  height: buttomZoomOut.value == _signinButtonHeight
                      ? _signinButtonHeight
                      : buttomZoomOut.value,
                  alignment: FractionalOffset.center,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(247, 64, 106, 1.0),
                    borderRadius: buttomZoomOut.value < 400
                        ? BorderRadius.all(const Radius.circular(30.0))
                        : BorderRadius.all(const Radius.circular(0.0)),
                  ),
                  child: buttonSqueezeanimation.value > 75.0
                      ? Text(
                          "Sign In",
                          style: _signinTextStyle(context),
                        )
                      : buttomZoomOut.value < 300.0
                          ? CircularProgressIndicator(
                              value: null,
                              strokeWidth: 3.0,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            )
                          : null)
              : Container(
                  width: buttomZoomOut.value,
                  height: buttomZoomOut.value,
                  decoration: BoxDecoration(
                    shape: buttomZoomOut.value < 500
                        ? BoxShape.circle
                        : BoxShape.rectangle,
                    color: const Color.fromRGBO(247, 64, 106, 1.0),
                  ),
                )),
    );
  }

  @override
  Widget build(BuildContext context) {
    buttonController.addListener(() {
      if (buttonController.isCompleted) {
        Navigator.pushReplacementNamed(context, HomePage.tag);
      }
    });
    return AnimatedBuilder(
      builder: _buildAnimation,
      animation: buttonController,
    );
  }
}

class SignInButton extends StatelessWidget {
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
        "Sign In",
        style: _signinTextStyle(context),
      ),
    ));
  }
}

DecorationImage logo = DecorationImage(
  image: ExactAssetImage('assets/logo.png'),
  fit: BoxFit.cover,
);
