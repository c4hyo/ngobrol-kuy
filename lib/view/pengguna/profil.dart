import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ngobrolkuy/config/collection.dart';
import 'package:ngobrolkuy/config/warna.dart';
import 'package:ngobrolkuy/controller/authController.dart';
import 'package:ngobrolkuy/controller/userController.dart';

class ProfilTeman extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();
    final user = Get.find<UserController>();
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(200),
          child: Column(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage("assets/logo.png"),
                radius: 70,
                backgroundColor: white,
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  "${Get.arguments['userModel'].nama}",
                  style: TextStyle(
                      color: white, fontWeight: FontWeight.bold, fontSize: 30),
                ),
              ),
            ],
          ),
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: users
            .doc(auth.user!.uid)
            .collection("teman")
            .doc(Get.arguments['userModel'].uid)
            .snapshots(),
        builder: (_, snap) {
          if(!snap.hasData){
            return Text("");
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: (!snap.data!.exists)
                    ? ElevatedButton(
                        onPressed: () async{
                          await user.tambahTeman(auth.user!.uid, Get.arguments['userModel'].uid);
                          user.indexTab.value = 0;
                          Get.back();
                        },
                        child: Text("Tambah Teman"),
                      )
                    : ElevatedButton(
                        onPressed: () => print("ye"),
                        child: Text("Hapus Teman"),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
