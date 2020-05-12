import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

// Server URL
final String url = "http://10.0.2.2/onlenkan-informasi/";
// final String url = "http://192.168.43.17/onlenkan-informasi/";
// final String url = "http://192.168.1.21/onlenkan-informasi/";

class Covid {
  final String positif, sembuh, meninggal, odp, pdp, pemudik, waktu;

  Covid(
    this.positif,
    this.sembuh,
    this.meninggal,
    this.odp,
    this.pdp,
    this.pemudik,
    this.waktu
  );

  factory Covid.fromJson(Map<String, dynamic> json) {
    json = json['semua'][0];
    String positif    = json['positif'].toString();
    String sembuh     = json['sembuh'];
    String meninggal  = json['meninggal'];
    String odp        = json['odp'];
    String pdp        = json['pdp'];
    String pemudik    = json['pemudik'];
    String waktu      = json['update_terakhir'];
    return Covid(positif, sembuh, meninggal, odp, pdp, pemudik, waktu);
  }
}