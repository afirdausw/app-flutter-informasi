import 'package:flutter/material.dart';

import 'package:flutter_icons/flutter_icons.dart';
import 'package:informasi/utils/color_palette.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Darurat extends StatefulWidget {
  @override
  _DaruratState createState() => _DaruratState();
}

class _DaruratState extends State<Darurat> {
  
  // Shared Session
  bool checkLogin;
  SharedPreferences sharedPreferences;

  // GET USER LOGIN
  getUserLogin() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      checkLogin = sharedPreferences.getBool("login");
      if (checkLogin != null && checkLogin) {
        checkLogin = true;
      } else {
        checkLogin = false;
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nomor Darurat", style: TextStyle(color: Colors.white, fontSize: 18.0, fontFamily: "NunitoSemiBold")),
      ),

      body: checkLogin
      ? Center(
          child: Text("NOMOR DARURAT"))
      : _showAlert()
      
    );
  }

  // WHERE USER NOT LOG IN 
  Widget _showAlert() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(FontAwesome5.sad_tear, size: 50, color: Color(0x90CCCCCC)),
        Text("Nampaknya anda belum login, .",
          style: TextStyle(color: ColorPalette.dark, fontSize: 16, fontFamily: "NunitoSemiBold", height: 3)),
        SizedBox(height: 60),
      ],
    );
  }
}