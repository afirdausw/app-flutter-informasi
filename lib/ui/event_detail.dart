import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:jiffy/jiffy.dart';
import 'package:informasi/utils/color_palette.dart';

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

class EventDetail extends StatefulWidget {
  @override
  _EventDetailState createState() => _EventDetailState();
}

class _EventDetailState extends State<EventDetail> {

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


  @override
  Widget build(BuildContext context) {

    final  Map<String, Object> intent = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Event", style: TextStyle(color: Colors.white, fontSize: 18.0, fontFamily: "NunitoSemiBold")),
      ),
      body: SafeArea(
        bottom: false,
        top: false,
        child: ListView(
          children: <Widget>[
            ClipRRect(
              child: new CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: intent['gambar'],
                placeholder: (context, url) => new Container(
                  height: 100,
                  alignment: Alignment.center,
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
            SizedBox(height: 30),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text("Judul Event", style: TextStyle(fontSize: 12, fontFamily: "NunitoLight", color: ColorPalette.grey, height: 2)),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(intent['judul'], style: TextStyle(fontSize: 17, fontFamily: "NunitoSemiBold", height: 1.5)),
            ),
            SizedBox(height: 15),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text("Waktu Event", style: TextStyle(fontSize: 12, fontFamily: "NunitoLight", color: ColorPalette.grey, height: 2)),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(Jiffy(intent['waktu'].toString()).format("dd MMMM yyyy, HH:mm"), style: TextStyle(fontSize: 17, height: 1.5)),
            ),
            SizedBox(height: 15),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text("Deskripsi", style: TextStyle(fontSize: 12, fontFamily: "NunitoLight", color: ColorPalette.grey, height: 2.3)),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(intent['deskripsi'], style: TextStyle(fontSize: 16, height: 1.5)),
            ),
            SizedBox(height: 70)
          ]
        )
      )
    );
  }
}