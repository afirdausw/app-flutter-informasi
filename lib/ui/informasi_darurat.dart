import 'package:flutter/material.dart';

class Darurat extends StatefulWidget {
  @override
  _DaruratState createState() => _DaruratState();
}

class _DaruratState extends State<Darurat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nomor Darurat", style: TextStyle(color: Colors.white, fontSize: 18.0, fontFamily: "NunitoSemiBold")),
      ),

      body: Center(
        child: Text("NOMOR DARURAT"),
      )
      
    );
  }
}