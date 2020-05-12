import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:informasi/utils/color_palette.dart';

class DownloadApp extends StatefulWidget {
  @override
  _DownloadAppState createState() => _DownloadAppState();
}

class _DownloadAppState extends State<DownloadApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Aplikasi SIKerJa", style: TextStyle(color: Colors.white, fontSize: 18.0, fontFamily: "NunitoSemiBold")),
      ),

      body: Center(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset("images/icon_sikerja.png", width: 90),
              SizedBox(height: 10),
              Text("Dapatkan info seputar pekerjaan hanya dengan genggaman anda.",
                style: TextStyle(fontSize: 16, fontFamily: 'NunitoSemiBold'),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text("Tunggu apalagi, segera download aplikasinya dan daftarkan diri anda untuk bergabung dengan Perusahaan dan Pekerja lainnya.",
                style: TextStyle(fontSize: 14, color: ColorPalette.dark),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              GestureDetector(
                onTap: () async {
                  const url = 'https://play.google.com/store/apps/details?id=onlenkan.disnakerv';

                  if (await canLaunch(url)) {
                    await launch(url, forceSafariVC: false, forceWebView: false);
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: new Text("Kesalahan"),
                          content: new Text("Tidak dapat membuka halaman $url"),
                          actions: <Widget>[
                            new FlatButton(
                              child: new Text("Tutup"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: Image.asset(
                  "images/play.png", width: 150, fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 60),
            ],
          ),
        ),
      ) 
    );
  }
}

