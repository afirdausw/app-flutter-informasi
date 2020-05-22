import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:jiffy/jiffy.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  
  // Server URL
  // final String url = "http://10.0.2.2/onlenkan-informasi/";
  final String url = "http://192.168.43.17/onlenkan-informasi/";
  // final String url = "http://192.168.1.21/onlenkan-informasi/";
  // final String url = "https://informasi.onlenkan.org/";

  SharedPreferences sharedPreferences;
  String googleUid, googleName, googleEmail, googlePhoto;

  final txnama    = TextEditingController(); 
  final txemail   = TextEditingController(); 
  final txtelepon = TextEditingController(); 
  final txtanggal = TextEditingController(); 
  final txalamat  = TextEditingController(); 

  @override
  void initState() {
    super.initState();
    this.getUserLogin();
  }

  // Get user data
  getUserLogin() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      googleUid   = sharedPreferences.getString("google_uid");
      googleName  = sharedPreferences.getString("google_name");
      googleEmail = sharedPreferences.getString("google_email");
      googlePhoto = sharedPreferences.getString("google_photo");

      assert(googlePhoto != null);

      txnama.text   = googleName;
      txemail.text  = googleEmail;
    });

    print(googleUid);
  }

  String _selectedDate = 'Tanggal Lahir';

  Future<void> _selectDate(BuildContext context) async {
    final DateTime d = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1980),
      lastDate: DateTime.now(),
    );
    if (d != null)
      setState(() {
        _selectedDate = Jiffy(d).format("dd MMMM yyyy");
      });
  }

  // Radio button
  int _value = 0;
  int _radioValue = -1;

  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;

      switch (_radioValue) {
        case 0:
          Fluttertoast.showToast(msg: 'Laki-laki', toastLength: Toast.LENGTH_SHORT);
          break;
        case 1:
          Fluttertoast.showToast(msg: 'Perempuan', toastLength: Toast.LENGTH_SHORT);
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ubah Profil',
          style: TextStyle(color: Colors.white, fontSize: 18.0, fontFamily: "NunitoSemiBold"))
      ),
      backgroundColor: Color(0xfff5f5f5),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 35),
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: [BoxShadow(
                    color: Color(0x30666666),
                    blurRadius: 1.0,
                    spreadRadius: 1.0,
                    offset: Offset(0.0, 1.0)
                  )]
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(40)),
                  child: new CachedNetworkImage(
                    height: 80.0,
                    width: 80.0,
                    fit: BoxFit.cover,
                    imageUrl: googlePhoto == '' ? url + 'img/logo.png' : googlePhoto,
                    placeholder: (context, url) => Container(
                      width: 80.0,
                      height: 80.0,
                      child: new CupertinoTheme(
                        data: CupertinoTheme.of(context).copyWith(brightness: Brightness.light),
                        child: CupertinoActivityIndicator())
                    ),
                    errorWidget: (context, url, error) => new Icon(Icons.error),
                    fadeOutDuration: new Duration(seconds: 1),
                    fadeInDuration: new Duration(seconds: 1)),
                )
              )
            ],
          ),
          
          Container(
            height: 60,
            padding: EdgeInsets.only(top: 8, bottom: 5),
            margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                width: 1,
                color: Color(0xffEEEEEE)),
              boxShadow: [BoxShadow(
                color: Color(0x08666666),
                blurRadius: 1.0,
                spreadRadius: 1.0,
                offset: Offset(0.0, 1.0)
              )]
            ),
            child: TextField(
              controller: txnama,
              style: TextStyle(fontFamily: "NunitoSemiBold", fontSize: 16),
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                border: InputBorder.none,
                // border: OutlineInputBorder(),
                contentPadding: EdgeInsets.only(left: 16, right: 16, bottom: 3),
                labelStyle: TextStyle(fontSize: 14, color: Colors.black54),
                labelText: "Nama Lengkap" ),
            )
          ),

          Container(
            height: 60,
            padding: EdgeInsets.only(top: 8, bottom: 5),
            margin: EdgeInsets.fromLTRB(0, 5, 0, 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                width: 1,
                color: Color(0xffEEEEEE)),
              boxShadow: [BoxShadow(
                color: Color(0x08666666),
                blurRadius: 1.0,
                spreadRadius: 1.0,
                offset: Offset(0.0, 1.0)
              )]
            ),
            child: TextField(
              controller: txemail,
              style: TextStyle(fontFamily: "NunitoSemiBold", fontSize: 16),
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 16, right: 16, bottom: 3),
                labelStyle: TextStyle(fontFamily: "NunitoSemiBold", fontSize: 15, color: Colors.black54),
                labelText: "Email" ),
            )
          ),

          Container(
            height: 60,
            padding: EdgeInsets.only(top: 8, bottom: 5),
            margin: EdgeInsets.fromLTRB(0, 5, 0, 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                width: 1,
                color: Color(0xffEEEEEE)),
              boxShadow: [BoxShadow(
                color: Color(0x08666666),
                blurRadius: 1.0,
                spreadRadius: 1.0,
                offset: Offset(0.0, 1.0)
              )]
            ),
            child: TextField(
              style: TextStyle(fontFamily: "NunitoSemiBold", fontSize: 16),
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 16, right: 16, bottom: 3),
                labelStyle: TextStyle(fontFamily: "NunitoSemiBold", fontSize: 15, color: Colors.black54),
                labelText: "Telepon" ),
            )
          ),
          
          Container(
            height: 60,
            padding: EdgeInsets.symmetric(vertical: 5),
            margin: EdgeInsets.fromLTRB(0, 5, 0, 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                width: 1,
                color: Color(0xffEEEEEE)),
              boxShadow: [BoxShadow(
                color: Color(0x08666666),
                blurRadius: 1.0,
                spreadRadius: 1.0,
                offset: Offset(0.0, 1.0)
              )]
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () => setState(() {
                      _value = 0;
                      _handleRadioValueChange(0);
                    }),
                    child: Container(
                      padding: EdgeInsets.only(left: 8, right: 10, bottom: 8, top: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: _value == 0 ? Colors.blue : Colors.transparent,
                      ),
                      child: Row(
                        children: <Widget>[
                          Icon(Ionicons.ios_male, size: 20, color: _value == 0 ? Colors.white : Colors.black87 ),
                          SizedBox(width: 6),
                          Text("Laki-laki",
                            style: TextStyle(fontFamily: "NunitoSemiBold", fontSize: 16, color: _value == 0 ? Colors.white : Colors.black87 ))
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  GestureDetector(
                    onTap: () => setState(() {
                      _value = 1;
                      _handleRadioValueChange(1);
                    }),
                    child: Container(
                      padding: EdgeInsets.only(left: 8, right: 10, bottom: 8, top: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: _value == 1 ? Colors.blue : Colors.transparent
                      ),
                      child: Row(
                        children: <Widget>[
                          Icon(Ionicons.ios_female, size: 20, color: _value == 1 ? Colors.white : Colors.black87 ),
                          SizedBox(width: 6),
                          Text("Perempuan",
                            style: TextStyle(fontFamily: "NunitoSemiBold", fontSize: 16, color: _value == 1 ? Colors.white : Colors.black87 ))
                        ],
                      )
                    ),
                  ),
                ],
              ),
            ),
          ),

          Container(
            height: 60,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(vertical: 5),
            margin: EdgeInsets.fromLTRB(0, 5, 0, 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                width: 1,
                color: Color(0xffEEEEEE)),
              boxShadow: [BoxShadow(
                color: Color(0x08666666),
                blurRadius: 1.0,
                spreadRadius: 1.0,
                offset: Offset(0.0, 1.0)
              )]
            ),
            child: InkWell(
              onTap: () {
                _selectDate(context);
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                child: Text(_selectedDate, style: TextStyle(fontFamily: "NunitoSemiBold", fontSize: 16))
              ),
            ) 
          ),

          Container(
            padding: EdgeInsets.symmetric(vertical: 5),
            margin: EdgeInsets.fromLTRB(0, 5, 0, 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                width: 1,
                color: Color(0xffEEEEEE)),
              boxShadow: [BoxShadow(
                color: Color(0x08666666),
                blurRadius: 1.0,
                spreadRadius: 1.0,
                offset: Offset(0.0, 1.0)
              )]
            ),
            child: TextField(
              style: TextStyle(fontFamily: "NunitoSemiBold", fontSize: 16, height: 1.5),
              textInputAction: TextInputAction.newline,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 16, right: 16, bottom: 6, top: 3),
                labelStyle: TextStyle(fontFamily: "NunitoSemiBold", fontSize: 15, color: Colors.black54),
                labelText: "Alamat Lengkap" ),
            )
          ),

          SizedBox(height: 30),
          RaisedButton(
            onPressed: () {
              // null
            },
            elevation: 2,
            color: Color(0xff1DE983),
            padding: EdgeInsets.symmetric(vertical: 13),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(13)),
            child: Text("Simpan Perubahan",
              style: TextStyle(color: Colors.white, height: 1, fontSize: 15, fontFamily: "NunitoSemiBold"))
          )


        ],
      )
    );
  }
}