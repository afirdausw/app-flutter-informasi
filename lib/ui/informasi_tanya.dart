import 'package:flutter/material.dart';

class TanyaJawab extends StatefulWidget {
  @override
  _TanyaJawabState createState() => _TanyaJawabState();
}

class _TanyaJawabState extends State<TanyaJawab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tanya Jawab", style: TextStyle(color: Colors.white, fontSize: 18.0, fontFamily: "NunitoSemiBold")),
      ),

      body: Center(
        child: Text("TANYA JAWAB"),
      )
      
    );
  }
}