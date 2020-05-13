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
                placeholder: (context, url) => new CupertinoActivityIndicator(),
                errorWidget: (context, url, error) => new Icon(Icons.error),
                fadeOutDuration: new Duration(seconds: 1),
                fadeInDuration: new Duration(seconds: 3),
              )
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(intent['judul'], style: TextStyle(fontSize: 17, fontFamily: "NunitoSemiBold", height: 1.5)),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              width: double.infinity,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: <Widget>[
                  Icon(Feather.user, size: 12, color: ColorPalette.grey),
                  SizedBox(width: 4),
                  Text("Mas Admin", style: TextStyle(fontSize: 12, color: ColorPalette.grey)),
                  SizedBox(width: 25),
                  Icon(Feather.calendar, size: 12, color: ColorPalette.grey),
                  SizedBox(width: 4),
                  Text(Jiffy(intent['tanggal'].toString()).format("dd MMMM yyyy, HH:mm"), style: TextStyle(fontSize: 12, color: ColorPalette.grey)),
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