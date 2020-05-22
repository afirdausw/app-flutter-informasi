import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io' show Platform;
import 'dart:io';

import 'package:http/http.dart' as http;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:informasi/utils/color_palette.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jiffy/jiffy.dart';


var isLoading = true;

// GET ID OF APP AND ADS
String getAppId() {
  if (Platform.isIOS) {
    return null;
  } else if (Platform.isAndroid) {
    return 'ca-app-pub-5511375838860331~6177512186';
  }
  return null;
}
String getBannerAdUnitId() {
  if (Platform.isIOS) {
    return null;
  } else if (Platform.isAndroid) {
    return 'ca-app-pub-5511375838860331/4672858826';
  }
  return null;
}
String getInterstitialAdUnitId() {
  if (Platform.isIOS) {
    return null;
  } else if (Platform.isAndroid) {
    return 'ca-app-pub-5511375838860331/1991048685';
  }
  return null;
}
// END OF

class BeritaDetailPayload extends StatefulWidget {

  BeritaDetailPayload(this.payload);
  final String payload;

  @override
  _BeritaDetailPayloadState createState() => _BeritaDetailPayloadState();
}

class _BeritaDetailPayloadState extends State<BeritaDetailPayload> {
  
  String _payload;

  // Server URL
  // final String url = "http://10.0.2.2/onlenkan-informasi/";
  // final String url = "http://192.168.43.17/onlenkan-informasi/";
  // final String url = "http://192.168.1.21/onlenkan-informasi/";
  final String url = "https://informasi.onlenkan.org/";

  // BANNER
  BannerAd myBanner;

  BannerAd buildBannerAd() {
    return BannerAd(
      // adUnitId: getBannerAdUnitId(),
      adUnitId: BannerAd.testAdUnitId,
      size: AdSize.banner,
      listener: (MobileAdEvent event) {
        print("Banner $event");
        if (event == MobileAdEvent.loaded) {
          myBanner..show();
        }
      });
  }

  @override
  void initState() {
    super.initState();
    FirebaseAdMob.instance.initialize(appId: getAppId());

    myBanner = buildBannerAd()..load();
    _payload = widget.payload;

    this.getDataFromJson();
  }

  @override
  void dispose() {
    super.dispose();
    myBanner.dispose();
  }

  List data;
  Future<String> getDataFromJson() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response  = await http.get(url + "api/berita-detail.php?link=$_payload");
      if (response.statusCode == 200) {
        data = json.decode(response.body)['semua'];
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
    }
    return 'success';
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Berita", style: TextStyle(color: Colors.white, fontSize: 18.0, fontFamily: "NunitoSemiBold")),
      ),
      body: SafeArea(
        bottom: false,
        top: false,
        child: isLoading 
          ? CupertinoTheme(
              data: CupertinoTheme.of(context).copyWith(brightness: Brightness.light),
              child: CupertinoActivityIndicator())
          : ListView.builder(
            itemCount: 1,
            itemBuilder: (context, index) {
              return _detailData(data[index]);
            }
          )
      )
    );
  }

  Widget _detailData(dynamic item) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      ClipRRect(
        child: new CachedNetworkImage(
          fit: BoxFit.cover,
          imageUrl: url + "uploads/berita/" + item['gambar'],
          placeholder: (context, url) => new Container(
            height: 100,
            width: double.infinity,
            child: Center(
              child: CupertinoTheme(
                data: CupertinoTheme.of(context).copyWith(brightness: Brightness.light),
                child: CupertinoActivityIndicator()))),
          errorWidget: (context, url, error) => new Container(
            height: 100,
            alignment: Alignment.center,
            width: double.infinity,
            child: Icon(Icons.error)),
          fadeOutDuration: new Duration(seconds: 1),
          fadeInDuration: new Duration(seconds: 3))
      ),
      Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(item['judul'], style: TextStyle(fontSize: 17, fontFamily: "NunitoSemiBold", height: 1.5)),
      ),
      Container(
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: <Widget>[
                Icon(Feather.user, size: 12, color: ColorPalette.grey),
                SizedBox(width: 5),
                Text("Mas Admin", style: TextStyle(fontSize: 12, color: ColorPalette.grey)),
              ]
            ),
            SizedBox(height: 5),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: <Widget>[
                Icon(Feather.calendar, size: 12, color: ColorPalette.grey),
                SizedBox(width: 5),
                Text(Jiffy(item['tanggal_pos'].toString()).format("dd MMMM yyyy, HH:mm"), style: TextStyle(fontSize: 12, color: ColorPalette.grey))
              ]
            ),
            SizedBox(height: 5),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: <Widget>[
                Icon(Feather.map_pin, size: 12, color: ColorPalette.grey),
                SizedBox(width: 5),
                Text("Berita " + item['kategori'], style: TextStyle(fontSize: 12, color: ColorPalette.grey))
              ]
            ),
            SizedBox(width: 25),
          ]
        )
      ),
      Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(item['konten'], style: TextStyle(fontSize: 15, height: 1.5)),
      ),
      SizedBox(height: 50)
    ],
  );
}