import 'package:flutter/material.dart';

import 'package:flutter_icons/flutter_icons.dart';
import 'package:informasi/utils/color_palette.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Layanan extends StatefulWidget {
  @override
  _LayananState createState() => _LayananState();
}

class _LayananState extends State<Layanan> {
  
  // Shared Session
  bool checkLogin;
  SharedPreferences sharedPreferences;

  @override
  void initState() {
    super.initState();
    this.getUserLogin();
  }

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
        title: Text("Layanan Publik", style: TextStyle(color: Colors.white, fontSize: 18.0, fontFamily: "NunitoSemiBold")),
      ),

      body: checkLogin
      ? Center(
          child: Text("LAYANAN PUBLIK"))
      : _showAlert()

    );
  }

  // WHERE USER NOT LOG IN 
  Widget _showAlert() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.greenAccent[100],
              borderRadius: BorderRadius.circular(35)),
            child: Icon(Ionicons.ios_lock, size: 50, color: Colors.white)),
          SizedBox(height: 25),
          Text("Silahkan login terlebih dahulu untuk melihat informasi.",
            textAlign: TextAlign.center,
            style: TextStyle(color: ColorPalette.dark, fontSize: 15, fontFamily: "NunitoSemiBold", height: 1.5)),
          SizedBox(height: 8),
          Text("Login dengan akun Google anda, pada menu profil.",
            textAlign: TextAlign.center,
            style: TextStyle(color: ColorPalette.dark, fontSize: 13, fontFamily: "Nunito", height: 1.5)),
          new Container(
            height: 35,
            margin: EdgeInsets.only(left: 20, right: 20, top: 15),
            child: new FlatButton(
              child: Text("Kembali, dan login",
                style: TextStyle(fontFamily: "NunitoSemiBold")),
              color: Colors.greenAccent,
              textColor: Colors.white,
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(10.0)),
              onPressed: () {
                Navigator.pop(context, "to_login");
              }
            )),
          SizedBox(height: 80),
        ]) 
    );
  }
}