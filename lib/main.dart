import 'package:flutter/material.dart';

void main() {
  runApp(new MaterialApp(
    title: "Pusat Informasi",
    home: new Home(),
  ));
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Home Pusat Informasi")
        ),
        body: new Center(
          child: Text("This is home", style: TextStyle(fontSize: 30, color: Colors.blue),),
        )
      ),
    );
  }
}