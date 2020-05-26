import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

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
  String tanggal, kelamin;
  bool isLoading = false;
  int _value = -1;
  int _radioValue = -1;

  final txnama    = TextEditingController();
  final txemail   = TextEditingController();
  final txtelepon = TextEditingController();
  final txalamat  = TextEditingController();

  GlobalKey<ScaffoldState> _scaffoldKey;

  @override
  void initState() {
    super.initState();
    this.getUserLogin();
    _scaffoldKey = GlobalKey();
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

    getUserFromJson(googleUid);
  }

  List data;
  Future<String> getUserFromJson(String id) async {
    setState(() {
      isLoading = true;
    });

    try {
      final response  = await http.get(url + "api/profil.php?uid=" + id);
      if (response.statusCode == 200) {
        data = json.decode(response.body)['semua'];
        
        setState(() {
          isLoading = false;

          txemail.text    = data[0]['email'];
          txtelepon.text  = data[0]['telepon'];
          txalamat.text   = data[0]['alamat'];
          kelamin         = data[0]['kelamin'];

          _handleRadioValueChange(kelamin == 'L' ? 0 : kelamin == 'P' ? 1 : -1);

          if(data[0]['tanggal_lahir'] != '0000-00-00') {
            _selectedDate = Jiffy(data[0]['tanggal_lahir']).format("dd MMMM yyyy");
            tanggal = Jiffy(data[0]['tanggal_lahir']).format("yyyy-MM-dd");
          }
        });
      } else {
        print('Gagal mengambil data');
      }
    } catch (e) {
      print('Koneksi internet tidak tersedia');
    }

    return 'success';
  }

  // Save to api
  Future<String> updateProfil(String uid, String uphoto, String nama, String email, String telepon, String kelamin, String tanggal, String alamat) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = 'update';
      map['uid'] = uid;
      map['uphoto'] = uphoto;
      map['nama'] = nama;
      map['email'] = email;
      map['telepon'] = telepon;
      map['kelamin'] = kelamin;
      map['tanggal'] = tanggal;
      map['alamat'] = alamat;

      final response = await http.post(url + "api/profil.php", body: map);
      print('update user Response: ${response.body}');
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }

  // Datepiceker and select gender
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
        tanggal = Jiffy(d).format("yyyy-MM-dd");
      });
  }

  // Radio button
  void _handleRadioValueChange(int value) {
    setState(() {
      _value = value;
      _radioValue = value;

      switch (_radioValue) {
        case 0:
          setState(() {
            kelamin = "L";
          });
          break;
        case 1:
          setState(() {
            kelamin = "P";
          });
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
      key: _scaffoldKey,
      backgroundColor: Color(0xfff5f5f5),
      body: isLoading 
        ? Center(child: CupertinoTheme(
            data: CupertinoTheme.of(context).copyWith(brightness: Brightness.light),
            child: CupertinoActivityIndicator()))
        : ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 35),itemCount: 1,
            itemBuilder: (context, index) {
              return _profilDetail(data[index]);
            }
          )
    );
  }

  // Data profile UI
  Widget _profilDetail(dynamic item) => Column(
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
                imageUrl: item['uphoto'] == '' ? url + 'img/logo.png' : item['uphoto'],
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
          controller: txtelepon,
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
          child: Container(
            width: double.infinity,
            alignment: Alignment.centerLeft,
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
          controller: txalamat,
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

      Container(
        width: double.infinity,
        child: RaisedButton(
          onPressed: () {
            String nama     = txnama.text;
            String email    = txemail.text;
            String telepon  = txtelepon.text;
            String alamat   = txalamat.text;

            if (nama.length < 4 || email.length < 8 || telepon.length < 10 || alamat.length < 10 || tanggal.length < 4) {
              _scaffoldKey.currentState..removeCurrentSnackBar()..showSnackBar(
                SnackBar(
                  duration: Duration(seconds: 5),
                  backgroundColor: Colors.red,
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Harap isi dengan benar!', style: TextStyle(fontFamily: "Nunito", fontSize: 15)),
                      Icon(Ionicons.ios_information_circle_outline)
                    ],
                  ),
                ),
              );
            }
            else {
              _scaffoldKey.currentState..removeCurrentSnackBar()..showSnackBar(
                SnackBar(
                  duration: Duration(days: 1),
                  backgroundColor: Colors.blue,
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Sedang Menyimpan...', style: TextStyle(fontFamily: "Nunito", fontSize: 15)),
                      CupertinoTheme(
                        data: CupertinoTheme.of(context).copyWith(brightness: Brightness.dark),
                        child: CupertinoActivityIndicator()),
                    ],
                  ),
                ),
              );

              Timer(Duration(seconds: 3), () {
                updateProfil(googleUid, googlePhoto, nama, email, telepon, kelamin, tanggal, alamat).then((result) {
                  if ('success' == result) {
                    Navigator.pop(_scaffoldKey.currentState.context);
                  } else {
                    _scaffoldKey.currentState..removeCurrentSnackBar()..showSnackBar(
                      SnackBar(
                        duration: Duration(seconds: 5),
                        backgroundColor: Colors.red,
                        content: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Terjadi kesalahan ketika menyimpan data!', style: TextStyle(fontFamily: "Nunito", fontSize: 15)),
                            Icon(Ionicons.ios_information_circle_outline)
                          ],
                        ),
                      ),
                    );
                  }
                });
              });
            }
            // End of else

          },
          elevation: 2,
          color: Color(0xff1DE983),
          padding: EdgeInsets.symmetric(vertical: 13),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13)),
          child: Text("Simpan Perubahan",
            style: TextStyle(color: Colors.white, height: 1, fontSize: 15, fontFamily: "NunitoSemiBold"))
        )
      ),
      
      SizedBox(height: 30)

    ],
  );
}