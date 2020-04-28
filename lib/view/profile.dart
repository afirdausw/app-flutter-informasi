import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        titleSpacing: 0.2,
      ),

      body: Column(children: <Widget>[
        Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              Icon(Icons.home, size: 40),
              Text("Home")
            ]
          )
        ),

        Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              Icon(Icons.pageview, size: 40),
              Text("Headnews")
            ]
          )
        ),

        Center(
          child: RaisedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Back to Dashboard"),
          )
        )

      ]) 
    );
  }
}