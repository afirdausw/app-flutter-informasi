import 'package:flutter/material.dart';
import 'package:pusatinformasi/view/profile.dart';
import 'package:pusatinformasi/view/signin.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  int _selectedTabIndex = 0;

  void _onNavBarTapped(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {

    final _listPage = <Widget> [
      // ------------------------------- HALAMAN HOME
      Column(children: <Widget>[
        Center(child: Icon(Icons.directions, size: 60)),

        Center(child: Container(
            width: 200,
            height: 1500,
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

      ]),

      // ------------------------------- HALAMAN BERITA
      Text("Halaman Berita"),

      // ------------------------------- HALAMAN PROFIL
      Text("Halaman Profil")
    ];

    final _bottomNavBarItems = <BottomNavigationBarItem> [
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        title: Text("Home") 
      ),

      BottomNavigationBarItem(
        icon: Icon(Icons.favorite),
        title: Text("Berita") 
      ),

      BottomNavigationBarItem(
        icon: Icon(Icons.person),
        title: Text("Profi") 
      )
    ];

    final _bottomNavBar = BottomNavigationBar(
      items: _bottomNavBarItems,
      currentIndex: _selectedTabIndex,
      onTap: _onNavBarTapped,
      iconSize: 24.0,
      elevation: 8.0,
      selectedIconTheme: const IconThemeData(),
      selectedFontSize: 12.0,
      unselectedIconTheme: const IconThemeData(),
      showUnselectedLabels: false,
    );

    return Scaffold(
      appBar: AppBar(
          title: Text("Dashboad")
      ),
      
      body: SingleChildScrollView(
        child: _listPage[_selectedTabIndex]
      ),
      bottomNavigationBar: _bottomNavBar
    );
  }
}