import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ui/home.dart';
import 'ui/intro.dart';

void main() {
  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    home: new MainApp(),
    theme: ThemeData(fontFamily: 'Nunito'),
  ));
}

class MainApp extends StatefulWidget {
  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {

  bool checkValue = false;
  SharedPreferences sharedPreferences;
  
  void initState() {
    super.initState();
    startMainApp();
  }

  startMainApp() async {
    var duration = const Duration(seconds: 2);
    return Timer(duration, () {
      return getCredential();
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.blue));
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

  getCredential() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      checkValue = sharedPreferences.getBool("intro");
      if (checkValue != null) {
        if (checkValue) {
          startHomeScreen();
        } else {
          sharedPreferences.clear();
        }
      } else {
        startIntroScreen();
        checkValue = false;
      }
    });
    developer.log(checkValue.toString(), name: 'Value first');
  }
  
  startHomeScreen() async {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) {
      return Home();
    }));
  }

  startIntroScreen() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      checkValue = true;
      sharedPreferences.setBool("intro", checkValue);
      sharedPreferences.commit();
    });

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent));

    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) {
      return IntroPage();
    }));

    developer.log(checkValue.toString(), name: 'Checking value of session');
  }
}
