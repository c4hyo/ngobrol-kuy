import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:ngobrolkuy/config/collection.dart';
import 'package:ngobrolkuy/config/string.dart';
import 'package:ngobrolkuy/config/warna.dart';
import 'package:ngobrolkuy/controller/authController.dart';
import 'package:ngobrolkuy/controller/userController.dart';
import 'package:ngobrolkuy/komponen_view/loading.dart';
import 'package:ngobrolkuy/model/userModel.dart';
import 'package:ngobrolkuy/view/pengguna/ruangPesan.dart';

class ChatList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Get.find<UserController>();
    final auth = Get.find<AuthController>();
    return Scaffold(
      backgroundColor: white,
      body: SafeArea(
        child: SingleChildScrollView(
          primary: true,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 200,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: double.infinity,
                          height: 200,
                          color: white,
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: CircleAvatar(
                          backgroundColor: primary,
                          radius: 70,
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          width: double.infinity,
                          height: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.elliptical(400, 25),
                            ),
                            gradient: LinearGradient(
                                end: Alignment.bottomCenter,
                                begin: Alignment.topCenter,
                                colors: [
                                  primaryAccent,
                                  primary,
                                ]),
                          ),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      right: 10,
                      bottom: 10,
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: CircleAvatar(
                          backgroundColor: white,
                          radius: 60,
                          backgroundImage: user.userModel.urlGambar != ""
                              ? NetworkImage(
                                  "${user.userModel.urlGambar}",
                                )
                              : AssetImage("assets/logo.png") as ImageProvider,
                        ),
                      ),
                    ),
                    Positioned.fill(
                      left: 60,
                      bottom: 60,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Ngobrol Kuy",
                          style: TextStyle(
                            color: white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      left: 10,
                      bottom: 60,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Image.asset(
                          "assets/logo.png",
                          height: 40,
                          width: 40,
                        ),
                      ),
                    ),
                    Positioned.fill(
                      left: 60,
                      top: 20,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "${user.userModel.nama}",
                          style: TextStyle(
                            color: textSecond,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      left: 30,
                      bottom: 10,
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          "Pin: ${user.userModel.kodePengguna}",
                          style: TextStyle(
                            color: textSecond,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: Icon(
                            Icons.exit_to_app,
                            color: white,
                          ),
                          onPressed: () {
                            users.doc(auth.user!.uid).update({"online": false});
                            auth.logout();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: StreamBuilder<QuerySnapshot>(
                  stream: users
                      .doc(auth.user!.uid)
                      .collection("teman")
                      .orderBy("waktu_pesan", descending: true)
                      .snapshots(),
                  builder: (_, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: LoadingProses());
                    }
                    return (snapshot.data!.docs.length == 0)
                        ? Center(
                            child: Column(
                              children: [
                                Container(
                                  height: Get.width,
                                  child: Lottie.network(
                                    "https://assets1.lottiefiles.com/packages/lf20_x62chJ.json",
                                  ),
                                ),
                                Text(
                                  "Belum ada percakapan",
                                  style: TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            primary: false,
                            shrinkWrap: true,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (_, index) {
                              DocumentSnapshot doc = snapshot.data!.docs[index];
                              return FutureBuilder<DocumentSnapshot>(
                                future: users.doc(doc.id).get(),
                                builder: (_, sn) {
                                  if (!sn.hasData) {
                                    return Card(
                                      color: secondary,
                                    );
                                  }
                                  DocumentSnapshot docs = sn.data!;
                                  UserModel userModel = UserModel.mapsDoc(docs);
                                  return Card(
                                    color: primaryAccent,
                                    child: ListTile(
                                      onTap: () {
                                        Get.to(() => RuangPesan(), arguments: {
                                          "userModel": userModel,
                                        });
                                      },
                                      leading: CircleAvatar(
                                        backgroundColor: white,
                                        radius: 30,
                                        backgroundImage: (userModel.urlGambar ==
                                                "")
                                            ? AssetImage("assets/logo.png")
                                            : NetworkImage(userModel.urlGambar!)
                                                as ImageProvider,
                                      ),
                                      title: Text(
                                        "${userModel.nama}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: white,
                                          fontSize: 20,
                                        ),
                                      ),
                                      subtitle: (doc['pengirim'] ==
                                              auth.user!.uid)
                                          ? Text(
                                              (doc['tipe_pesan'] == "text")
                                                  ? "${doc['pesan_terbaru']}"
                                                  : "[Pesan Gambar]",
                                              maxLines: 3,
                                              softWrap: true,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color: white,
                                                fontSize: 14,
                                                fontStyle: FontStyle.italic,
                                              ),
                                            )
                                          : Text(
                                              (doc['tipe_pesan'] == "text")
                                                  ? "${doc['pesan_terbaru']}"
                                                  : "[Pesan Gambar]",
                                              maxLines: 3,
                                              softWrap: true,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color: white,
                                                fontSize: 14,
                                              ),
                                            ),
                                      trailing: Text(
                                        "${waktu(doc['waktu_pesan'])}",
                                        style: TextStyle(
                                          color: white,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
