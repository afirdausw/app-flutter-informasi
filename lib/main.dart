import 'package:flutter/material.dart';
import 'package:pusatinformasi/view/profile.dart';
import 'package:pusatinformasi/view/signin.dart';

void main() {
  runApp(new MaterialApp(
      title: "Pusat Informasi",
      home: new Home(),
    )
  );
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Dashboad")
        ),

        body: Column(children: <Widget>[
          Center(child: Icon(Icons.directions, size: 60)),

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

          Center(child: FlatButton(
              child: Text("Profile Page"),
              color: Colors.blueAccent,
              textColor: Colors.white,
              onPressed: () {
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Profile()),
                );
              }
            )
          ),

          Center(child: FlatButton(
              child: Text("Signin Page"),
              color: Colors.blueAccent,
              textColor: Colors.white,
              onPressed: () {
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Signin()),
                );
              }
            )
          ),

        ])
      ),
    );
  }
}