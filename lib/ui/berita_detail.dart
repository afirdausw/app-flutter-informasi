import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:informasi/utils/color_palette.dart';
import 'package:jiffy/jiffy.dart';

class BeritaDetail extends StatefulWidget {
  @override
  _BeritaDetailState createState() => _BeritaDetailState();
}

class _BeritaDetailState extends State<BeritaDetail> {
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
            )
          ]
        )
    );
  }
}