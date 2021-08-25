import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ngobrolkuy/config/collection.dart';
import 'package:ngobrolkuy/config/warna.dart';
import 'package:ngobrolkuy/controller/authController.dart';
import 'package:ngobrolkuy/controller/utilityController.dart';
import 'package:ngobrolkuy/model/userModel.dart';
import 'package:ngobrolkuy/view/pengguna/profil.dart';

class Pencarian extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final utility = Get.put<UtilityController>(UtilityController());
    final auth = Get.find<AuthController>();
    return Scaffold(
      appBar: AppBar(
        title: Text("Cari Teman"),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  end: Alignment.bottomCenter,
                  begin: Alignment.topCenter,
                  colors: [
                    primary,
                    primaryAccent,
                  ]),
            ),
            padding: const EdgeInsets.all(10),
            child: TextFormField(
              onChanged: (s) {
                utility.pencarian.value = s;
              },
              decoration: InputDecoration(
                fillColor: white,
                filled: true,
                hintText: "Masukkan Pin",
                hintStyle: TextStyle(
                  color: primaryAccent,
                ),
                suffixIcon: Icon(
                  Icons.search,
                  color: primaryAccent,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: white),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: white),
                ),
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          return StreamBuilder<QuerySnapshot>(
            stream: users
                .where("kode_pengguna", isEqualTo: utility.pencarian.value)
                .snapshots(),
            builder: (_, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: Text("Belum ada data"),
                );
              }
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (_, index) {
                  DocumentSnapshot doc = snapshot.data!.docs[index];
                  UserModel userModel = UserModel.mapsDoc(doc);
                  return Card(
                    child: ListTile(
                      title: Text("${userModel.nama}"),
                      subtitle: (userModel.online == true)
                          ? Text("Online")
                          : Text("Offline"),
                      trailing: (auth.user!.uid == userModel.uid)
                          ? Icon(Icons.person)
                          : IconButton(
                              icon: Icon(Icons.zoom_in),
                              onPressed: () {
                                utility.pencarian.value = "";
                                Get.to(() => ProfilTeman(), arguments: {
                                  "userModel": userModel,
                                });
                              },
                            ),
                    ),
                  );
                },
              );
            },
          );
        }),
      ),
    );
  }
}
