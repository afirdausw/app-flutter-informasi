import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:informasi/model/intro.dart';
import 'package:informasi/utils/color_palette.dart';
import 'package:informasi/widgets/custom_flat_futton.dart';

import 'home.dart';

class IntroPage extends StatefulWidget {
  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {

  bool checkValue = false;
  SharedPreferences sharedPreferences;

  final List<Intro> introList = [
    Intro(
        image: "images/icon_search.png",
        title: "Temukan",
        description:
            "Ketahui berbagai informasi lokasi dan tempat-tempat terbaik yang ada di sekitar Probolinggo."),
    Intro(
        image: "images/icon_hamburger.png",
        title: "Makanan",
        description:
            "Cari tempat makan dan hidangan terbaik yang ada di Probolinggo."),
    Intro(
        image: "images/icon_otw.png",
        title: "Pesan",
        description:
            "Anda juga dapat memesan, mengantarkan barang paket anda dengan mudah.")
  ];

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.black,
      systemNavigationBarIconBrightness: Brightness.light));
    return Scaffold(
      backgroundColor: Colors.white,
      body: WillPopScope(
        onWillPop: _willPop,
        child: Swiper.children(
          index: 0,
          autoplay: false,
          loop: false,
          pagination: SwiperPagination(
              margin: EdgeInsets.only(bottom: 20.0),
              builder: DotSwiperPaginationBuilder(
                  color: ColorPalette.dotColor,
                  activeColor: ColorPalette.dotActiveColor,
                  size: 10.0,
                  activeSize: 10.0)),
          control: SwiperControl(iconNext: null, iconPrevious: null),
          children: _buildPage(context))
      ),
    );
  }

  List<Widget> _buildPage(BuildContext context) {
    List<Widget> widgets = [];

    for (int i = 0; i < introList.length; i++) {
      Intro intro = introList[i];
      widgets.add(Container(
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 6),
        child: ListView(
          children: <Widget>[
            Image.asset(intro.image,
                height: MediaQuery.of(context).size.height / 4.0),
            Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 12.0)),
            Center(
                child: Text(intro.title,
                    style: TextStyle(
                        color: ColorPalette.titleColor,
                        fontSize: 24.0,
                        fontWeight: FontWeight.w500))),
            Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 40.0)),
            Container(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.height / 20.0),
                child: Text(intro.description,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: ColorPalette.descriptionColor,
                        fontSize: 15.0,
                        height: 1.5)))
          ],
        ),
      ));
    }

    widgets.add(new Container(
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 6),
        child: ListView(children: <Widget>[
          Image.asset("images/icon_otw.png",
              height: MediaQuery.of(context).size.height / 4.0),
          Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / 12.0)),
          Center(
              child: Text("Mari Mari Sini",
                  style: TextStyle(
                      color: ColorPalette.titleColor,
                      fontSize: 24.0,
                      fontWeight: FontWeight.w500))),
          Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / 40.0)),
          Container(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.height / 20.0),
              child: Text("Fusce ullamcorper sed eros ac hendrerit. Pellentesque luctus elit ut nisi congue viverra sed vitae tellus.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: ColorPalette.descriptionColor,
                      fontSize: 15.0,
                      height: 1.5))),
          Padding(
              padding: EdgeInsets.only(top: 30.0, right: 45.0, left: 45.0),
              child: CustomFlatButton(
                title: "Ayo Mulai",
                fontSize: 16,
                textColor: Colors.white,
                onPressed: () {
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Home()),
                  );
                  setSessionIntro();
                },
                splashColor: Colors.transparent,
                borderColor: Colors.transparent,
                borderWidth: 0,
                color: Colors.blueAccent,
              ))
        ])));

    return widgets;
  }

  Future<bool> _willPop() async {
    SystemNavigator.pop();
    return false;
  }

  setSessionIntro() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      checkValue = true;
      sharedPreferences.setBool("intro", checkValue);
      sharedPreferences.commit();
    });
  }
}
