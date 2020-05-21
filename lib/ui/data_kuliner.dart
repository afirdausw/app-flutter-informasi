import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'dart:io' show Platform;
import 'dart:developer' as developer;

import 'package:http/http.dart' as http;

import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:informasi/utils/color_palette.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';

var isLoading = false;

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

class OlehOleh extends StatefulWidget {
  @override
  OlehOlehState createState() => OlehOlehState();
}

class OlehOlehState extends State<OlehOleh> {

  // Server URL
  // final String url = "http://10.0.2.2/onlenkan-informasi/";
  // final String url = "http://192.168.43.17/onlenkan-informasi/";
  // final String url = "http://192.168.1.21/onlenkan-informasi/";
  final String url = "https://informasi.onlenkan.org/";
 
  // ADS
  InterstitialAd myInterstitial;

  InterstitialAd buildInterstitialAd() {
    return InterstitialAd(
      // adUnitId: getInterstitialAdUnitId(),
      adUnitId: InterstitialAd.testAdUnitId,
      listener: (MobileAdEvent event) {
        if (event == MobileAdEvent.failedToLoad) {
          myInterstitial..load();
        } else if (event == MobileAdEvent.closed) {
          myInterstitial = buildInterstitialAd()..load();
        }
        print(event);
      },
    );
  }

  startShowAds() async {
    return Timer(const Duration(seconds: 5), () {
      myInterstitial..show();
    });
  }

  // InitState
  @override
  void initState() {
    super.initState();
    this.getData();

    FirebaseAdMob.instance.initialize(appId: getAppId());
    myInterstitial = buildInterstitialAd()..load();

    startShowAds();
  }

  @override
  void dispose() {
    super.dispose();
    myInterstitial.dispose();
  }

  // GET DATA
  List data;
  
  Future<String> getData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(url + "api/kuliner.php");
      if (response.statusCode == 200) {
        data = json.decode(response.body)['semua'];
        setState(() {
          isLoading = false;
        });
      } else {
        developer.log('Gagal mengambil data', name: 'Koneksi Server');
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
        title: Text("Daftar Oleh - Oleh", style: TextStyle(color: Colors.white, fontSize: 18.0, fontFamily: "NunitoSemiBold")),
      ),
      body: isLoading ? Center(child: Container(child: CupertinoTheme( data: CupertinoTheme.of(context).copyWith(brightness: Brightness.light), child: CupertinoActivityIndicator())))
                      : Padding(padding: EdgeInsets.all(1), child: _buildGridView()),
    );
  }

  Widget _buildGridView() {
    return GridView.count(
      primary: true,
      crossAxisCount: 2,
      childAspectRatio: 0.90,
      children: List.generate(data.length, (index) {
        return _getGridData(data[index]);
      }),
    );
  }

  Widget _getGridData(dynamic item) => Stack(
    alignment: Alignment.bottomCenter,
    children: <Widget>[
      item['gambar'] == ''
      ? Image.asset(
          "images/default.png",
          height: double.infinity,
          width: double.infinity
        )
      : CachedNetworkImage(
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        imageUrl: url + "uploads/kuliner/" + item['gambar'],
        placeholder: (context, url) => new Container(
          height: 150.0,
          child: new CupertinoTheme(data: CupertinoTheme.of(context).copyWith(brightness: Brightness.light), child: CupertinoActivityIndicator()),
        ),
        errorWidget: (context, url, error) => new Icon(Icons.error),
        fadeOutDuration: new Duration(seconds: 1),
        fadeInDuration: new Duration(seconds: 1),
      ),
      Container(
        height: 50,
        margin: EdgeInsets.all(2),
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        color: Color(0x70000000),
        alignment: Alignment.bottomCenter,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              item['nama_kuliner'],
              maxLines: 1,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                height: 1.6,
                color: Colors.white,
                fontSize: 14 )),
            SizedBox(height: 2),
            Text(
              item['alamat'],
              maxLines: 1,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                height: 1.0,
                color: Color(0xffCCCCCC),
                fontSize: 10,
                fontFamily: "NunitoLight" )),
          ],
        )
      ),
      GestureDetector(
        onTap: () {
          showModal(context, item['nama_kuliner'], item['alamat'], item['telepon'], item['gambar'], item['google_maps']);
        },
        child: Container(
          height: double.infinity,
          decoration: BoxDecoration(
            color: Color(0x00FFFFFF),
            border: Border.all(width: 2, color: Colors.white)
          )
        )
      )
    ],
  );

  void showModal(context, String nama, String alamat, String telepon, String gambar, String gmaps){
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(2),
          height: MediaQuery.of(context).size.height * 0.70,
          decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: new BorderRadius.all(Radius.circular(20.0)),
            boxShadow: [BoxShadow(blurRadius: 10, color: Color(0x20000000), spreadRadius: 5)],
          ),
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        boxShadow: [BoxShadow(
                          color: Color(0x40000000),
                          blurRadius: 10.0,
                          spreadRadius: 1.5,
                          offset: Offset(0.0, 3.0))
                        ]
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        child: gambar == ''
                        ? Image.asset(
                            "images/default.png",
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          )
                        : CachedNetworkImage(
                          fit: BoxFit.cover,
                          width: double.infinity,
                          imageUrl: url + "uploads/kuliner/" + gambar,
                          placeholder: (context, url) => new Container(
                            height: 150.0,
                            child: new CupertinoTheme(data: CupertinoTheme.of(context).copyWith(brightness: Brightness.light), child: CupertinoActivityIndicator()),
                          ),
                          errorWidget: (context, url, error) => new Icon(Icons.error),
                          fadeOutDuration: new Duration(seconds: 1),
                          fadeInDuration: new Duration(seconds: 1),
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(top: 10),
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("Nama Oleh - Oleh", style: TextStyle(fontSize: 10, color: ColorPalette.grey)),
                          Text(nama, style: TextStyle(fontSize: 15, color: ColorPalette.black, fontFamily: "NunitoSemiBold" )),
                          SizedBox(height: 10),
                          Text("Alamat", style: TextStyle(fontSize: 10, color: ColorPalette.grey)),
                          Text(alamat, style: TextStyle(fontSize: 15, height: 1.5, color: ColorPalette.black, fontFamily: "NunitoSemiBold" )),
                          SizedBox(height: 10),
                          Text("Telepon", style: TextStyle(fontSize: 10, color: ColorPalette.grey)),
                          Text(telepon.length < 2 ? '-' : telepon, style: TextStyle(fontSize: 15, color: ColorPalette.black, fontFamily: "NunitoSemiBold" )),
                        ]
                      )
                    ),
                  ]
                )
              ),
              
              gmaps == ''
              ? Text("")
              : OutlineButton(
                splashColor: Color(0x40CCCCCC),
                highlightElevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                borderSide: BorderSide(color: Color(0xFF32AB54), width: 1),
                highlightedBorderColor: Color(0xFF30A350),
                onPressed: () async {
                  if (await canLaunch(gmaps)) {
                    await launch(url, forceSafariVC: false, forceWebView: false);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 6, 0, 6),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.directions, size: 20, color: Color(0xFF32AB54)),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          'Buka di Google Maps',
                          style: TextStyle(fontSize: 14, color: Color(0xFF32AB54))
                        )
                      )
                    ]
                  )
                )
              )
            ]

          )
        );
      }
    );
  }

}