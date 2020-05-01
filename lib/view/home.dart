import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:pusatinformasi/utils/color_palette.dart';

import 'package:pusatinformasi/view/profile.dart';
import 'package:pusatinformasi/view/signin.dart';
import 'package:pusatinformasi/view/intro.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  // Listing Berita
  final List<String> menu = ["Terkini", "Terbaru", "Kategori", "Tags"];

  List data;

  // Function to get the JSON data
  Future<String> getJSONData() async {
    var response = await http.get(
        // Encode the url
        Uri.encodeFull("https://unsplash.com/napi/photos/Q14J2k8VE3U/related"),

        // Only accept JSON response
        headers: {"Accept": "application/json"},
    );

    setState(() {
      data = json.decode(response.body)['results'];
    });

    return "Successfull";
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

  @override
  void initState() {
    super.initState();
    this.getJSONData();
  }

  // Void Main
  @override
  Widget build(BuildContext context) {

    final _listPage = <Widget> [
      // ------------------------------- HALAMAN HOME
      Column(children: <Widget>[
        Stack(
          alignment: Alignment.topLeft,
          children: <Widget>[
            Container(
              height: 250.0
            ),
            Positioned(
              height: 180.0,
              width: MediaQuery.of(context).size.width,
              child: Container(
                color: Colors.blue
              )
            ),
            Positioned(
              top: 20.0,
              left: 20.0,
              child: Container(
                child: Image.asset("images/logo_putih.png"),
                height: 25
              )
            ),
            Positioned(
              top: 50.0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 200.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    carouselSlider = CarouselSlider(
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
                        return Builder(
                          builder: (BuildContext context) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.symmetric(horizontal: 10.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(8.0))
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.asset(
                                  imgUrl,
                                  fit: BoxFit.cover,
                                )
                              )
                            );
                          }
                        );
                      }).toList(),
                    )
                  ]
                )
              )
            )
          ]
        ),

        Card(
          elevation: 1,
          shape:RoundedRectangleBorder(
            borderRadius:  BorderRadius.circular(0)
          ),
          color: ColorPalette.white,
          margin: EdgeInsets.only(top: 10, bottom: 20),
          child: Container(
            height: 200,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(20),
            alignment: Alignment.topLeft,
            child: Row(children: <Widget>[
                Container(
                  child: Text("Berita Terkini", style: TextStyle(
                      fontFamily: "NunitoSemiBold",
                      fontSize: 18,
                      color: ColorPalette.black
                    )
                  )
                )
              ]
            )
          )
        ),

        Center(child: Icon(Feather.instagram, size: 60, color: Colors.blue)),

        Center(child: Container(
            width: 200,
            color: Colors.lightBlue,
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.fromLTRB(0, 15, 0, 20),
            child: Text(
              "This is home,\nSemoga berhasil belajar Flutter nya.",
              textAlign: TextAlign.center,
              overflow: TextOverflow.clip,
              style: TextStyle(fontSize: 20, color: Colors.white, letterSpacing: 0.5),
            )
          )
        ),
        
        Container(
          width: double.infinity,
          margin: EdgeInsets.only(left: 20, right: 20),
          child: FlatButton(
            child: Text("Profile Page".toUpperCase()),
            color: Colors.blueAccent,
            textColor: Colors.white,
            onPressed: () {
              Navigator.push(context,
                MaterialPageRoute(builder: (context) => Profile()),
              );
            }
          )
        ),

        Container(
          width: double.infinity,
          margin: EdgeInsets.only(left: 20, right: 20),
          child: FlatButton(
            child: Text("Signin Page".toUpperCase()),
            color: Colors.blueAccent,
            textColor: Colors.white,
            shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(8.0)
            ),
            onPressed: () {
              Navigator.push(context,
                MaterialPageRoute(builder: (context) => Signin()),
              );
            }
          )
        ),

        Container(
          width: double.infinity,
          margin: EdgeInsets.only(left: 20, right: 20),
          child: FlatButton(
            child: Text("Intro Page".toUpperCase()),
            color: Colors.blueAccent,
            textColor: Colors.white,
            shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(18.0)
            ),
            onPressed: () {
              Navigator.push(context,
                MaterialPageRoute(builder: (context) => IntroPage()),
              );
            }
          )
        ),

      ]),

      // ------------------------------- HALAMAN BERITA
      SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 20),
          padding: EdgeInsets.all(0),
          height: MediaQuery.of(context).size.height / 18,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: menu.length,
            itemBuilder: (context, index) {
              return Container(
                width: MediaQuery.of(context).size.width / 3.5,
                margin: EdgeInsets.only(left: 10),
                child: FlatButton(
                  child: Text(menu[index].toString(), 
                    style: TextStyle(color: Colors.white, fontSize: 15.0)
                  ),
                  color: Colors.blue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                  onPressed: () {
                    // To-Do
                  },
                )
              );
            }
          )
        )
      ),

      _buildListView(),

      // ------------------------------- HALAMAN PESAN
      Text("Halaman Pesan"),

      // ------------------------------- HALAMAN PROFIL
      Text("Halaman Profil")
    ];

    final _bottomNavBarItems = <BottomNavigationBarItem> [
      BottomNavigationBarItem(
        icon: Icon(Feather.home),
        title: Text("Home") 
      ),

      BottomNavigationBarItem(
        icon: Icon(Feather.book_open),
        title: Text("Berita") 
      ),

      BottomNavigationBarItem(
        icon: Icon(Feather.bell),
        title: Text("Pesan") 
      ),

      BottomNavigationBarItem(
        icon: Icon(Feather.user),
        title: Text("Profil") 
      )
    ];

    final _bottomNavBar = BottomNavigationBar(
      items: _bottomNavBarItems,
      currentIndex: _selectedTabIndex,
      onTap: _onNavBarTapped,
      iconSize: 24.0,
      elevation: 8.0,
      selectedItemColor: ColorPalette.primaryColor,
      selectedFontSize: 12.0,
      unselectedItemColor: ColorPalette.grey,
      showUnselectedLabels: false,
    );

    // ------ SCAFFOLD
    return Scaffold(
      body: SafeArea(
        child:SingleChildScrollView(
          child: _listPage[_selectedTabIndex]
        )
      ),
      bottomNavigationBar: _bottomNavBar
      
    );
  }
  
  Widget _buildListView() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: data == null ? 0 : data.length,
      itemBuilder: (context, index) {
        return _buildImageColumn(data[index]);
      }
    );
  }

  Widget _buildImageColumn(dynamic item) => Container(
    decoration: BoxDecoration(
      color: Colors.white54
    ),
    margin: const EdgeInsets.all(4),
    child: Column(
      children: [
        CachedNetworkImage(
         imageUrl: item['urls']['small'],
         placeholder: (context, url) => new CircularProgressIndicator(),
         errorWidget: (context, url, error) => new Icon(Icons.error),
         fadeOutDuration: new Duration(seconds: 1),
         fadeInDuration: new Duration(seconds: 3),
       ),
        _buildRow(item)
      ]
    )
  );

  Widget _buildRow(dynamic item) {
    return ListTile(
      title: Text(
        item['description'] == null ? '': item['description'],
      ),
      subtitle: Text("Likes: " + item['likes'].toString()),
    );
  }
}
