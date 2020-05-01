import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pusatinformasi/view/berita.dart';
import 'package:pusatinformasi/view/intro.dart';

import 'package:pusatinformasi/view/main.dart';


void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.blue
  ));

  runApp(new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new SplashScreen(),
      theme: ThemeData(
        fontFamily: 'Nunito'
      ),
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
          // return MyHomePage();
          return IntroPage();
        })
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Image.asset(
          "images/logo_putih.png",
          width: 200.0,
        ),
      ),
    );
  }
}