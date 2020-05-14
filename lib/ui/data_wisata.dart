import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';

var isLoading = false;

class DestinasiWisata extends StatefulWidget {
  @override
  DestinasiWisataState createState() => DestinasiWisataState();
}

class DestinasiWisataState extends State<DestinasiWisata> {

  // Server URL
  final String url = "http://10.0.2.2/onlenkan-informasi/";
  // final String url = "http://192.168.43.17/onlenkan-informasi/";
  // final String url = "http://192.168.1.21/onlenkan-informasi/";
  // final String url = "https://informasi.onlenkan.org/";
 
  @override
  void initState() {
    super.initState();
    this.getData();
  }

  List data;
  
  Future<String> getData() async {
    setState(() {
      isLoading = true;
    });

    final res = await http.get(url + "api/wisata.php");
    if (res.statusCode == 200) {
      data = json.decode(res.body)['semua'];
      setState(() {
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load data');
    }
    return 'success';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Destinasi Wisata", style: TextStyle(color: Colors.white, fontSize: 18.0, fontFamily: "NunitoSemiBold")),
      ),
      body: isLoading ? Center(child: Container(child: CupertinoTheme( data: CupertinoTheme.of(context).copyWith(brightness: Brightness.light), child: CupertinoActivityIndicator())))
                      : Padding(padding: EdgeInsets.all(1), child: _buildGridView()),
    );
  }

  Widget _buildGridView() {
    return GridView.count(
      primary: true,
      crossAxisCount: 2,
      childAspectRatio: 0.90,
      children: List.generate(data.length, (index) {
        return _getGridData(data[index]);
      }),
    );
  }

  Widget _getGridData(dynamic item) => Stack(
    alignment: Alignment.bottomCenter,
    children: <Widget>[
      CachedNetworkImage(
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        imageUrl: url + "uploads/wisata/" + item['gambar'],
        placeholder: (context, url) => new Container(
          height: 150.0,
          child: new CupertinoActivityIndicator(),
        ),
        errorWidget: (context, url, error) => new Icon(Icons.error),
        fadeOutDuration: new Duration(seconds: 1),
        fadeInDuration: new Duration(seconds: 1),
      ),
      GestureDetector(
        onTap: () async {
          String url = item['google_maps'];

          if (await canLaunch(url)) {
            await launch(url, forceSafariVC: false, forceWebView: false);
          }
        },
        child: Container(
          height: double.infinity,
          decoration: BoxDecoration(
            color: Color(0x00FFFFFF),
            border: Border.all(width: 2, color: Colors.white)
          )
        )
      ),
      Container(
        height: 50,
        margin: EdgeInsets.all(2),
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        color: Color(0x70000000),
        alignment: Alignment.bottomCenter,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              item['nama_wisata'],
              maxLines: 1,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                height: 1.6,
                color: Colors.white,
                fontSize: 14 )),
            SizedBox(height: 2),
            Text(
              item['alamat'],
              maxLines: 1,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                height: 1.0,
                color: Color(0xffCCCCCC),
                fontSize: 11 )),
          ],
        )
      )  
    ],
  );
}