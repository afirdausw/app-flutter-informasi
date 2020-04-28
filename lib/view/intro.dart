import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:pusatinformasi/model/intro.dart';
import 'package:pusatinformasi/utils/color_palette.dart';

class IntroPage extends StatefulWidget {
  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {

  final List<Intro> introList = [
    Intro(
      image: "images/icon_search.png",
      title: "Temukan",
      description: "Discover information service who the best near you on Probolinggo"
    ),
    Intro(
      image: "images/icon_hamburger.png",
      title: "Order",
      description: "Our veggie plan is filled with delicious seasonal vegetables, whole grains, beautiful cheeses and vegetarian proteins"
    ),
    Intro(
      image: "images/icon_otw.png",
      title: "Eat",
      description: "Food delivery or pickup from local restaurants, Explore restaurants that deliver near you."
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Swiper.children(
        index: 0,
        autoplay: false,
        loop: false,
        pagination: SwiperPagination(
          margin: EdgeInsets.only(bottom: 20.0),
          builder: DotSwiperPaginationBuilder(
            color: ColorPalette.dotColor,
            activeColor: ColorPalette.dotActiveColor,
            size: 10.0,
            activeSize: 10.0
          )
        ),
        control: SwiperControl(
          iconNext: null,
          iconPrevious: null
        ),
        children: _buildPage(context)
      ),
    );
  }

  List<Widget> _buildPage(BuildContext context) {
    List<Widget> widgets = [];

    for (int i=0; i<introList.length; i++) {
      Intro intro = introList[i];
      widgets.add(
        Container(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height/6
          ),

          child: ListView(
            children: <Widget>[
              Image.asset(
                intro.image,
                height: MediaQuery.of(context).size.height/4.0
              ),

              Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height/12.0
                )
              ),

              Center(
                child: Text(
                  intro.title,
                  style: TextStyle(
                    color: ColorPalette.titleColor,
                    fontSize: 24.0,
                    fontWeight: FontWeight.w500
                  )
                )
              ),

              Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height/40.0
                )
              ),

              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.height/20.0
                ),
                child: Text(
                  intro.description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: ColorPalette.descriptionColor,
                    fontSize: 15.0,
                    height: 1.5
                  )
                )
              )

            ],
          ),
        )
      );
    }

    return widgets;
  }
}