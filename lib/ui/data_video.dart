import 'dart:async';
import 'dart:convert';

import 'dart:io' show Platform;

import 'package:flutter_icons/flutter_icons.dart';
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

class Video extends StatefulWidget {
  @override
  VideoState createState() => VideoState();
}

class VideoState extends State<Video> {

  // Server URL
  final String url = "http://10.0.2.2/onlenkan-informasi/";
  // final String url = "http://192.168.43.17/onlenkan-informasi/";
  // final String url = "http://192.168.1.21/onlenkan-informasi/";
  // final String url = "https://informasi.onlenkan.org/";
 
  // ADS
  InterstitialAd myInterstitial;

  InterstitialAd buildInterstitialAd() {
    return InterstitialAd(
      adUnitId: getInterstitialAdUnitId(),
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
    return Timer(const Duration(seconds: 9), () {
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

    final res = await http.get(url + "api/video.php");
    if (res.statusCode == 200) {
      data = json.decode(res.body)['semua'];
      setState(() {
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load data');
    }
    return 'success';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Daftar Video", style: TextStyle(color: Colors.white, fontSize: 18.0, fontFamily: "NunitoSemiBold")),
      ),
      body: isLoading 
        ? Center(child: Container(child: CupertinoTheme(
          data: CupertinoTheme.of(context).copyWith(brightness: Brightness.light),
          child: CupertinoActivityIndicator())))
        : _buildListView(),
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      primary: true,
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      itemCount: data.length,
      itemBuilder: (context, index) {
        return _buildListData(data[index]);
      }
    );
  }

  Widget _buildListData(dynamic item) => GestureDetector(
    onTap: () async {
      String url = item['link'];
      if (await canLaunch(url)) {
        await launch(url, forceSafariVC: false, forceWebView: false);
      }
    },
    child: Container(
      margin: const EdgeInsets.only(bottom: 15, left: 10, right: 10),
      decoration: BoxDecoration(
        color: Color(0xffffffff),
        borderRadius: BorderRadius.circular(6),
        boxShadow: [BoxShadow(
          color: Color(0x15000000),
          blurRadius: 5.0,
          spreadRadius: 0.5,
          offset: Offset(1.0, 1.5))
        ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 200.0,
            width: double.infinity,
            decoration: BoxDecoration(
              boxShadow: [BoxShadow(
                color: Color(0x40000000),
                blurRadius: 10.0,
                spreadRadius: 1.5,
                offset: Offset(0.0, 3.0))
              ]
            ),
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(6),
                      topRight: Radius.circular(6)),
                    child: new CachedNetworkImage(
                      height: 200.0,
                      fit: BoxFit.cover,
                      imageUrl: url + "uploads/video/" + item['gambar'],
                      placeholder: (context, url) => new CupertinoTheme(
                        data: CupertinoTheme.of(context).copyWith(brightness: Brightness.light),
                        child: CupertinoActivityIndicator()),
                      errorWidget: (context, url, error) => new Icon(Icons.error),
                      fadeOutDuration: new Duration(seconds: 1),
                      fadeInDuration: new Duration(seconds: 1)),
                  ),
                  new Container(
                    height: 64,
                    width: 64,
                    margin: EdgeInsets.only(top: 8),
                    decoration: BoxDecoration(
                      color: Color(0xAAFFFFFF),
                      borderRadius: BorderRadius.all(Radius.circular(32)))
                  ),
                  new Icon(Ionicons.ios_play_circle, size: 80, color: Color(0xBBFF0000))
                ],
              )
            )
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            child: Text(
              item['nama_video'],
              style: TextStyle(fontSize: 15, fontFamily: "NunitoSemiBold", color: ColorPalette.dark, height: 1.5)),
          ),
        ]
      )
    )
  );

}