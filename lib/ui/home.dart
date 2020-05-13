import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:http/http.dart' as http;

import 'package:flutter_icons/flutter_icons.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:jiffy/jiffy.dart';

import 'package:informasi/utils/color_palette.dart';

import 'signin_google.dart';
import 'download_app.dart';

import 'profile.dart';
import 'berita_detail.dart';


var isLoading = false;
var isLoadingCovid = false;

class Home extends StatefulWidget {

  Home({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  // Server URL
  final String url = "http://10.0.2.2/onlenkan-informasi/";
  // final String url = "http://192.168.43.17/onlenkan-informasi/";
  // final String url = "http://192.168.1.21/onlenkan-informasi/";

  // Tab Bar
  TabController _controller;
  TabController _controller2;

  @override
  void initState() {
    super.initState();
    this.getDataCovid();

    this.getBeritaKab();
    this.getBeritaKot();
    this.getBeritaNas();

    this.getDataVideo();
    _controller = new TabController(length: 3, vsync: this);
    _controller2 = new TabController(length: 3, vsync: this);
  }

  // Listing Berita
  List dataKab, dataKot, dataNas;
  
  Future<String> getBeritaKab() async {
    setState(() {
      isLoading = true;
    });

    final response = await http.get(url + "api/berita.php?kategori=kab");
    if (response.statusCode == 200) {
      dataKab = json.decode(response.body)['semua'];
      setState(() {
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load data');
    }
    return 'success';
  }

  Future<String> getBeritaKot() async {
    setState(() {
      isLoading = false;
    });

    final response = await http.get(url + "api/berita.php?kategori=kot");
    if (response.statusCode == 200) {
      dataKot = json.decode(response.body)['semua'];
      setState(() {
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load data');
    }
    return 'success';
  }

  Future<String> getBeritaNas() async {
    setState(() {
      isLoading = false;
    });

    final response = await http.get(url + "api/berita.php?kategori=nas");
    if (response.statusCode == 200) {
      dataNas = json.decode(response.body)['semua'];
      setState(() {
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load data');
    }
    return 'success';
  }

  // Info Covid-19
  List dataCovid;
  Future<String> getDataCovid() async {
    setState(() {
      isLoadingCovid = true;
    });

    final res = await http.get(url + "api/covid.php");
    if (res.statusCode == 200) {
      dataCovid = json.decode(res.body)['semua'];
      setState(() {
        isLoadingCovid = false;
      });
    } else {
      throw Exception('Failed to load data');
    }
    return 'success';
  }

  // List Video
  List dataVideo;
  Future<String> getDataVideo() async {
    final res = await http.get(url + "api/video.php");
    if (res.statusCode == 200) {
      dataVideo = json.decode(res.body)['semua'];
    } else {
      throw Exception('Failed to load data');
    }
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

  List imgList = [
    'images/carousel/slide_1.jpg',
    'images/carousel/slide_2.jpg',
    'images/carousel/slide_3.jpg',
    'images/carousel/slide_4.jpg',
    'images/carousel/slide_5.jpg',
    'images/carousel/slide_6.jpg'
  ];

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  // onWillPop or back pressed
  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Do you want to exit an App'),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('No'),
          ),
          new FlatButton(
            onPressed: () {
              Navigator.of(context).pop(false);
              SystemNavigator.pop();
            },
            child: new Text('Yes'),
          ),
        ],
      ),
    )) ?? false;
  }

  // Void Main
  @override
  Widget build(BuildContext context) {
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
                Image.asset("images/logo_putih.png", height: 25),
                GestureDetector(
                  onTap: () {
                    //
                  },
                  child: Stack(
                    children: <Widget>[
                      Icon(
                        Ionicons.ios_notifications, size: 25, color: Colors.white),
                      Positioned(
                        top: 1.0,
                        right: 0.0,
                        child: Container(
                          padding: EdgeInsets.all(1.0),
                          decoration: BoxDecoration(
                            color: Color(0xCCFF0000),
                            shape: BoxShape.circle,
                          ),
                          constraints: BoxConstraints(
                            minWidth: 14.0,
                            minHeight: 14.0,
                          ),
                          child: Center(
                            child: Text("6", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 8.0))
                          )
                        )
                      )
                    ]
                  )
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
              child: ListView(children: <Widget>[
                new Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(bottom: 150),
                  child:
                    isLoading ? Center(child: CupertinoTheme( data: CupertinoTheme.of(context).copyWith(brightness: Brightness.dark), child: CupertinoActivityIndicator())) :
                  new Column(
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
                        items: imgList.map((imgUrl) {
                          return Builder(builder: (BuildContext context) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.symmetric(horizontal: 10.0),
                              decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:BorderRadius.all(Radius.circular(8.0))),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.asset(
                                  imgUrl,
                                  fit: BoxFit.cover,
                                )
                              )
                            );
                          });
                        }).toList(),
                      ),
                      new SizedBox(height: 20),
                      
                      // INFORMASI COVID
                      new Container(
                        height: 400,
                        child:
                        isLoadingCovid ? Center(child: CupertinoActivityIndicator()) :
                        new ListView.builder(
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
                        child: 
                          new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[

                              new Container(
                                margin: EdgeInsets.symmetric(horizontal: 20),
                                child: Text("Pusat Layanan & Informasi", style: TextStyle(fontSize: 16, letterSpacing: -0.5, color: ColorPalette.black, fontFamily: "NunitoSemiBold")),
                              ),

                              // MENU
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: 
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: () {
                                        //
                                      },
                                      child: Container(
                                        width: MediaQuery.of(context).size.width / 4,
                                        padding: EdgeInsets.symmetric(horizontal: 2),
                                        child: Column(
                                          children: <Widget>[
                                            Card(
                                              elevation: 4,
                                              color: Colors.white,
                                              shape:  new RoundedRectangleBorder(
                                                borderRadius: new BorderRadius.circular(8.0)),
                                              child: Container(
                                                height: 50,
                                                width: 50,
                                                child: Icon(FontAwesome5.heart)
                                            )),
                                            SizedBox(height: 5),
                                            Text("Destinasi Wisata", textAlign: TextAlign.center, style: TextStyle(fontSize: 13))
                                          ],
                                        )
                                      )
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        //
                                      },
                                      child: Container(
                                        width: MediaQuery.of(context).size.width / 4,
                                        padding: EdgeInsets.symmetric(horizontal: 2),
                                        child: Column(
                                          children: <Widget>[
                                            Card(
                                              elevation: 4,
                                              color: Colors.white,
                                              shape:  new RoundedRectangleBorder(
                                                borderRadius: new BorderRadius.circular(8.0)),
                                              child: Container(
                                                height: 50,
                                                width: 50,
                                                child: Icon(FontAwesome5.heart)
                                            )),
                                            SizedBox(height: 5),
                                            Text("Travel", textAlign: TextAlign.center, style: TextStyle(fontSize: 13))
                                          ],
                                        )
                                      )
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        //
                                      },
                                      child: Container(
                                        width: MediaQuery.of(context).size.width / 4,
                                        padding: EdgeInsets.symmetric(horizontal: 2),
                                        child: Column(
                                          children: <Widget>[
                                            Card(
                                              elevation: 4,
                                              color: Colors.white,
                                              shape:  new RoundedRectangleBorder(
                                                borderRadius: new BorderRadius.circular(8.0)),
                                              child: Container(
                                                height: 50,
                                                width: 50,
                                                child: Icon(FontAwesome5.heart)
                                            )),
                                            SizedBox(height: 5),
                                            Text("Hotel", textAlign: TextAlign.center, style: TextStyle(fontSize: 13))
                                          ],
                                        )
                                      )
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        //
                                      },
                                      child: Container(
                                        width: MediaQuery.of(context).size.width / 4,
                                        padding: EdgeInsets.symmetric(horizontal: 2),
                                        child: Column(
                                          children: <Widget>[
                                            Card(
                                              elevation: 4,
                                              color: Colors.white,
                                              shape:  new RoundedRectangleBorder(
                                                borderRadius: new BorderRadius.circular(8.0)),
                                              child: Container(
                                                height: 50,
                                                width: 50,
                                                child: Icon(FontAwesome5.heart)
                                            )),
                                            SizedBox(height: 5),
                                            Text("Oleh - Oleh", textAlign: TextAlign.center, style: TextStyle(fontSize: 13))
                                          ],
                                        )
                                      )
                                    ),
                                ])
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: 
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: () {
                                        //
                                      },
                                      child: Container(
                                        width: MediaQuery.of(context).size.width / 4,
                                        padding: EdgeInsets.symmetric(horizontal: 2),
                                        child: Column(
                                          children: <Widget>[
                                            Card(
                                              elevation: 4,
                                              color: Colors.white,
                                              shape:  new RoundedRectangleBorder(
                                                borderRadius: new BorderRadius.circular(8.0)),
                                              child: Container(
                                                height: 50,
                                                width: 50,
                                                child: Icon(FontAwesome5.heart)
                                            )),
                                            SizedBox(height: 5),
                                            Text("Daftar Rumah Sakit", textAlign: TextAlign.center, style: TextStyle(fontSize: 13))
                                          ],
                                        )
                                      )
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        //
                                      },
                                      child: Container(
                                        width: MediaQuery.of(context).size.width / 4,
                                        padding: EdgeInsets.symmetric(horizontal: 2),
                                        child: Column(
                                          children: <Widget>[
                                            Card(
                                              elevation: 4,
                                              color: Colors.white,
                                              shape:  new RoundedRectangleBorder(
                                                borderRadius: new BorderRadius.circular(8.0)),
                                              child: Container(
                                                height: 50,
                                                width: 50,
                                                child: Icon(FontAwesome5.heart)
                                            )),
                                            SizedBox(height: 5),
                                            Text("Daftar Sekolah", textAlign: TextAlign.center, style: TextStyle(fontSize: 13))
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
                                            Card(
                                              elevation: 4,
                                              color: Colors.white,
                                              shape:  new RoundedRectangleBorder(
                                                borderRadius: new BorderRadius.circular(8.0)),
                                              child: Container(
                                                height: 50,
                                                width: 50,
                                                child: Icon(FontAwesome5.heart)
                                            )),
                                            SizedBox(height: 5),
                                            Text("Daftar Perusahaan", textAlign: TextAlign.center, style: TextStyle(fontSize: 13))
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
                                            Card(
                                              elevation: 4,
                                              color: Colors.white,
                                              shape:  new RoundedRectangleBorder(
                                                borderRadius: new BorderRadius.circular(8.0)),
                                              child: Container(
                                                height: 50,
                                                width: 50,
                                                child: Icon(FontAwesome5.heart)
                                            )),
                                            SizedBox(height: 5),
                                            Text("Lowongan Pekerjaan", textAlign: TextAlign.center, style: TextStyle(fontSize: 13))
                                          ],
                                        )
                                      ),
                                    )
                                    
                                ])
                              ),
                              Container(
                                padding: EdgeInsets.only(top: 10, bottom: 40),
                                child: 
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: () {
                                        //
                                      },
                                      child: Container(
                                        width: MediaQuery.of(context).size.width / 4,
                                        padding: EdgeInsets.symmetric(horizontal: 2),
                                        child: Column(
                                          children: <Widget>[
                                            Card(
                                              elevation: 4,
                                              color: Colors.white,
                                              shape:  new RoundedRectangleBorder(
                                                borderRadius: new BorderRadius.circular(8.0)),
                                              child: Container(
                                                height: 50,
                                                width: 50,
                                                child: Icon(FontAwesome5.heart)
                                            )),
                                            SizedBox(height: 5),
                                            Text("Layanan Publik", textAlign: TextAlign.center, style: TextStyle(fontSize: 13))
                                          ],
                                        )
                                      )
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        //
                                      },
                                      child: Container(
                                        width: MediaQuery.of(context).size.width / 4,
                                        padding: EdgeInsets.symmetric(horizontal: 2),
                                        child: Column(
                                          children: <Widget>[
                                            Card(
                                              elevation: 4,
                                              color: Colors.white,
                                              shape:  new RoundedRectangleBorder(
                                                borderRadius: new BorderRadius.circular(8.0)),
                                              child: Container(
                                                height: 50,
                                                width: 50,
                                                child: Icon(FontAwesome5.heart)
                                            )),
                                            SizedBox(height: 5),
                                            Text("Tanya Jawab", textAlign: TextAlign.center, style: TextStyle(fontSize: 13))
                                          ],
                                        )
                                      )
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        //
                                      },
                                      child: Container(
                                        width: MediaQuery.of(context).size.width / 4,
                                        padding: EdgeInsets.symmetric(horizontal: 2),
                                        child: Column(
                                          children: <Widget>[
                                            Card(
                                              elevation: 4,
                                              color: Colors.white,
                                              shape:  new RoundedRectangleBorder(
                                                borderRadius: new BorderRadius.circular(8.0)),
                                              child: Container(
                                                height: 50,
                                                width: 50,
                                                child: Icon(FontAwesome5.heart)
                                            )),
                                            SizedBox(height: 5),
                                            Text("Nomor Darurat", textAlign: TextAlign.center, style: TextStyle(fontSize: 13))
                                          ],
                                        )
                                      )
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        //
                                      },
                                      child: Container(
                                        width: MediaQuery.of(context).size.width / 4,
                                        padding: EdgeInsets.symmetric(horizontal: 2),
                                        child: Column(
                                          children: <Widget>[
                                            Card(
                                              elevation: 4,
                                              color: Colors.white,
                                              shape:  new RoundedRectangleBorder(
                                                borderRadius: new BorderRadius.circular(8.0)),
                                              child: Container(
                                                height: 50,
                                                width: 50,
                                                child: Icon(FontAwesome5.heart)
                                            )),
                                            SizedBox(height: 5),
                                            Text("Pengaduan", textAlign: TextAlign.center, style: TextStyle(fontSize: 13))
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
                                      child: Text("Berita Terkini", style: TextStyle(fontSize: 16, letterSpacing: -0.5, color: ColorPalette.black, fontFamily: "NunitoSemiBold")),
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
                                          borderSide: BorderSide(width: 2, color:Colors.blue)
                                        ),
                                        tabs: [
                                          Tab(text: "Kabupaten"),
                                          Tab(text: "Kota"),
                                          Tab(text: "Nasional")
                                        ]
                                      )
                                    ),
                                    new Container(
                                      margin: EdgeInsets.only(top: 10),
                                      height: 380.0,
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
                                Text("Video Terkini", style: TextStyle(fontSize: 16, letterSpacing: -0.5, color: ColorPalette.black, fontFamily: "NunitoSemiBold")),   
                                GestureDetector(
                                  onTap: () {
                                    Scaffold.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text("Sedang dalam pengembangan."),
                                        action: SnackBarAction(
                                          label: "Oke",
                                          onPressed: Scaffold.of(context).hideCurrentSnackBar
                                        )
                                      )
                                    );
                                  },
                                  child: Text("Selengkapnya", style: TextStyle(fontSize: 12, color: ColorPalette.dark))
                                )    
                            ]),
                          ]
                        )
                      ),
                      
                      Container(
                        height: 160,
                        margin: EdgeInsets.only(top: 5),
                        padding: EdgeInsets.only(left: 15),
                        child: _buildListVideo(dataVideo)
                      )
                      
                    ]
                  )
                )
              ])
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
              borderSide: BorderSide(width: 4, color:Colors.white)
            ),
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
                child: isLoading  ? Center(child: Container(child: CupertinoTheme( data: CupertinoTheme.of(context).copyWith(brightness: Brightness.light), child: CupertinoActivityIndicator())))
                                  : _buildListView(dataKab),
                onRefresh: getBeritaKab,
              ),
              RefreshIndicator(
                child: isLoading  ? Center(child: Container(child: CupertinoTheme( data: CupertinoTheme.of(context).copyWith(brightness: Brightness.light), child: CupertinoActivityIndicator())))
                                  : _buildListView(dataKot),
                onRefresh: getBeritaKot,
              ),
              RefreshIndicator(
                child: isLoading  ? Center(child: Container(child: CupertinoTheme( data: CupertinoTheme.of(context).copyWith(brightness: Brightness.light), child: CupertinoActivityIndicator())))
                                  : _buildListView(dataNas),
                onRefresh: getBeritaNas,
              ),
            ]),
        ),
      ]),

      // ------------------------------- HALAMAN NOTIFIKASI
      new Column(children: <Widget>[
        Stack(alignment: Alignment.topLeft, children: <Widget>[
          Container(height: 100.0),
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
                    "Notifikasi dari Onlenkan",
                    style: TextStyle(color: Colors.white, fontSize: 18.0, fontFamily: "NunitoSemiBold")),
                )
              ])
            ))
        ]),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          width: MediaQuery.of(context).size.width,
          child: Text("Hallo from notifikasi")
        ),
        CupertinoActivityIndicator()

      ]),

      // ------------------------------- HALAMAN PROFIL
      new Column(children: <Widget>[
        Stack(alignment: Alignment.topLeft, children: <Widget>[
          Container(height: 100.0),
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
        SingleChildScrollView(
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
                Text("Bantu stop penyebaran Covid-19 dengan melakukan login pada app Onlenkan Informasi.", textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: ColorPalette.dark, height: 1.6)),
                SizedBox(height: 20),
                Text("Data Anda akan aman dan tidak pernah diakses,\nkecuali jika Anda dekat dengan kasus positif Covid-19.", textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: ColorPalette.grey)),
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
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return Profile();
                      }
                    )
                  );
                });
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image(image: AssetImage("images/google_logo.png"), height: 20.0),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        'Sign in with Google',
                        style: TextStyle(fontSize: 14, color: ColorPalette.black)
                      )
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
    color: ColorPalette.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
    margin: EdgeInsets.only(top: 10),
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
              Text("Update Terkini Probolinggo", style: TextStyle(fontSize: 16, letterSpacing: -0.5, color: ColorPalette.black, fontFamily: "NunitoSemiBold")),
              Text(Jiffy(item["update_terakhir"]).format("dd MMMM yyyy, HH:mm"), style: TextStyle(fontSize: 12, color: ColorPalette.dark)),
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
                Text("Terkonfirmasi", style: TextStyle(color: Colors.white, fontSize: 13, fontFamily: "NunitoSemiBold")),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: <Widget>[
                  Text(item['positif'], style: TextStyle(color: Colors.white, fontSize: 22, fontFamily: "NunitoSemiBold")),
                  Text(" Orang", style: TextStyle(color: Colors.white, fontSize: 12, fontFamily: "NunitoSemiBold")),
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
                Text("Sembuh", style: TextStyle(color: Colors.white, fontSize: 13, fontFamily: "NunitoSemiBold")),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: <Widget>[
                  Text(item['sembuh'], style: TextStyle(color: Colors.white, fontSize: 22, fontFamily: "NunitoSemiBold")),
                  Text(" Orang", style: TextStyle(color: Colors.white, fontSize: 12, fontFamily: "NunitoSemiBold")),
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
                Text("Meninggal", style: TextStyle(color: Colors.white, fontSize: 13, fontFamily: "NunitoSemiBold")),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: <Widget>[
                  Text(item['meninggal'], style: TextStyle(color: Colors.white, fontSize: 22, fontFamily: "NunitoSemiBold")),
                  Text(" Orang", style: TextStyle(color: Colors.white, fontSize: 12, fontFamily: "NunitoSemiBold")),
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
                Text("Orang Dalam Pemantauan (ODP)", style: TextStyle(color: ColorPalette.grey, fontSize: 13, fontFamily: "NunitoSemiBold")),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: <Widget>[
                  Text(item['odp'], style: TextStyle(color: ColorPalette.black, fontSize: 22, fontFamily: "NunitoSemiBold")),
                  Text(" Orang", style: TextStyle(color: ColorPalette.grey, fontSize: 12, fontFamily: "NunitoSemiBold")),
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
                Text("Pasien Dalam Pemantauan (PDP)", style: TextStyle(color: ColorPalette.grey, fontSize: 13, fontFamily: "NunitoSemiBold")),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: <Widget>[
                  Text(item['pdp'], style: TextStyle(color: ColorPalette.black, fontSize: 22, fontFamily: "NunitoSemiBold")),
                  Text(" Orang", style: TextStyle(color: ColorPalette.grey, fontSize: 12, fontFamily: "NunitoSemiBold")),
                ])
            ])
          ),
        ]),
        SizedBox(height: 20.0),
        new Container(
          width: MediaQuery.of(context).size.width,
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
                    child: Text("Jumlah Pemudik dari luar Kab. Probolinggo yang mangkel", maxLines: 2, style: TextStyle(fontSize: 13, color: Color(0xffdddddd))),
                  ),
                  SizedBox(height: 5.0),
                  new Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: <Widget>[
                    Text(item['pemudik'], style: TextStyle(color: ColorPalette.white, fontSize: 24.0, fontFamily: "NunitoSemiBold")),
                    Text(" Orang", style: TextStyle(color: ColorPalette.ccc, fontSize: 12, fontFamily: "NunitoSemiBold")),
                  ])
              ])
            )
          ])
        ),
        new SizedBox(height: 10.0),
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
                child: new CupertinoActivityIndicator(),
              ),
              errorWidget: (context, url, error) => new Icon(Icons.error),
              fadeOutDuration: new Duration(seconds: 1),
              fadeInDuration: new Duration(seconds: 1),
            )
          ),
          SizedBox(height: 5),
          ListTile(
            title: Text(item['judul'], style: TextStyle(fontSize: 14, height: 1.3), maxLines: 2, overflow: TextOverflow.ellipsis, softWrap: true),
            subtitle: Text(Jiffy(item['tanggal_pos'].toString()).format("dd MMMM yyyy, HH:mm"), style: TextStyle(fontSize: 12, height: 2.0, color: ColorPalette.grey))
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
      itemCount: dataBerita == null ? 0 : 4,
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
                placeholder: (context, url) => new CupertinoActivityIndicator(),
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
                Text(item['judul'], style: TextStyle(fontSize: 14, height: 1.5), maxLines: 2, overflow: TextOverflow.ellipsis, softWrap: true),
                SizedBox(height: 5),
                Text(Jiffy(item['tanggal_pos'].toString()).format("dd MMMM yyyy, HH:mm"), style: TextStyle(fontSize: 12, color: ColorPalette.grey)),
                
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
      height: 150,
      width: 200,
      margin: EdgeInsets.only(left: 5, right: 10, top: 3, bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Color(0x05000000),
            blurRadius: 4.0,
            spreadRadius: 1.0,
            offset: Offset(0.0, 2.0))]
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Center(
            child: Text(item['nama_video'], style: TextStyle(color: Colors.grey)),
          ),
          Text(item['nama_video'], style: TextStyle(color: ColorPalette.dark)),
        ],
      )
    )
  );
}