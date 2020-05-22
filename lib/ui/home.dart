import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_icons/flutter_icons.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jiffy/jiffy.dart';

import 'package:informasi/utils/color_palette.dart';

import 'signin_google.dart';

import 'download_app.dart';
import 'data_wisata.dart';
import 'data_travel.dart';
import 'data_hotel.dart';
import 'data_kuliner.dart';
import 'data_sekolah.dart';
import 'data_rumah.dart';
import 'data_video.dart';

import 'informasi_darurat.dart';
import 'informasi_layanan.dart';
import 'informasi_pengaduan.dart';
import 'informasi_tanya.dart';

import 'notifikasi.dart';
import 'berita_detail.dart';
import 'berita_detail_banner.dart';
import 'berita_detail_notif.dart';
import 'event_detail.dart';
import 'event_detail_notif.dart';

var isLoading = true;
var isLoadingBanner = true;
var isLoadingCovid = true;
var isLoadingVideo = true;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {

  // FIREBASE + Notification
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  // Shared Session
  bool checkValue, checkLogin;
  SharedPreferences sharedPreferences;
  String googleName, googleEmail, googlePhoto;
  int counterBadge, _counterBadge;

  updateBadge() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
        counterBadge  = sharedPreferences.getInt("badgeNotif");
        _counterBadge = counterBadge != null ? counterBadge : 1;

        sharedPreferences.setInt("badgeNotif", (_counterBadge + 1));

        developer.log(counterBadge.toString(), name: "Session Badge Notif");
    });
  }

  getBadge() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
        _counterBadge  = sharedPreferences.getInt("badgeNotif");
        developer.log(_counterBadge.toString(), name: "Session Badge awal Notif");
    });
  }

  clearSession() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      sharedPreferences.remove("intro");
    });
  }

  getUserLogin() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      checkLogin = sharedPreferences.getBool("login");
      if (checkLogin != null && checkLogin) {
        checkLogin = true;
        googleName  = sharedPreferences.getString("google_name");
        googleEmail = sharedPreferences.getString("google_email");
        googlePhoto = sharedPreferences.getString("google_photo");
      } else {
        checkLogin = false;
      }
    });
    developer.log(checkLogin.toString(), name: 'User SignIn with Google!');
  }

  // Server URL
  // final String url = "http://10.0.2.2/onlenkan-informasi/";
  final String url = "http://192.168.43.17/onlenkan-informasi/";
  // final String url = "http://192.168.1.21/onlenkan-informasi/";
  // final String url = "https://informasi.onlenkan.org/";

  // Tab Bar
  TabController _controller;
  TabController _controller2;
  TabController _controller3;

  @override
  void initState() {
    super.initState();

    this.getDataFromJson();
    this.getBannerJson();
    this.getUserLogin();
    this.initFCM();
    this.initVersion();
    this.getBadge();

    _controller   = new TabController(length: 3, vsync: this);
    _controller2  = new TabController(length: 3, vsync: this);
    _controller3  = new TabController(length: 2, vsync: this);
  }

  // PACKAGE INFO
  String appName, packageName, version, buildNumber;
  void initVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    appName = packageInfo.appName;
    packageName = packageInfo.packageName;
    version = packageInfo.version;
    buildNumber = packageInfo.buildNumber;
  }

  // FIREBASE Firebase Cloud Message
  void initFCM() {

    // LOCAL NOTIFICATION
    flutterLocalNotificationsPlugin   = new FlutterLocalNotificationsPlugin();
    var android                       = new AndroidInitializationSettings('ic_notification');
    var iOS                           = new IOSInitializationSettings();
    var initSetttings                 = new InitializationSettings(android, iOS);
    flutterLocalNotificationsPlugin.initialize(initSetttings, onSelectNotification: onSelectNotification);
    // flutterLocalNotificationsPlugin.initialize(initSetttings);

    _firebaseMessaging.subscribeToTopic("all");
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        showNotification(
          message["notification"]["title"],
          message["notification"]["body"], 
          message["data"]["screen"] + ";" + message["data"]["link"]
        );

        updateBadge();
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        _navigateToItemDetail(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        _navigateToItemDetail(message);
      },
    );

    _firebaseMessaging.requestNotificationPermissions(const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered.listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });

    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      print("Push Messaging token: $token");
    });
  }

  void _navigateToItemDetail(Map<String, dynamic> message) {
    final String pageChooser  = message['data']['screen'];
    // final String pageLink     = message['data']['link'];

    Navigator.pushNamed(context, pageChooser);
  }

  // Local Notification
  showNotification(String title, String content, String payload) async {
    var android = new AndroidNotificationDetails(
        '111', 'Onlenkan', 'ONLENKAN INFORMASI',
        priority: Priority.High,
        importance: Importance.Max,
        channelShowBadge: true, 
    );
    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails(android, iOS);
    await flutterLocalNotificationsPlugin.show(0, title, content, platform, payload: payload);
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      String screen = payload.substring(0, payload.indexOf(';'));
      String link   = payload.substring(payload.indexOf(';') + 1);

      print(screen);
      print(link);

      if (screen == 'berita'){
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BeritaDetailPayload(link)),
        );
      } else if (screen == 'pengumuman') {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Notifikasi()),
        );
      } else if (screen == 'event') {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EventDetailPayload(link)),
        );
      } else if (screen == 'video') {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Video()),
        );
      }
    }
  }

  // Listing Berita
  List dataKab, dataKot, dataNas;
  List dataCovid, dataVideo;
  List dataEvent, dataEventBerlalu;

  Future<String> getDataFromJson() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response  = await http.get(url + "api/covid.php");
      final resVid    = await http.get(url + "api/video.php");
      final resKab    = await http.get(url + "api/berita.php?kategori=kab");
      final resKot    = await http.get(url + "api/berita.php?kategori=kot");
      final resNas    = await http.get(url + "api/berita.php?kategori=nas");
      final resEvent  = await http.get(url + "api/event.php?get=terbaru");
      final resEventB = await http.get(url + "api/event.php?get=berlalu");

      if (response.statusCode == 200) {

        dataCovid         = json.decode(response.body)['semua'];
        dataVideo         = json.decode(resVid.body)['semua'];
        dataKab           = json.decode(resKab.body)['semua'];
        dataKot           = json.decode(resKot.body)['semua'];
        dataNas           = json.decode(resNas.body)['semua'];
        dataEvent         = json.decode(resEvent.body)['semua'];
        dataEventBerlalu  = json.decode(resEventB.body)['semua'];
        
        setState(() {
          isLoading = false;
          isLoadingCovid = false;
          isLoadingVideo = false;
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
    getBadge();
    return 'success';
  }

  // Bottom sheet menu
  int _selectedTabIndex = 0;

  void _onNavBarTapped(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
  }

  // Caraousel image
  CarouselSlider carouselSlider;

  int _current = 0;

  List bannerList, bannerData = [];
  Future<String> getBannerJson() async {
    setState(() {
      isLoadingBanner = true;
    });

    try {
      final resp  = await http.get(url + "api/banner.php");

      if (resp.statusCode == 200) {
        setState(() {
          isLoadingBanner = false;
        });

        bannerList = json.decode(resp.body)['semua'];

        for (var i = 0; i < bannerList.length; i++) {
          bannerData.add(bannerList[i]['banner'] + ";" + bannerList[i]['link']);
        }
        developer.log(bannerData.toString(), name: 'Banner image list');
      }
    } on SocketException {
      developer.log('Koneksi internet tidak tersedia', name: 'Koneksi Internet');
    }
    return 'success';
  }

  // onWillPop or back pressed
  Future<bool> _onWillPop() async {
    _selectedTabIndex == 1 || _selectedTabIndex == 2 || _selectedTabIndex == 3
    ? setState(() {
        _selectedTabIndex = 0;
      })
    : await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => new AlertDialog(
          title: new Text('Konfirmasi', style: TextStyle(fontSize: 16)),
          content: new Text('Yakin ingin menutup aplikasi?', style: TextStyle(fontSize: 14)),
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(8.0)),
          actions: <Widget>[
            new FlatButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: new Text('Tidak')),
            new FlatButton(
              onPressed: () {
                clearSession();
                Navigator.of(context).pop(false);
                SystemNavigator.pop();
              },
              child: new Text('Ya, Tutup')),
          ],
        ),
      );
    return false;
  }

  // Void Main
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.blue,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.black,
      systemNavigationBarIconBrightness: Brightness.light));

    final _listPage = <Widget>[
      // ------------------------------- HALAMAN HOME
      new Column(children: <Widget>[
        new Stack(alignment: Alignment.topLeft, children: <Widget>[
          Container(height: MediaQuery.of(context).size.height - 56),
          new Positioned(
            height: 180.0,
            width: MediaQuery.of(context).size.width,
            child: Container(color: Colors.blue)),
          new Positioned(
            top: 45.0,
            left: 20.0,
            width: MediaQuery.of(context).size.width - 40,
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    updateBadge();
                  },
                  child: Image.asset("images/logo_putih.png", height: 25),
                ),
                Stack(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () =>
                        Navigator.of(context).push(
                          new MaterialPageRoute(builder: (_) => 
                          new Notifikasi())
                        ).then((val) => val ? getBadge() : null),
                      child: Container(
                        width: 30,
                        height: 30,
                        child: Icon(Ionicons.ios_notifications, size: 25, color: Colors.white))
                    ),
                    Positioned(
                      top: 1.0,
                      right: 0.0,
                      child: _counterBadge == null
                        ? Container()
                        : Container(
                            padding: EdgeInsets.all(1.0),
                            decoration: BoxDecoration(
                              color: Color(0xCCFF0000),
                              shape: BoxShape.circle),
                            constraints: BoxConstraints(
                              minWidth: 14.0,
                              minHeight: 14.0),
                            child: Center(
                              child: Text('$_counterBadge',
                                textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 8.0))))
                    )
                  ]
                )
              ]
            )
          ),
          new Positioned(
            top: 70.0,
            child: new Container(
              padding: EdgeInsets.only(top: 10),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: RefreshIndicator(
                onRefresh: getDataFromJson,
                child: ListView(children: <Widget>[
                  new Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.only(bottom: 150),
                    child: isLoading
                      ? Center(child:CupertinoTheme(
                          data: CupertinoTheme.of(context).copyWith(brightness: Brightness.dark),
                          child: CupertinoActivityIndicator()))
                      : new Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            // CAROUSEL IMAGE
                            carouselSlider = new CarouselSlider(
                              height: 160.0,
                              initialPage: 0,
                              enlargeCenterPage: true,
                              autoPlay: true,
                              reverse: false,
                              enableInfiniteScroll: true,
                              autoPlayInterval: Duration(seconds: 5),
                              autoPlayAnimationDuration: Duration(milliseconds: 2000),
                              pauseAutoPlayOnTouch: Duration(seconds: 10),
                              scrollDirection: Axis.horizontal,
                              onPageChanged: (index) {
                                setState(() {
                                  _current = index;
                                });
                              },
                              items: bannerData.map((dataList) {
                                return Builder(builder: (BuildContext context) {
                                  return Container(
                                    width: MediaQuery.of(context).size.width,
                                    margin: EdgeInsets.symmetric(horizontal: 10.0),
                                    decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:BorderRadius.all(Radius.circular(8.0))),
                                    child: GestureDetector(
                                      onTap: () {
                                        String link = dataList.substring(dataList.indexOf(';') + 1);
                                        
                                        if (link.trim() != '') {
                                          Navigator.push(
                                            context, MaterialPageRoute(
                                              builder: (context) => BeritaDetailBanner(),
                                              settings: RouteSettings(
                                                  arguments: {
                                                    "link" : link.trim()
                                                  }
                                              )
                                            )
                                          );
                                        } else {
                                          Fluttertoast.showToast(
                                            msg: "Tidak ada detail khusus untuk gambar ini!",
                                            toastLength: Toast.LENGTH_SHORT,
                                            timeInSecForIosWeb: 1,
                                            gravity: ToastGravity.TOP,
                                            backgroundColor: Colors.red[900],
                                            textColor: Colors.white,
                                            fontSize: 13.0);
                                        }
                                      },
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8.0),
                                        child: CachedNetworkImage(
                                          fit: BoxFit.cover,
                                          imageUrl: url + "uploads/banner/" + dataList.substring(0, dataList.indexOf(';')),
                                          errorWidget: (context, url, error) => new Icon(Icons.error),
                                          placeholder: (context, url) => new Container(
                                            child: Center(
                                              child: CupertinoTheme(
                                                data: CupertinoTheme.of(context).copyWith(brightness: Brightness.light),
                                                child: CupertinoActivityIndicator()))),
                                        )
                                      )
                                    )
                                  );
                                });
                              }).toList(),
                            ),
                            
                            new SizedBox(height: 20),
                            
                            // INFORMASI COVID
                            new Container(
                              height: 390,
                              color: ColorPalette.white,
                              child:
                                isLoadingCovid
                                ? Center(child: CupertinoTheme(
                                  data: CupertinoTheme.of(context).copyWith(brightness: Brightness.light),
                                  child: CupertinoActivityIndicator()))
                                : new ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: 1,
                                  itemBuilder: (context, index) {
                                    return _covidData(dataCovid[index]);
                                  }
                                )
                            ),
                          
                            // KONTEN
                            new Container(
                              color: Color(0xffF5F5F5),
                              padding: EdgeInsets.only(top: 20),
                              child: new Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[

                                  new Container(
                                    margin: EdgeInsets.symmetric(horizontal: 20),
                                    child: Text(
                                      "Pusat Layanan & Informasi", 
                                      style: TextStyle(fontSize: 16, letterSpacing: -0.5, color: ColorPalette.black, fontFamily: "NunitoSemiBold")),
                                  ),

                                  // MENU
                                  // BARIS 1
                                  Container(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(context,
                                              MaterialPageRoute(builder: (context) => DestinasiWisata()),
                                            );
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context).size.width / 4,
                                            padding: EdgeInsets.symmetric(horizontal: 2),
                                            child: Column(
                                              children: <Widget>[
                                                Container(
                                                  decoration: BoxDecoration(
                                                  color: Colors.white,
                                                    borderRadius: new BorderRadius.circular(8.0),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Color(0x10000000),
                                                        blurRadius: 3.0,
                                                        spreadRadius: 1.0,
                                                        offset: Offset(1.0, 3.0))]
                                                  ),
                                                  child: Container(
                                                    height: 50,
                                                    width: 50,
                                                    child: Icon(Ionicons.ios_airplane, size: 30, color: Colors.blue))
                                                ),
                                                SizedBox(height: 5),
                                                Text("Destinasi Wisata", textAlign: TextAlign.center, style: TextStyle(fontSize: 12))
                                              ],
                                            )
                                          )
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(context,
                                              MaterialPageRoute(builder: (context) => Travel()),
                                            );
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context).size.width / 4,
                                            padding: EdgeInsets.symmetric(horizontal: 2),
                                            child: Column(
                                              children: <Widget>[
                                                Container(
                                                  decoration: BoxDecoration(
                                                  color: Colors.white,
                                                    borderRadius: new BorderRadius.circular(8.0),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Color(0x10000000),
                                                        blurRadius: 3.0,
                                                        spreadRadius: 1.0,
                                                        offset: Offset(1.0, 3.0))]
                                                  ),
                                                  child: Container(
                                                    height: 50,
                                                    width: 50,
                                                    child: Icon(Ionicons.ios_car, size: 28, color: Colors.blue))
                                                ),
                                                SizedBox(height: 5),
                                                Text("Travel", textAlign: TextAlign.center, style: TextStyle(fontSize: 13))
                                              ],
                                            )
                                          )
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(context,
                                              MaterialPageRoute(builder: (context) => Hotel()),
                                            );
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context).size.width / 4,
                                            padding: EdgeInsets.symmetric(horizontal: 2),
                                            child: Column(
                                              children: <Widget>[
                                                Container(
                                                  decoration: BoxDecoration(
                                                  color: Colors.white,
                                                    borderRadius: new BorderRadius.circular(8.0),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Color(0x10000000),
                                                        blurRadius: 3.0,
                                                        spreadRadius: 1.0,
                                                        offset: Offset(1.0, 3.0))]
                                                  ),
                                                  child: Container(
                                                    height: 50,
                                                    width: 50,
                                                    child: Icon(Ionicons.ios_bed, size: 26, color: Colors.blue))
                                                ),
                                                SizedBox(height: 5),
                                                Text("Hotel", textAlign: TextAlign.center, style: TextStyle(fontSize: 13))
                                              ],
                                            )
                                          )
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(context,
                                              MaterialPageRoute(builder: (context) => OlehOleh()),
                                            );
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context).size.width / 4,
                                            padding: EdgeInsets.symmetric(horizontal: 2),
                                            child: Column(
                                              children: <Widget>[
                                                Container(
                                                  decoration: BoxDecoration(
                                                  color: Colors.white,
                                                    borderRadius: new BorderRadius.circular(8.0),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Color(0x10000000),
                                                        blurRadius: 3.0,
                                                        spreadRadius: 1.0,
                                                        offset: Offset(1.0, 3.0))]
                                                  ),
                                                  child: Container(
                                                    height: 50,
                                                    width: 50,
                                                    child: Icon(FontAwesome5Solid.utensils, size: 21, color: Colors.blue))
                                                ),
                                                SizedBox(height: 5),
                                                Text("Oleh - Oleh", textAlign: TextAlign.center, style: TextStyle(fontSize: 13))
                                              ],
                                            )
                                          )
                                        ),
                                    ])
                                  ),
                                  // BARIS 2
                                  Container(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(context,
                                              MaterialPageRoute(builder: (context) => RumahSakit())
                                            );
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context).size.width / 4,
                                            padding: EdgeInsets.symmetric(horizontal: 2),
                                            child: Column(
                                              children: <Widget>[
                                                Container(
                                                  decoration: BoxDecoration(
                                                  color: Colors.white,
                                                    borderRadius: new BorderRadius.circular(8.0),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Color(0x10000000),
                                                        blurRadius: 3.0,
                                                        spreadRadius: 1.0,
                                                        offset: Offset(1.0, 3.0))]
                                                  ),
                                                  child: Container(
                                                    height: 50,
                                                    width: 50,
                                                    child: Icon(FontAwesome5Solid.hospital, size: 25, color: Colors.blue))
                                                ),
                                                SizedBox(height: 5),
                                                Text("Rumah Sakit", textAlign: TextAlign.center, style: TextStyle(fontSize: 12))
                                              ],
                                            )
                                          )
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(context,
                                              MaterialPageRoute(builder: (context) =>  Sekolah())
                                            );
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context).size.width / 4,
                                            padding: EdgeInsets.symmetric(horizontal: 2),
                                            child: Column(
                                              children: <Widget>[
                                                Container(
                                                  decoration: BoxDecoration(
                                                  color: Colors.white,
                                                    borderRadius: new BorderRadius.circular(8.0),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Color(0x10000000),
                                                        blurRadius: 3.0,
                                                        spreadRadius: 1.0,
                                                        offset: Offset(1.0, 3.0))]
                                                  ),
                                                  child: Container(
                                                    height: 50,
                                                    width: 50,
                                                    child: Icon(FontAwesome5Solid.school, size: 23, color: Colors.blue))
                                                ),
                                                SizedBox(height: 5),
                                                Text("Daftar Sekolah", textAlign: TextAlign.center, style: TextStyle(fontSize: 12))
                                              ],
                                            )
                                          )
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(context,
                                              MaterialPageRoute(builder: (context) => DownloadApp()),
                                            );
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context).size.width / 4,
                                            padding: EdgeInsets.symmetric(horizontal: 2),
                                            child: Column(
                                              children: <Widget>[
                                                Container(
                                                  decoration: BoxDecoration(
                                                  color: Colors.white,
                                                    borderRadius: new BorderRadius.circular(8.0),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Color(0x10000000),
                                                        blurRadius: 3.0,
                                                        spreadRadius: 1.0,
                                                        offset: Offset(1.0, 3.0))]
                                                  ),
                                                  child: Container(
                                                    height: 50,
                                                    width: 50,
                                                    child: Icon(FontAwesome5Solid.building, size: 23, color: Colors.blue))
                                                ),
                                                SizedBox(height: 5),
                                                Text("Daftar Perusahaan", textAlign: TextAlign.center, style: TextStyle(fontSize: 12))
                                              ],
                                            )
                                          )
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(context,
                                              MaterialPageRoute(builder: (context) => DownloadApp()),
                                            );
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context).size.width / 4,
                                            padding: EdgeInsets.symmetric(horizontal: 2),
                                            child: Column(
                                              children: <Widget>[
                                                Container(
                                                  decoration: BoxDecoration(
                                                  color: Colors.white,
                                                    borderRadius: new BorderRadius.circular(8.0),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Color(0x10000000),
                                                        blurRadius: 3.0,
                                                        spreadRadius: 1.0,
                                                        offset: Offset(1.0, 3.0))]
                                                  ),
                                                  child: Container(
                                                    height: 50,
                                                    width: 50,
                                                    child: Icon(FontAwesome5Solid.briefcase, size: 23, color: Colors.blue))
                                                ),
                                                SizedBox(height: 5),
                                                Text("Lowongan Pekerjaan", textAlign: TextAlign.center, style: TextStyle(fontSize: 12))
                                              ],
                                            )
                                          ),
                                        )
                                    ])
                                  ),
                                  // BARIS 3
                                  Container(
                                    padding: EdgeInsets.only(top: 10, bottom: 40),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(context,
                                              MaterialPageRoute(builder: (context) => Layanan()),
                                            );
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context).size.width / 4,
                                            padding: EdgeInsets.symmetric(horizontal: 2),
                                            child: Column(
                                              children: <Widget>[
                                                Container(
                                                  decoration: BoxDecoration(
                                                  color: Colors.white,
                                                    borderRadius: new BorderRadius.circular(8.0),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Color(0x10000000),
                                                        blurRadius: 3.0,
                                                        spreadRadius: 1.0,
                                                        offset: Offset(1.0, 3.0))]
                                                  ),
                                                  child: Container(
                                                    height: 50,
                                                    width: 50,
                                                    child: Icon(FontAwesome5Solid.headset, size: 25, color: Colors.blue))
                                                ),
                                                SizedBox(height: 5),
                                                Text("Layanan Publik", textAlign: TextAlign.center, style: TextStyle(fontSize: 12))
                                              ],
                                            )
                                          )
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(context,
                                              MaterialPageRoute(builder: (context) => TanyaJawab()),
                                            );
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context).size.width / 4,
                                            padding: EdgeInsets.symmetric(horizontal: 2),
                                            child: Column(
                                              children: <Widget>[
                                                Container(
                                                  decoration: BoxDecoration(
                                                  color: Colors.white,
                                                    borderRadius: new BorderRadius.circular(8.0),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Color(0x10000000),
                                                        blurRadius: 3.0,
                                                        spreadRadius: 1.0,
                                                        offset: Offset(1.0, 3.0))]
                                                  ),
                                                  child: Container(
                                                    height: 50,
                                                    width: 50,
                                                    child: Icon(FontAwesome5Solid.comments, size: 24, color: Colors.blue))
                                                ),
                                                SizedBox(height: 5),
                                                Text("Tanya Jawab", textAlign: TextAlign.center, style: TextStyle(fontSize: 12))
                                              ],
                                            )
                                          )
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(context,
                                              MaterialPageRoute(builder: (context) => Darurat()),
                                            );
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context).size.width / 4,
                                            padding: EdgeInsets.symmetric(horizontal: 2),
                                            child: Column(
                                              children: <Widget>[
                                                Container(
                                                  decoration: BoxDecoration(
                                                  color: Colors.white,
                                                    borderRadius: new BorderRadius.circular(8.0),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Color(0x10000000),
                                                        blurRadius: 3.0,
                                                        spreadRadius: 1.0,
                                                        offset: Offset(1.0, 3.0))]
                                                  ),
                                                  child: Container(
                                                    height: 50,
                                                    width: 50,
                                                    child: Icon(FontAwesome5Solid.phone_volume, size: 26, color: Colors.blue))
                                                ),
                                                SizedBox(height: 5),
                                                Text("Nomor Darurat", textAlign: TextAlign.center, style: TextStyle(fontSize: 12))
                                              ],
                                            )
                                          )
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(context,
                                              MaterialPageRoute(builder: (context) => Pengaduan()),
                                            );
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context).size.width / 4,
                                            padding: EdgeInsets.symmetric(horizontal: 2),
                                            child: Column(
                                              children: <Widget>[
                                                Container(
                                                  decoration: BoxDecoration(
                                                  color: Colors.white,
                                                    borderRadius: new BorderRadius.circular(8.0),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Color(0x10000000),
                                                        blurRadius: 3.0,
                                                        spreadRadius: 1.0,
                                                        offset: Offset(1.0, 3.0))]
                                                  ),
                                                  child: Container(
                                                    height: 50,
                                                    width: 50,
                                                    child: Icon(FontAwesome5Solid.comment_dots, size: 23, color: Colors.blue)
                                                )),
                                                SizedBox(height: 5),
                                                Text("Pengaduan", textAlign: TextAlign.center, style: TextStyle(fontSize: 12))
                                              ],
                                            )
                                          )
                                        ),
                                    ])
                                  ),

                                  // BERITA HOME
                                  new Container(
                                    width: MediaQuery.of(context).size.width,
                                    color: Colors.white,
                                    padding: EdgeInsets.symmetric(vertical: 15),
                                    child: new Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        new Container(
                                          margin: EdgeInsets.symmetric(horizontal: 20),
                                          child: Text(
                                            "Berita Terkini", 
                                            style: TextStyle(fontSize: 16, letterSpacing: -0.5, color: ColorPalette.black, fontFamily: "NunitoSemiBold")),
                                        ),
                                        // Tab bar berita
                                        new Container(
                                          constraints: BoxConstraints.expand(height: 40),
                                          child: TabBar(
                                            controller: _controller,
                                            labelColor: Colors.blue,
                                            labelStyle: TextStyle(fontFamily: "NunitoSemiBold"),
                                            unselectedLabelColor: Colors.blueGrey,
                                            indicator: UnderlineTabIndicator(
                                              insets: EdgeInsets.symmetric(horizontal:35.0),
                                              borderSide: BorderSide(width: 2, color:Colors.blue)),
                                            tabs: [
                                              Tab(text: "Kabupaten"),
                                              Tab(text: "Kota"),
                                              Tab(text: "Nasional")
                                            ]
                                          )
                                        ),
                                        new Container(
                                          height: 380.0,
                                          color: Colors.white,
                                          margin: EdgeInsets.only(top: 10),
                                          child: TabBarView(
                                            controller: _controller,
                                            children: [
                                              Container(
                                                child: _buildListViewSmall(dataKab),
                                              ),
                                              Container(
                                                child: _buildListViewSmall(dataKot),
                                              ),
                                              Container(
                                                child: _buildListViewSmall(dataNas),
                                              ),
                                            ]),
                                        ),
                                        new Container(
                                          width: double.infinity,
                                          margin: EdgeInsets.only(left: 20, right: 20, top: 5),
                                          child: new FlatButton(
                                            child: Text("Selengkapnya"),
                                            color: Colors.blueAccent,
                                            textColor: Colors.white,
                                            shape: new RoundedRectangleBorder(
                                              borderRadius: new BorderRadius.circular(8.0)),
                                            onPressed: () {
                                              setState(() {
                                                _selectedTabIndex = 1;
                                              });
                                            }
                                          )
                                        )
                                      ]
                                    )
                                  ),

                              ])
                            ),

                            new Container(
                              width: double.infinity,
                              margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                              child: new Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        "Video Terkini", 
                                        style: TextStyle(fontSize: 16, letterSpacing: -0.5, color: ColorPalette.black, fontFamily: "NunitoSemiBold")),   
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(context,
                                            MaterialPageRoute(builder: (context) => Video()));
                                        },
                                        child: Container(
                                          width: 90,
                                          alignment: Alignment.centerRight,
                                          child: Text("Selengkapnya", style: TextStyle(fontSize: 12, color: ColorPalette.dark)))
                                      )
                                    ]
                                  ),
                                ]
                              )
                            ),
                            
                            Container(
                              height: 176,
                              margin: EdgeInsets.only(top: 5),
                              padding: EdgeInsets.only(left: 15),
                              child: isLoadingVideo
                                ? CupertinoTheme(
                                  data: CupertinoTheme.of(context).copyWith(brightness: Brightness.light),
                                  child: CupertinoActivityIndicator())
                                : _buildListVideo(dataVideo)
                            )
                            
                          ]
                        )
                  )
                ])
              )
            )
          )
        ])
      ]),

      // ------------------------------- HALAMAN BERITA
      new Column(children: <Widget>[
        Stack(alignment: Alignment.topLeft, children: <Widget>[
          Container(height: 86.0),
          Positioned(
            width: MediaQuery.of(context).size.width,
            child: Container(
              padding: EdgeInsets.only(top: 40, bottom: 15),
              decoration: new BoxDecoration(
                color: Colors.blue,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6.0,
                    spreadRadius: 1.0,
                    offset: Offset(0.0, 0.0))]
              ),
              child: Column(children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: 10),
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Berita Terkini",
                    style: TextStyle(color: Colors.white, fontSize: 18.0, fontFamily: "NunitoSemiBold")),
                ),
              ])
            ))
        ]),
        new Container(
          color: Colors.blue,
          constraints: BoxConstraints.expand(height: 50),
          child: TabBar(
            controller: _controller2,
            labelColor: Colors.white,
            labelStyle: TextStyle(fontFamily: "NunitoSemiBold"),
            unselectedLabelColor: Colors.white60,
            indicator: UnderlineTabIndicator(
              borderSide: BorderSide(width: 4, color:Colors.white)),
            tabs: [
              Tab(text: "Kabupaten"),
              Tab(text: "Kota"),
              Tab(text: "Nasional")
            ]
          ),
        ),
        new Container(
          height: MediaQuery.of(context).size.height - 192.0,
          child: TabBarView(
            controller: _controller2,
            children: [
              RefreshIndicator(
                child: _buildListView(dataKab),
                onRefresh: getDataFromJson,
              ),
              RefreshIndicator(
                child: _buildListView(dataKot),
                onRefresh: getDataFromJson,
              ),
              RefreshIndicator(
                child: _buildListView(dataNas),
                onRefresh: getDataFromJson,
              ),
            ]),
        ),
      ]),

      // ------------------------------- HALAMAN EVENT
      new Column(children: <Widget>[
        Stack(alignment: Alignment.topLeft, children: <Widget>[
          Container(height: 86.0),
          Positioned(
            width: MediaQuery.of(context).size.width,
            child: Container(
              padding: EdgeInsets.only(top: 40, bottom: 15),
              decoration: new BoxDecoration(
                color: Colors.blue,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6.0,
                    spreadRadius: 1.0,
                    offset: Offset(0.0, 0.0))]
              ),
              child: Column(children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: 10),
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Daftar Event",
                    style: TextStyle(color: Colors.white, fontSize: 18.0, fontFamily: "NunitoSemiBold")),
                )
              ])
            ))
        ]),
        new Container(
          color: Colors.blue,
          constraints: BoxConstraints.expand(height: 50),
          child: TabBar(
            controller: _controller3,
            labelColor: Colors.white,
            labelStyle: TextStyle(fontFamily: "NunitoSemiBold"),
            unselectedLabelColor: Colors.white60,
            indicator: UnderlineTabIndicator(
              borderSide: BorderSide(width: 4, color:Colors.white)),
            tabs: [
              Tab(text: "Akan Datang"),
              Tab(text: "Berlalu")
            ]
          ),
        ),
        new Container(
          height: MediaQuery.of(context).size.height - 192.0,
          child: isLoading
            ? CupertinoTheme(
                data: CupertinoTheme.of(context).copyWith(brightness: Brightness.light),
                child: CupertinoActivityIndicator())
            : TabBarView(
                controller: _controller3,
                children: [
                  RefreshIndicator(
                    onRefresh: getDataFromJson,
                    child: dataEvent.isEmpty
                      ? _dataKosong("Event terbaru")
                      : new ListView.builder(
                          itemCount: dataEvent.length,
                          itemBuilder: (context, index) {
                            return _eventData(dataEvent[index]);
                          })
                  ),
                  RefreshIndicator(
                    onRefresh: getDataFromJson,
                    child: dataEventBerlalu.isEmpty
                      ? _dataKosong("Event")
                      : new ListView.builder(
                          itemCount: dataEventBerlalu.length,
                          itemBuilder: (context, index) {
                            return _eventData(dataEventBerlalu[index]);
                          }),
                  )
                ])
        )

      ]),

      // ------------------------------- HALAMAN PROFIL
      new Column(children: <Widget>[
        Stack(alignment: Alignment.topLeft, children: <Widget>[
          Container(height: 90.0),
          Positioned(
            width: MediaQuery.of(context).size.width,
            child: Container(
              padding: EdgeInsets.only(top: 40, bottom: 15),
              decoration: new BoxDecoration(
                color: Colors.blue,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6.0,
                    spreadRadius: 1.0,
                    offset: Offset(0.0, 0.0))]
              ),
              child: Column(children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: 10),
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Profil Pengguna",
                    style: TextStyle(color: Colors.white, fontSize: 18.0, fontFamily: "NunitoSemiBold")),
                )
              ])
            ))
        ]),
        checkLogin
        ? Container(
            height: MediaQuery.of(context).size.height - 146.0,
            width: MediaQuery.of(context).size.width,
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              shrinkWrap: true,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      child: new CachedNetworkImage(
                        height: 70.0,
                        width: 70.0,
                        fit: BoxFit.cover,
                        imageUrl: googlePhoto == '' ? url + 'img/logo.png' : googlePhoto,
                        placeholder: (context, url) => Container(
                          width: 70.0,
                          height: 70.0,
                          child: new CupertinoTheme(
                            data: CupertinoTheme.of(context).copyWith(brightness: Brightness.light),
                            child: CupertinoActivityIndicator())
                        ),
                        errorWidget: (context, url, error) => new Icon(Icons.error),
                        fadeOutDuration: new Duration(seconds: 1),
                        fadeInDuration: new Duration(seconds: 1)),
                    ),
                    SizedBox(width: 15),
                    Container(
                      width: 235.0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(googleName,
                            style: TextStyle(height: 1.5, fontSize: 18, fontFamily: "NunitoSemiBold"),
                            overflow: TextOverflow.ellipsis, maxLines: 1, softWrap: true),
                          Text(googleEmail,
                            style: TextStyle(height: 1.5, fontSize: 16),
                            overflow: TextOverflow.ellipsis, maxLines: 1, softWrap: true)
                        ]
                      )
                    )
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 30),
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [BoxShadow(
                      color: Color(0x08666666),
                      blurRadius: 1.0,
                      spreadRadius: 1.0,
                      offset: Offset(0.0, 2.0)
                    )]
                  ),
                  child: InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => new AlertDialog(
                          title: new Text('QR Code', style: TextStyle(fontSize: 16)),
                          content: new Text('Coming soon!', style: TextStyle(fontSize: 14)),
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(8.0)),
                          actions: <Widget>[
                            new FlatButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: new Text('Oke')),
                          ],
                        ),
                      );
                    },
                    splashColor: Color(0x50666666),
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 50,
                          alignment: Alignment.centerLeft,
                          child: Image.asset("images/qr_code.png", height: 30),
                        ),
                        Text("Tampilkan QR Code", style: TextStyle(fontSize: 14))
                      ],
                    ),
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(top: 30),
                  padding: EdgeInsets.symmetric(vertical: 13, horizontal: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [BoxShadow(
                      color: Color(0x08666666),
                      blurRadius: 1.0,
                      spreadRadius: 1.0,
                      offset: Offset(0.0, 2.0)
                    )]
                  ),
                  child: Column(
                    children: <Widget>[
                      InkWell(
                        onTap: () {

                        },
                        splashColor: Color(0x50666666),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: 50,
                              padding: EdgeInsets.only(left: 2, bottom: 3),
                              alignment: Alignment.centerLeft,
                              child: Icon(SimpleLineIcons.pencil, size: 21),
                            ),
                            Text("Ubah Profil", style: TextStyle(fontSize: 14))
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Divider(height: 1, color: Color(0xAAEEEEEE)),
                      ),
                      InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => new AlertDialog(
                              title: new Text('Versi Aplikasi', style: TextStyle(fontSize: 16)),
                              content: new Text(appName + " v" + version, style: TextStyle(fontSize: 14)),
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(8.0)),
                              actions: <Widget>[
                                new FlatButton(
                                  onPressed: () => Navigator.of(context).pop(false),
                                  child: new Text('Oke')),
                              ],
                            ),
                          );
                        },
                        splashColor: Color(0x50666666),
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: 50,
                              padding: EdgeInsets.only(left: 2, bottom: 3),
                              alignment: Alignment.centerLeft,
                              child: Icon(SimpleLineIcons.info, size: 21),
                            ),
                            Text("App Version", style: TextStyle(fontSize: 14))
                          ],
                        ),
                      )
                    ],
                  ) 
                ),

                SizedBox(height: 40),
                RaisedButton(
                  onPressed: () {
                    signOutGoogle();
                    
                    setState(() {
                      checkLogin = false;
                    });
                  },
                  elevation: 2,
                  color: Colors.redAccent,
                  padding: EdgeInsets.symmetric(vertical: 13),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13)),
                  child: Text("Logout",
                    style: TextStyle(color: Colors.white, height: 1, fontSize: 15, fontFamily: "NunitoSemiBold"))
                )
                
              ],
            )
          )

        : SingleChildScrollView(
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 120),
              Image.asset("images/icon_search.png", alignment: Alignment.center, width: MediaQuery.of(context).size.width / 1.8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 30),
                alignment: Alignment.center,
                child: Column(children: <Widget>[
                  SizedBox(height: 40),
                  Text(
                    "Bantu stop penyebaran Covid-19 dengan melakukan login pada app Onlenkan Informasi.",
                    textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: ColorPalette.dark, height: 1.6)),
                  SizedBox(height: 20),
                  Text(
                    "Data Anda akan aman dan tidak pernah diakses,\nkecuali jika Anda dekat dengan kasus positif Covid-19.",
                    textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: ColorPalette.grey)),
                  SizedBox(height: 20),
                ])
              ),
              OutlineButton(
                splashColor: Color(0xffCCCCCC),
                highlightElevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                borderSide: BorderSide(color: ColorPalette.ccc, width: 1),
                onPressed: () {
                  signInWithGoogle().whenComplete(() {
                    setState(() {
                      checkLogin = true;
                      sharedPreferences.setBool("login", checkLogin);
                      print(imageUrl);
                    });
                    getDataFromJson();
                    getUserLogin();
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image(image: AssetImage("images/google_logo.png"), height: 17.0),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          'Login dengan Google',
                          style: TextStyle(fontSize: 14, color: ColorPalette.black))
                      )
                    ]
                  ))
                )
            ])
          )
      ])
    ];

    final _bottomNavBarItems = <BottomNavigationBarItem>[
      BottomNavigationBarItem(icon: Icon(Feather.home), title: Text("Home")),
      BottomNavigationBarItem(icon: Icon(Feather.book_open), title: Text("Berita")),
      BottomNavigationBarItem(icon: Icon(Feather.check_square), title: Text("Event")),
      BottomNavigationBarItem(icon: Icon(Feather.user), title: Text("Profil"))
    ];

    final _bottomNavBar = BottomNavigationBar(
      currentIndex: _selectedTabIndex,
      items: _bottomNavBarItems,
      onTap: _onNavBarTapped,
      
      type: BottomNavigationBarType.fixed,
      iconSize: 22.0,
      elevation: 8.0,
      selectedItemColor: ColorPalette.primaryColor,
      selectedFontSize: 12.0,
      unselectedItemColor: ColorPalette.grey,
      unselectedFontSize: 11.0,
      showUnselectedLabels: true,
    );

    // ------ SCAFFOLD
    return new WillPopScope(
      onWillPop: _onWillPop,
      child: new Scaffold(
        body: _listPage[_selectedTabIndex],
              bottomNavigationBar: _bottomNavBar,
              backgroundColor: Color(0xfff5f5f5),
        )
      );
  }

  // COVID DATA
  Widget _covidData(dynamic item) => Card(
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
    margin: EdgeInsets.only(top: 5),
    child: new Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(20),
      alignment: Alignment.topLeft,
      child: Column(children: <Widget>[
        new Container(
          alignment: Alignment.topLeft,
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                "Update Terkini Probolinggo",
                style: TextStyle(fontSize: 16, letterSpacing: -0.5, color: ColorPalette.black, fontFamily: "NunitoSemiBold")),
              Text(
                Jiffy(item["update_terakhir"]).format("dd MMMM yyyy, HH:mm"),
                style: TextStyle(fontSize: 12, color: ColorPalette.dark)),
            ]
          )
        ),
        SizedBox(height: 10),
        new Row(children: <Widget>[
          new Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.only(right: 5.0),
            width: MediaQuery.of(context).size.width / 3 - 20.0,
            height: 90,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              image: DecorationImage(
                image: AssetImage("images/back_covid_1.jpg"),
                fit: BoxFit.cover
              )
            ),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Terkonfirmasi",
                  style: TextStyle(color: Colors.white, fontSize: 13, fontFamily: "NunitoSemiBold")),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: <Widget>[
                    Text(
                      item['positif'],
                      style: TextStyle(color: Colors.white, fontSize: 22, fontFamily: "NunitoSemiBold")),
                    Text(
                      " Orang",
                      style: TextStyle(color: Colors.white, fontSize: 12, fontFamily: "NunitoSemiBold")),
                  ])
            ])
          ),
          new Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.only(left: 5.0, right: 5.0),
            width: MediaQuery.of(context).size.width / 3 - 20.0,
            height: 90,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              image: DecorationImage(
                image: AssetImage("images/back_covid_2.jpg"),
                fit: BoxFit.cover
              )
            ),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Sembuh",
                  style: TextStyle(color: Colors.white, fontSize: 13, fontFamily: "NunitoSemiBold")),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: <Widget>[
                    Text(
                      item['sembuh'],
                      style: TextStyle(color: Colors.white, fontSize: 22, fontFamily: "NunitoSemiBold")),
                    Text(
                      " Orang",
                      style: TextStyle(color: Colors.white, fontSize: 12, fontFamily: "NunitoSemiBold")),
                  ])
            ])
          ),
          new Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.only(left: 5.0),
            width: MediaQuery.of(context).size.width / 3 - 20.0,
            height: 90,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              image: DecorationImage(
                image: AssetImage("images/back_covid_3.jpg"),
                fit: BoxFit.cover
              )
            ),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Meninggal", 
                  style: TextStyle(color: Colors.white, fontSize: 13, fontFamily: "NunitoSemiBold")),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: <Widget>[
                    Text(
                      item['meninggal'],
                      style: TextStyle(color: Colors.white, fontSize: 22, fontFamily: "NunitoSemiBold")),
                    Text(
                      " Orang",
                      style: TextStyle(color: Colors.white, fontSize: 12, fontFamily: "NunitoSemiBold")),
                  ])
            ])
          )
        ]),
        SizedBox(height: 15),
        new Row(children: <Widget>[
          new Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.only(right: 5.0),
            width: MediaQuery.of(context).size.width / 2 - 25,
            height: 90,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(width: 1, color: ColorPalette.ccc),
              borderRadius:
                BorderRadius.all(Radius.circular(8.0))),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Orang Dalam Pemantauan (ODP)",
                  style: TextStyle(color: ColorPalette.grey, fontSize: 13, fontFamily: "NunitoSemiBold")),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: <Widget>[
                    Text(
                      item['odp'],
                      style: TextStyle(color: ColorPalette.black, fontSize: 22, fontFamily: "NunitoSemiBold")),
                    Text(
                      " Orang",
                      style: TextStyle(color: ColorPalette.grey, fontSize: 12, fontFamily: "NunitoSemiBold")),
                  ])
            ])
          ),
          new Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.only(left: 5.0),
            width: MediaQuery.of(context).size.width / 2 - 25,
            height: 90,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(width: 1, color: ColorPalette.ccc),
              borderRadius:
                BorderRadius.all(Radius.circular(8.0))),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Pasien Dalam Pemantauan (PDP)",
                  style: TextStyle(color: ColorPalette.grey, fontSize: 13, fontFamily: "NunitoSemiBold")),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: <Widget>[
                    Text(
                      item['pdp'],
                      style: TextStyle(color: ColorPalette.black, fontSize: 22, fontFamily: "NunitoSemiBold")),
                    Text(
                      " Orang",
                      style: TextStyle(color: ColorPalette.grey, fontSize: 12, fontFamily: "NunitoSemiBold")),
                  ])
            ])
          ),
        ]),
        SizedBox(height: 20.0),
        new Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(bottom: 20),
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Color(0xffFF7575),
          ),
          child: Row(children: <Widget>[
            Image.asset("images/icon_otw.png", width: 80.0),
            new Container(
              width: 200.0,
              margin: EdgeInsets.only(left: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(0),
                    child: Text(
                      "Jumlah Pemudik dari luar Kab. Probolinggo yang mangkel",
                      maxLines: 2, style: TextStyle(fontSize: 13, color: Color(0xffdddddd))),
                  ),
                  SizedBox(height: 5.0),
                  new Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: <Widget>[
                      Text(
                        item['pemudik'],
                        style: TextStyle(color: ColorPalette.white, fontSize: 24.0, fontFamily: "NunitoSemiBold")),
                      Text(
                        " Orang",
                        style: TextStyle(color: ColorPalette.ccc, fontSize: 12, fontFamily: "NunitoSemiBold")),
                    ]
                  )
              ])
            )
          ])
        ),
      ])
    )
  );

  // BERITA PAGE
  Widget _buildListView(List berita) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: berita == null ? 0 : berita.length,
      itemBuilder: (context, index) {
        return _buildImageColumn(berita[index]);
      }
    );
  }

  Widget _buildImageColumn(dynamic item) => GestureDetector(
    onTap: () {
      Navigator.push(
        context, MaterialPageRoute(
          builder: (context) => BeritaDetail(),
          settings: RouteSettings(
              arguments: {
                "kategori"  : item['kategori'],
                "gambar"    : url + "uploads/berita/" + item['gambar'],
                "judul"     : item['judul'],
                "konten"    : item['konten'],
                "tag"       : item['tag'],
                "lihat"     : item['lihat'],
                "tanggal"   : item['tanggal_pos']
              }
          )
        )
      );
    },
    child: Container(
      margin: const EdgeInsets.only(left: 4, right: 4, top: 3, bottom: 17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [BoxShadow(
          color: Color(0x15000000),
          blurRadius: 5.0,
          spreadRadius: 0.5,
          offset: Offset(1.0, 1.5))
        ]
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(6), topRight: Radius.circular(6)),
            child: new CachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl: url + "uploads/berita/" + item['gambar'],
              placeholder: (context, url) => new Container(
                height: 150.0,
                child: new CupertinoTheme(
                  data: CupertinoTheme.of(context).copyWith(brightness: Brightness.light),
                  child: CupertinoActivityIndicator()),
              ),
              errorWidget: (context, url, error) => new Icon(Icons.error),
              fadeOutDuration: new Duration(seconds: 1),
              fadeInDuration: new Duration(seconds: 1),
            )
          ),
          SizedBox(height: 5),
          ListTile(
            title: Text(
              item['judul'],
              style: TextStyle(fontSize: 14, height: 1.3), maxLines: 2, overflow: TextOverflow.ellipsis, softWrap: true),
            subtitle: Text(
              Jiffy(item['tanggal_pos'].toString()).format("dd MMMM yyyy, HH:mm"),
              style: TextStyle(fontSize: 12, height: 2.0, color: ColorPalette.grey))
          ),
        ]
      )
    )
  );

  // BERITA LIST SMALL ----------------------
  Widget _buildListViewSmall(List dataBerita) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      itemCount: dataBerita.length <= 4 ? dataBerita.length : 4,
      itemBuilder: (context, index) {
        return _buildImageColumnSmall(dataBerita[index]);
      }
    );
  }

  Widget _buildImageColumnSmall(dynamic item) => GestureDetector(
    onTap: () {
      Navigator.push(
        context, MaterialPageRoute(
          builder: (context) => BeritaDetail(),
          settings: RouteSettings(
              arguments: {
                "kategori"  : item['kategori'],
                "gambar"    : url + "uploads/berita/" + item['gambar'],
                "judul"     : item['judul'],
                "konten"    : item['konten'],
                "tag"       : item['tag'],
                "lihat"     : item['lihat'],
                "tanggal"   : item['tanggal_pos']
              }
          )
        )
      );
    },
    child: Container(
      margin: const EdgeInsets.only(left: 4, right: 4, top: 3, bottom: 12),
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
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(6), bottomLeft: Radius.circular(6)),
            child: 
              new CachedNetworkImage(
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                imageUrl: url + "uploads/berita/" + item['gambar'],
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
          SizedBox(width: 6.0),
          Container(
            width: MediaQuery.of(context).size.width - 126.0,
            padding: EdgeInsets.only(right: 8),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  item['judul'], 
                  style: TextStyle(fontSize: 14, height: 1.5), maxLines: 2, overflow: TextOverflow.ellipsis, softWrap: true),
                SizedBox(height: 5),
                Text(
                  Jiffy(item['tanggal_pos'].toString()).format("dd MMMM yyyy, HH:mm"),
                  style: TextStyle(fontSize: 12, color: ColorPalette.grey)),
              ]
            )
          )
        ]
      )
    )
  );

  // VIDEO LIST SMALL
  Widget _buildListVideo(List video) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 4,
      itemBuilder: (context, index) {
        return _buildCard(video[index]);
      }
    );
  }

  Widget _buildCard(dynamic item) => GestureDetector(
    onTap: () async {
      String url = item['link'];

      if (await canLaunch(url)) {
        await launch(url, forceSafariVC: false, forceWebView: false);
      }
    },
    child: Container(
      width: 200,
      margin: EdgeInsets.only(left: 5, right: 10, top: 3, bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Color(0x10000000),
            blurRadius: 4.0,
            spreadRadius: 1.0,
            offset: Offset(0.0, 2.0))]
      ),
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 115.0,
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(6),
                      topRight: Radius.circular(6)),
                    child: CachedNetworkImage(
                      height: 115.0,
                      fit: BoxFit.cover,
                      imageUrl: url + "uploads/video/" + item['gambar'],
                      placeholder: (context, url) => CupertinoTheme(
                        data: CupertinoTheme.of(context).copyWith(brightness: Brightness.light),
                        child: CupertinoActivityIndicator()),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                      fadeOutDuration: Duration(seconds: 1),
                      fadeInDuration: Duration(seconds: 1)),
                  ),
                  Container(
                    height: 40,
                    width: 40,
                    margin: EdgeInsets.only(top: 4),
                    decoration: BoxDecoration(
                      color: Color(0xAAFFFFFF),
                      borderRadius: BorderRadius.all(Radius.circular(20)))
                  ),
                  Icon(Ionicons.ios_play_circle, size: 50, color: Color(0xBBFF0000))
                ],
              )
            )
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
            child: Text(
              item['nama_video'],
              style: TextStyle(fontSize: 14, color: ColorPalette.dark), maxLines: 2, overflow: TextOverflow.ellipsis, softWrap: true),
          )
        ],
      )
    )
  );

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