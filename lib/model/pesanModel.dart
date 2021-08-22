import 'package:cloud_firestore/cloud_firestore.dart';

class PesanModel{
  String? idPesan;
  String? dari;
  String? ke;
  String? pesan;
  String? waktu;
  String? tipe;


  PesanModel({this.dari,this.idPesan,this.ke,this.pesan,this.tipe,this.waktu});

  PesanModel.fromDoc(DocumentSnapshot doc){
    idPesan = doc.id;
    dari = doc['dari'];
    ke = doc['ke'];
    pesan = doc['pesan'];
    waktu = doc['waktu'];
    tipe = doc['tipe'];
  }
}