import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;
import 'dart:developer' as developer;
import 'dart:io';

import 'package:http/http.dart' as http;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:informasi/utils/color_palette.dart';
import 'package:jiffy/jiffy.dart';


var isLoading = true;

// GET ID OF APP AND ADS
String getAppId() {
  if (Platform.isIOS) {
    return null;
  } else if (Platform.isAndroid) {
    return 'ca-app-pub-1029252120939366~8716534287';
  }
  return null;
}
String getBannerAdUnitId() {
  if (Platform.isIOS) {
    return null;
  } else if (Platform.isAndroid) {
    return 'ca-app-pub-1029252120939366/4777289271';
  }
  return null;
}
String getInterstitialAdUnitId() {
  if (Platform.isIOS) {
    return null;
  } else if (Platform.isAndroid) {
    return 'ca-app-pub-1029252120939366/9876608682';
  }
  return null;
}
// END OF

class BeritaDetailBanner extends StatefulWidget {
  @override
  _BeritaDetailBannerState createState() => _BeritaDetailBannerState();
}

class _BeritaDetailBannerState extends State<BeritaDetailBanner> {
  
  // Server URL
  // final String url = "http://10.0.2.2/onlenkan-informasi/";
  // final String url = "http://192.168.43.17/onlenkan-informasi/";
  // final String url = "http://192.168.1.21/onlenkan-informasi/";
  final String url = "https://informasi.onlenkan.org/";
  
  // BANNER
  BannerAd myBanner;

  BannerAd buildBannerAd() {
    return BannerAd(
      adUnitId: getBannerAdUnitId(),
      // adUnitId: BannerAd.testAdUnitId,
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
  }

  @override
  void dispose() {
    super.dispose();
    myBanner.dispose();
  }
  
  // JSON DATA
  List data;
  Future<String> getDataFromJson(String link) async {
    setState(() {
      isLoading = true;
    });

    try {
      final response  = await http.get(url + "api/berita-detail.php?link=" + link);
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

  @override
  Widget build(BuildContext context) {

    final Map<String, Object> intent = ModalRoute.of(context).settings.arguments;

    setState(() {
      getDataFromJson(intent['link']);
    });
    
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Berita", style: TextStyle(color: Colors.white, fontSize: 18.0, fontFamily: "NunitoSemiBold")),
      ),
      body: ListView.builder(
        itemCount: 1,
        itemBuilder: (context, index) {
          return _beritaDetail(data[index]);
        }
      )
    );
  }

  // Berita Detail widger
  Widget _beritaDetail(dynamic item) => Column(
    children: <Widget>[
      ClipRRect(
        child: new CachedNetworkImage(
          fit: BoxFit.cover,
          imageUrl: url + "uploads/berita/" + item['gambar'],
          placeholder: (context, url) => Container(
            alignment: Alignment.center,
            height: 100,
            width: double.infinity,
            child: new CupertinoTheme(
              data: CupertinoTheme.of(context).copyWith(brightness: Brightness.light),
              child: CupertinoActivityIndicator())),
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