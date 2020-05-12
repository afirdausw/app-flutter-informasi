import 'package:flutter/material.dart';

class Signin extends StatefulWidget {
  @override
  _SigninState createState() => _SigninState();
}

class _SigninState extends State<Signin> {

  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  String userName = '';
  String passWord = '';

  // Show hide password
  bool _isHidePassword = true;

  void _togglePasswordVisibility() {
    setState(() {
      _isHidePassword = !_isHidePassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Signin"),
      ),

      body: Center(child: Column(children: <Widget>[
        // ----------------- TOP
        Container(
          margin: EdgeInsets.fromLTRB(0, 60, 0, 40),
          child: Column(
            children: <Widget>[
              Icon(Icons.lock_outline, size: 50),
              Text("Please enter your registered account")
            ]
          )
        ),

        // ----------------- USERNAME / EMAIL
        Container(
          margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: TextField(
            controller: username,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(15, 4, 15, 4),
              border: OutlineInputBorder(),
              labelText: "Username / Email"
            ),
            onChanged: (text) {
              setState(() {
                userName = text;
              });
            }
          )
        ),

        // ----------------- PASSWORD
        Container(
          margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: TextField(
            controller: password,
            obscureText: _isHidePassword,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(15, 4, 15, 4),
              border: OutlineInputBorder(),
              labelText: "Password",
              isDense: true,
              suffixIcon: GestureDetector(
                onTap: () {
                  _togglePasswordVisibility();
                },
                child: Icon(
                  _isHidePassword ? Icons.visibility_off : Icons.visibility,
                  color: _isHidePassword ? Colors.grey : Colors.blueAccent,
                ),
              ),
            ),
            onChanged: (text) {
              setState(() {
                passWord = text;
              });
            }
          )
        ),

        // ----------------- BUTTON
        Center(child: FlatButton.icon(
            icon: Icon(Icons.check),
            color: Colors.blueAccent,
            textColor: Colors.white,
            label: Text("SIGN IN"),
            onPressed: () {
              // To-Do
            }
          )
        )

      ]))
    );
  }
}