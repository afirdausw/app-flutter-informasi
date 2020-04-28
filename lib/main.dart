import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pusatinformasi/view/home.dart';
import 'package:pusatinformasi/view/intro.dart';

void main() {
  runApp(new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new IntroPage()
      // home: new SplashScreen()
    )
  );
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  void initState() {
    super.initState();
    startSplashScreen();
  }

  startSplashScreen() async {
    var duration = const Duration(seconds: 2);
    return Timer(duration, () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) {
          return Home();
        })
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff3113E2),
      body: Center(
        child: Image.asset(
          "images/logo_putih.png",
          width: 200.0,
        ),
      ),
    );
  }
}