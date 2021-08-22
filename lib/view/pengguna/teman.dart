import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ngobrolkuy/config/collection.dart';
import 'package:ngobrolkuy/config/warna.dart';
import 'package:ngobrolkuy/controller/authController.dart';
import 'package:ngobrolkuy/komponen_view/loading.dart';
import 'package:ngobrolkuy/model/userModel.dart';
import 'package:ngobrolkuy/view/pengguna/profil.dart';
import 'package:ngobrolkuy/view/pengguna/ruangPesan.dart';

class Teman extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();
    return Scaffold(
      appBar: AppBar(
        title: Text("Semua Teman"),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: TextFormField(
              onChanged: (s) {

              },
              decoration: InputDecoration(
                fillColor: white,
                filled: true,
                hintText: "Cari Teman",
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
        child: StreamBuilder<QuerySnapshot>(
          stream: users.doc(auth.user!.uid).collection("teman").snapshots(),
          builder: (_, snap) {
            if (!snap.hasData) {
              return Center(child: LoadingProses());
            }
            return ListView.builder(
              itemCount: snap.data!.docs.length,
              itemBuilder: (_, i) {
                DocumentSnapshot doc = snap.data!.docs[i];
                return StreamBuilder<DocumentSnapshot>(
                  stream: users.doc(doc.id).snapshots(),
                  builder: (_, f) {
                    if (!f.hasData) {
                      return Center(child: LoadingProses());
                    }
                    final doc = f.data!;
                    UserModel userModel = UserModel.mapsDoc(doc);
                    return Card(
                      child: ListTile(
                        onTap: () {
                          Get.defaultDialog(
                            title: "Aksi",
                            middleText: "",
                            actions: [
                              ElevatedButton(
                                onPressed: () {
                                  Get.back();
                                  Get.to(() => ProfilTeman(), arguments: {
                                    "userModel": userModel,
                                  });

                                },
                                child: Text("Profil"),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Get.back();
                                  Get.to(() => RuangPesan(), arguments: {
                                    "userModel": userModel,
                                  });
                                },
                                child: Text("Pesan"),
                              ),
                            ],
                          );
                        },
                        title: Text("${userModel.nama}"),
                        subtitle: (userModel.online!)
                            ? Text("online")
                            : Text("offline"),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
