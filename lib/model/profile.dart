import 'dart:convert';

class ProfileModel {
  final int id;
  final String uid;
  final String nama;
  final String email;
  final String telepon;
  final String kelamin;
  final String tanggal;
  final String alamat;

  ProfileModel({
    this.id, 
    this.uid, 
    this.nama, 
    this.email, 
    this.telepon, 
    this.kelamin, 
    this.tanggal, 
    this.alamat });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id_pengguna'],
      uid: json['uid'],
      nama: json['nama'],
      email: json['email'],
      telepon: json['telepon'],
      kelamin: json['kelamin'],
      tanggal: json['tanggal'],
      alamat: json['alamat'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "uid": uid,
      "nama": nama,
      "email": email,
      "telepon": telepon,
      "kelamin": kelamin,
      "tanggal": tanggal,
      "alamat": alamat
    };
  }
}

String profileToJson(ProfileModel data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}