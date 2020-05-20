import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Notifikasi extends StatefulWidget {
  @override
  _NotifikasiState createState() => _NotifikasiState();
}

class _NotifikasiState extends State<Notifikasi> {

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    this.runToast();
  }

  void runToast() {
    Timer(const Duration(seconds: 2), () {
      Fluttertoast.showToast(
        msg: "Hallo, this is my toast message!",
        toastLength: Toast.LENGTH_LONG,
        timeInSecForIosWeb: 1,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 14.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Semua Notifikasi", style: TextStyle(color: Colors.white, fontSize: 18.0, fontFamily: "NunitoSemiBold")),
      ),

      body: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("NOTIFIKASI"),
            FlatButton(
              color: Colors.green,
              onPressed: () {
                showNotification("Hello", "This is just test from button");
              },
              child: Text("Notification", style: TextStyle(color: Colors.white))
            )
          ],
        ),
      )
      
    );
  }

  showNotification(String title, String content) async {
    var android = new AndroidNotificationDetails(
        '111', 'Onlenkan', 'ONLENKAN INFORMASI',
        priority: Priority.High,
        importance: Importance.Max
    );
    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails(android, iOS);
    await flutterLocalNotificationsPlugin.show(0, title, content, platform, payload: 'Default_Sound');
  }

}