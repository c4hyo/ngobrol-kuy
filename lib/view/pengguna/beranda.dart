import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ngobrolkuy/config/collection.dart';
import 'package:ngobrolkuy/config/warna.dart';
import 'package:ngobrolkuy/controller/authController.dart';
import 'package:ngobrolkuy/controller/userController.dart';
import 'package:ngobrolkuy/model/postingModel.dart';
import 'package:ngobrolkuy/model/userModel.dart';
import 'package:ngobrolkuy/view/pengguna/chat_list.dart';

class BerandaHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Get.find<UserController>();
    final auth = Get.find<AuthController>();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryAccent,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(150),
          child: Container(
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
                  right: 20,
                  bottom: 20,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: CircleAvatar(
                      backgroundColor: white,
                      radius: 30,
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
                        Icons.message,
                        color: white,
                      ),
                      onPressed: () {
                        Get.to(
                          () => ChatList(),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: white,
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: users.doc(auth.user!.uid).collection("teman").snapshots(),
          builder: (_, us) {
            if (!us.hasData) {
              return SizedBox.shrink();
            }
            return ListView.builder(
              primary: false,
              shrinkWrap: true,
              itemCount: us.data!.docs.length,
              itemBuilder: (_, i) {
                return StreamBuilder<QuerySnapshot>(
                  stream: posting
                      .where("id_user", isEqualTo: us.data!.docs[i].id)
                      .orderBy("waktu", descending: true)
                      .snapshots(),
                  builder: (_, pos) {
                    if (!pos.hasData) {
                      return SizedBox.shrink();
                    }
                    return ListView.builder(
                      primary: false,
                      shrinkWrap: true,
                      itemCount: pos.data!.docs.length,
                      itemBuilder: (_, index) {
                        DocumentSnapshot docs = pos.data!.docs[index];
                        PostingModel postingModel = PostingModel.fromDoc(docs);
                        return StreamBuilder<DocumentSnapshot>(
                          stream: users.doc(postingModel.idUser).snapshots(),
                          builder: (_, pro) {
                            if (!pro.hasData) {
                              return SizedBox.shrink();
                            }
                            DocumentSnapshot doc = pro.data!;
                            UserModel userModel = UserModel.mapsDoc(doc);
                            return Card(
                              child: Column(
                                children: [
                                  ListTile(
                                      title: Text("${userModel.nama}"),
                                      subtitle: Text("${postingModel.waktu}"),
                                      leading: ClipOval(
                                        child: (userModel.urlGambar == "" ||
                                                userModel.urlGambar == null)
                                            ? Image.asset("assets/logo.png")
                                            : FadeInImage(
                                                image: NetworkImage(
                                                    userModel.urlGambar!),
                                                placeholder: AssetImage(
                                                    "assets/logo.png"),
                                              ),
                                      )),
                                  Container(
                                    height: Get.width * 0.6,
                                    width: Get.width * 0.6,
                                    child: FadeInImage(
                                      image: NetworkImage(
                                          postingModel.urlPosting!),
                                      placeholder:
                                          AssetImage("assets/logo.png"),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Text("${postingModel.judul}"),
                                  )
                                ],
                              ),
                            );
                          },
                        );
                      },
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
