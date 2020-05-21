import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:flutter_icons/flutter_icons.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:informasi/utils/color_palette.dart';
import 'package:jiffy/jiffy.dart';

import 'event_detail.dart';

class Notifikasi extends StatefulWidget {
  @override
  _NotifikasiState createState() => _NotifikasiState();
}

class _NotifikasiState extends State<Notifikasi> with TickerProviderStateMixin {

  // Server URL
  // final String url = "http://10.0.2.2/onlenkan-informasi/";
   final String url = "http://192.168.43.17/onlenkan-informasi/";
  // final String url = "http://192.168.1.21/onlenkan-informasi/";
  // final String url = "https://informasi.onlenkan.org/";

  SharedPreferences sharedPreferences;

  var isLoading = true;
  TabController _controller;
  List dataPengumuman, dataEvent;

  @override
  void initState() {
    super.initState();

    this.getDataFromJson();
    this.removeBadge();

    _controller = new TabController(length: 2, vsync: this);
  }

  Future<String> getDataFromJson() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response  = await http.get(url + "api/notifikasi.php");

      if (response.statusCode == 200) {

        dataPengumuman  = json.decode(response.body)['semuaPengumuman'];
        dataEvent       = json.decode(response.body)['semuaEvent'];
        
        setState(() {
          isLoading = false;
        });
      } else {
        developer.log('Gagal mengambil data', name: 'Koneksi Server');
      
        Fluttertoast.showToast(
          msg: "Gagal mengambil data!",
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 1,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 14.0);
      }
    } on SocketException {
      developer.log('Koneksi internet tidak tersedia', name: 'Koneksi Internet');
      
      Fluttertoast.showToast(
        msg: "Koneksi internet tidak tersedia!",
        toastLength: Toast.LENGTH_LONG,
        timeInSecForIosWeb: 1,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 14.0);
    }
    return 'success';
  }

  removeBadge() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      sharedPreferences.remove("badgeNotif");
    });
    developer.log(sharedPreferences.getInt("badgeNotif").toString(), name: "Session Badge Notif");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Semua Notifikasi", style: TextStyle(color: Colors.white, fontSize: 18.0, fontFamily: "NunitoSemiBold")),
        elevation: 0.0
      ),

      body: new Column(children: <Widget>[
        new Container(
          color: Colors.blue,
          constraints: BoxConstraints.expand(height: 50),
          child: TabBar(
            controller: _controller,
            labelColor: Colors.white,
            labelStyle: TextStyle(fontFamily: "NunitoSemiBold"),
            unselectedLabelColor: Colors.white60,
            indicator: UnderlineTabIndicator(
              borderSide: BorderSide(width: 4, color:Colors.white)),
            tabs: [
              Tab(text: "Pengumuman"),
              Tab(text: "Event Mendatang"),
            ]
          ),
        ),
        new Container(
          height: MediaQuery.of(context).size.height - 132.0,
          child: TabBarView(
            controller: _controller,
            children: [
              RefreshIndicator(
                onRefresh: getDataFromJson,
                child: isLoading
                  ? Center(child: CupertinoTheme(
                      data: CupertinoTheme.of(context).copyWith(brightness: Brightness.light),
                      child: CupertinoActivityIndicator()))
                  : dataPengumuman.isEmpty
                    ? _dataKosong("Pengumuman")
                    : ListView.builder(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        itemCount: dataPengumuman.length,
                        itemBuilder: (context, index) {
                          return _pengumumanData(dataPengumuman[index]);
                        }),
              ),
              RefreshIndicator(
                onRefresh: getDataFromJson,
                child: isLoading
                  ? Center(child: CupertinoTheme(
                      data: CupertinoTheme.of(context).copyWith(brightness: Brightness.light),
                      child: CupertinoActivityIndicator()))
                  : dataEvent.isEmpty
                    ? _dataKosong("Event")
                    : ListView.builder(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        itemCount: dataEvent.length,
                        itemBuilder: (context, index) {
                          return _eventData(dataEvent[index]);
                        }),
              ),
            ]),
        ),
      ]),
      
    );
  }

  // PENGUMUMAN LIST
  Widget _pengumumanData(dynamic item) => GestureDetector(
    onTap: () {
      showModal(context,
        item['judul_pengumuman'],
        item['deskripsi'],
        item['gambar'],
        item['update_pada'],
        item['link']);
    },
    child: Container(
      margin: const EdgeInsets.only(left: 15, right: 15, top: 0, bottom: 15),
      decoration: BoxDecoration(
        color: Color(0xffffffff),
        borderRadius: BorderRadius.circular(3),
        boxShadow: [BoxShadow(
          color: Color(0x10000000),
          blurRadius: 5.0,
          spreadRadius: 0.5,
          offset: Offset(1.0, 2.5))
        ]
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(3), bottomLeft: Radius.circular(3)),
            child: item['gambar'] == ''
              ? Padding(
                  padding: EdgeInsets.only(top: 8, left: 8),
                  child: Image.asset("icon/icon.png",
                    height: 18,
                    width: 18))
              : Padding(
                  padding: EdgeInsets.only(top: 8, left: 8),
                  child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(4.0)),
                      child: CachedNetworkImage(
                        width: 16,
                        height: 16,
                        fit: BoxFit.cover,
                        imageUrl: url + "uploads/pengumuman/" + item['gambar'],
                        placeholder: (context, url) => new Container(
                          height: 16,
                          width: 16,
                          child: Center(
                            child: CupertinoTheme(
                              data: CupertinoTheme.of(context).copyWith(brightness: Brightness.light),
                              child: CupertinoActivityIndicator()))),
                        errorWidget: (context, url, error) => new Icon(Icons.error),
                        fadeOutDuration: new Duration(seconds: 1),
                        fadeInDuration: new Duration(seconds: 1))))
          ),
          Container(
            width: MediaQuery.of(context).size.width - 56.0,
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  item['judul_pengumuman'], 
                  style: TextStyle(fontSize: 14, fontFamily: "NunitoSemiBold"), maxLines: 2, overflow: TextOverflow.ellipsis, softWrap: true),
                SizedBox(height: 4),
                Text(
                  item['deskripsi'], 
                  style: TextStyle(fontSize: 12, color: Colors.black45), maxLines: 3, overflow: TextOverflow.ellipsis, softWrap: true),
                SizedBox(height: 10),
                Text(
                  Jiffy(item['update_pada'].toString()).format("dd MMMM yyyy, HH:mm"),
                  style: TextStyle(fontSize: 10, color: ColorPalette.grey)),
              ]
            )
          )
        ]
      )
    )
  );

  // Modal Detail Pengumuman
  void showModal(context, String judul, String deskripsi, String gambar, String update, String link){
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(2),
          height: MediaQuery.of(context).size.height * 0.60,
          decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: new BorderRadius.all(Radius.circular(3.0)),
            boxShadow: [BoxShadow(blurRadius: 10, color: Color(0x20000000), spreadRadius: 5)],
          ),
          child: ListView(
            children: <Widget>[
              gambar == ''
                ? Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.only(top: 15, left: 10),
                    child: Image.asset("icon/icon.png",
                      height: 18,
                      width: 18))
                : Container(
                    decoration: BoxDecoration(
                      boxShadow: [BoxShadow(
                        color: Color(0x40000000),
                        blurRadius: 10.0,
                        spreadRadius: 1.5,
                        offset: Offset(0.0, 3.0))
                      ]
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(3.0)),
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        width: double.infinity,
                        imageUrl: url + "uploads/pengumuman/" + gambar,
                        placeholder: (context, url) => new Container(
                          height: 150.0,
                          child: new CupertinoTheme(data: CupertinoTheme.of(context).copyWith(brightness: Brightness.light), child: CupertinoActivityIndicator()),
                        ),
                        errorWidget: (context, url, error) => new Icon(Icons.error),
                        fadeOutDuration: new Duration(seconds: 1),
                        fadeInDuration: new Duration(seconds: 1))),
              ),
              Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(top: 10),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(judul, style: TextStyle(fontSize: 16, color: ColorPalette.black, fontFamily: "NunitoSemiBold" )),
                    SizedBox(height: 10),
                    Text(Jiffy(update).format("dd MMMM yyyy, HH:mm"), style: TextStyle(fontSize: 12, height: 1.5, color: Colors.black45)),
                    SizedBox(height: 10),
                    Text(deskripsi, style: TextStyle(fontSize: 14, color: ColorPalette.dark )),
                  ]
                )
              ),
            ]
          )
        );
      }
    );
  }

  // EVENT LIST
  Widget _eventData(dynamic item) => GestureDetector(
    onTap: () {
      Navigator.push(
        context, MaterialPageRoute(
          builder: (context) => EventDetail(),
          settings: RouteSettings(
              arguments: {
                "gambar"    : url + "uploads/event/" + item['gambar'],
                "judul"     : item['judul_event'],
                "deskripsi" : item['deskripsi'],
                "waktu"     : item['waktu']
              }
          )
        )
      );
    },
    child: Container(
      margin: const EdgeInsets.only(left: 15, right: 15, top: 0, bottom: 15),
      decoration: BoxDecoration(
        color: Color(0xffffffff),
        borderRadius: BorderRadius.circular(3),
        boxShadow: [BoxShadow(
          color: Color(0x10000000),
          blurRadius: 5.0,
          spreadRadius: 0.5,
          offset: Offset(1.0, 2.5))
        ]
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(3), bottomLeft: Radius.circular(3)),
            child: 
              new CachedNetworkImage(
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                imageUrl: url + "uploads/event/" + item['gambar'],
                placeholder: (context, url) => new Container(
                  height: 80,
                  width: 80,
                  child: Center(
                    child: CupertinoTheme(
                      data: CupertinoTheme.of(context).copyWith(brightness: Brightness.light),
                      child: CupertinoActivityIndicator()))),
                errorWidget: (context, url, error) => new Icon(Icons.error),
                fadeOutDuration: new Duration(seconds: 1),
                fadeInDuration: new Duration(seconds: 1),
              )
          ),
          Container(
            width: MediaQuery.of(context).size.width - 118.0,
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  Jiffy(item['waktu'].toString()).format("dd MMMM yyyy, HH:mm"),
                  style: TextStyle(fontSize: 12, color: ColorPalette.grey)),
                Text(
                  item['judul_event'], 
                  style: TextStyle(fontSize: 14, height: 1.5), maxLines: 2, overflow: TextOverflow.ellipsis, softWrap: true),
              ]
            )
          )
        ]
      )
    )
  );

  // WHERE EMPTY DATA 
  Widget _dataKosong(String pesan) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(FontAwesome5.sad_tear, size: 50, color: Color(0x90CCCCCC)),
        Text("Belum ada $pesan.",
          style: TextStyle(color: ColorPalette.dark, fontSize: 16, fontFamily: "NunitoSemiBold", height: 3)),
        SizedBox(height: 60),
      ],
    );
  }
}