import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_icons/flutter_icons.dart';
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

class BeritaDetail extends StatefulWidget {
  @override
  _BeritaDetailState createState() => _BeritaDetailState();
}

class _BeritaDetailState extends State<BeritaDetail> {

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
        title: Text("Detail Berita", style: TextStyle(color: Colors.white, fontSize: 18.0, fontFamily: "NunitoSemiBold")),
      ),
      body: 
        ListView(
          children: <Widget>[
            ClipRRect(
              child: new CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: intent['gambar'],
                placeholder: (context, url) => new Container(
                  height: 100,
                  alignment: Alignment.center,
                  width: double.infinity,
                  child: Center(
                    child: new CupertinoTheme(
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
              child: Text(intent['judul'], style: TextStyle(fontSize: 17, fontFamily: "NunitoSemiBold", height: 1.5)),
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
                      Text(Jiffy(intent['tanggal'].toString()).format("dd MMMM yyyy, HH:mm"), style: TextStyle(fontSize: 12, color: ColorPalette.grey))
                    ]
                  ),
                  SizedBox(height: 5),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: <Widget>[
                      Icon(Feather.map_pin, size: 12, color: ColorPalette.grey),
                      SizedBox(width: 5),
                      Text("Berita " + intent['kategori'], style: TextStyle(fontSize: 12, color: ColorPalette.grey))
                    ]
                  ),
                  SizedBox(width: 25),
                ]
              )
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(intent['konten'], style: TextStyle(fontSize: 15, height: 1.5)),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: OutlineButton(
                splashColor: Color(0x50CCCCCC),
                highlightElevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                borderSide: BorderSide(color: ColorPalette.ccc, width: 1),
                highlightedBorderColor: Color(0xffaaaaaa),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Berita Lainnya', style: TextStyle(fontSize: 14, color: ColorPalette.black))
              )
            ),
            SizedBox(height: 50)
          ]
        )
    );
  }
}