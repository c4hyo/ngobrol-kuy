import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? uid;
  String? nama;
  String? email;
  String? urlGambar;
  String? kodePengguna;
  bool? online;
  bool? menulis;

  UserModel({
    this.uid,
    this.email,
    this.nama,
    this.menulis,
    this.online,
    this.urlGambar,
    this.kodePengguna,
  });

  UserModel.mapsDoc(DocumentSnapshot doc){
    kodePengguna = doc['kode_pengguna'];
    uid = doc.id;
    online = doc['online'];
    email = doc['email'];
    urlGambar = doc['url_gambar'];
    menulis = doc['menulis'];
    nama = doc['nama'];
  }

}
