import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Swiper(
        itemCount: null,
      ),
    );
  }
}
