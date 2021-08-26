import 'package:cloud_firestore/cloud_firestore.dart';

class PostingModel {
  String? idPosting;
  String? idUser;
  String? judul;
  String? waktu;
  String? urlPosting;

  PostingModel({
    this.idPosting,
    this.idUser,
    this.judul,
    this.urlPosting,
    this.waktu,
  });

  PostingModel.fromDoc(DocumentSnapshot doc) {
    idPosting = doc.id;
    idUser = doc['id_user'];
    judul = doc['judul'];
    waktu = doc['waktu'];
    urlPosting = doc['url_posting'];
  }
}
