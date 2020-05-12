import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List data;

  // Function to get the JSON data
  Future<String> getJSONData() async {
    var response = await http.get(
        // Encode the url
        // Uri.encodeFull("https://unsplash.com/napi/photos/Q14J2k8VE3U/related"),
        Uri.encodeFull("http://192.168.1.14/onlenkan-informasi/api/berita.php"),
        // Only accept JSON response
        headers: {"Accept": "application/json"}
    );

    setState(() {
      // Get the JSON data
      data = json.decode(response.body)['semua'];
    });

    return "Successfull";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Daftar Berita"),
      ),
      body: _buildListView(),
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: data == null ? 0 : data.length,
      itemBuilder: (context, index) {
        return _buildImageColumn(data[index]);
        // return _buildRow(data[index]);
      }
    );
  }

  Widget _buildImageColumn(dynamic item) => Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10)
    ),
    margin: const EdgeInsets.all(4),
    child: Column(
      children: [
        // new CachedNetworkImage(
        //   imageUrl: item['urls']['small'],
        //   placeholder: (context, url) => new CircularProgressIndicator(),
        //   errorWidget: (context, url, error) => new Icon(Icons.error),
        //   fadeOutDuration: new Duration(seconds: 1),
        //   fadeInDuration: new Duration(seconds: 3),
        // ),
        Image.network(
          "http://192.168.1.14/onlenkan-informasi/uploads/berita/" + item['gambar']
        ),
        _buildRow(item)
      ],
    ),
  );

  Widget _buildRow(dynamic item) {
    return ListTile(
      title: Text(
        item['judul'] == null ? '': item['judul'],
      ),
      subtitle: Text("Tanggal Pos: " + item['tanggal_pos'].toString()),
    );
  }
  
  @override
  void initState() {
    super.initState();
    // Call the getJSONData() method when the app initializes
    this.getJSONData();
  }
}
