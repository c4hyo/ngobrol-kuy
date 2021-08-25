import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:ngobrolkuy/config/collection.dart';
import 'package:ngobrolkuy/model/pesanModel.dart';
import 'package:ngobrolkuy/model/userModel.dart';
import 'package:ngobrolkuy/config/string.dart';

class UserController extends GetxController {
  final _userModel = UserModel().obs;

  UserModel get userModel => _userModel.value;

  set userModel(UserModel value) => this._userModel.value = value;
  final indexTab = 0.obs;

  Future<bool> tambahTeman(String id, String idTeman) async {
    try {
      await users.doc(id).collection("teman").doc(idTeman).set(
        {"waktu": DateTime.now()},
        SetOptions(merge: true),
      );
      await users.doc(idTeman).collection("teman").doc(id).set(
        {"waktu": DateTime.now()},
        SetOptions(merge: true),
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> kirimPesan({PesanModel? pesan}) async {
    try {
      await users
          .doc(pesan!.dari)
          .collection("teman")
          .doc(pesan.ke)
          .collection("pesan")
          .add({
        "dari": pesan.dari,
        "ke": pesan.ke,
        "pesan": pesan.pesan,
        "waktu": DateTime.now().toIso8601String(),
        "tipe": "text",
      });
      await users.doc(pesan.dari).collection("teman").doc(pesan.ke).set(
        {
          "pesan_terbaru": pesan.pesan,
          "waktu_pesan": DateTime.now().toIso8601String(),
          "pengirim": pesan.dari,
        },
        SetOptions(merge: true),
      );
      await users
          .doc(pesan.ke)
          .collection("teman")
          .doc(pesan.dari)
          .collection("pesan")
          .add({
        "dari": pesan.dari,
        "ke": pesan.ke,
        "pesan": pesan.pesan,
        "waktu": DateTime.now().toIso8601String(),
        "tipe": "text",
      });
      await users.doc(pesan.ke).collection("teman").doc(pesan.dari).set(
        {
          "pesan_terbaru": pesan.pesan,
          "waktu_pesan": DateTime.now().toIso8601String(),
          "pengirim": pesan.dari,
        },
        SetOptions(merge: true),
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> buatAkun(UserModel userModel) async {
    try {
      users.doc(userModel.uid).set({
        "online": true,
        "email": userModel.email,
        "url_gambar": "",
        "menulis": false,
        "nama": userModel.nama,
        "kode_pengguna": generateRandomString(6),
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  profilUser(String uid) async {
    try {
      DocumentSnapshot doc = await users.doc(uid).get();
      return UserModel.mapsDoc(doc);
    } catch (e) {
      rethrow;
    }
  }

  clearPengguna() {
    _userModel.value = UserModel();
  }
}
