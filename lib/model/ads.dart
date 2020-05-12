import 'dart:math';
import 'dart:io' show Platform;

import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';

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


class Ads extends StatefulWidget {
  @override
  _AdsState createState() => _AdsState();
}

class _AdsState extends State<Ads> {

  @override
  void initState() {
    super.initState();
    FirebaseAdMob.instance.initialize(appId: getAppId());

    myInterstitial = buildInterstitialAd()..load();
    myBanner = buildBannerAd()..load();
    // myBanner = buildLargeBannerAd()..load();
  }

  @override
  void dispose() {
    super.dispose();
    myInterstitial.dispose();
    myBanner.dispose();
  }
  
  // INTERSTITIAL
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

  void showInterstitialAd() {
    myInterstitial..show();
  }

  void showRandomInterstitialAd() {
    Random r = new Random();
    bool value = r.nextBool();

    if (value == true) {
      myInterstitial..show();
    }
  }

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

  BannerAd buildLargeBannerAd() {
    return BannerAd(
        adUnitId: getBannerAdUnitId(),
        size: AdSize.largeBanner,
        listener: (MobileAdEvent event) {
          if (event == MobileAdEvent.loaded) {
            myBanner
              ..show(
                  anchorType: AnchorType.top,
                  anchorOffset: MediaQuery.of(context).size.height * 0.15);
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}