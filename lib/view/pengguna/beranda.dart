import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ngobrolkuy/config/collection.dart';
import 'package:ngobrolkuy/config/string.dart';
import 'package:ngobrolkuy/config/warna.dart';
import 'package:ngobrolkuy/controller/postingController.dart';
import 'package:ngobrolkuy/controller/userController.dart';
import 'package:ngobrolkuy/model/postingModel.dart';
import 'package:ngobrolkuy/model/userModel.dart';
import 'package:ngobrolkuy/view/pengguna/chat_list.dart';

class BerandaHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Get.find<UserController>();
    final post = Get.put<PostingController>(PostingController());
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
        child: Obx(
          () => StreamBuilder<QuerySnapshot>(
            stream: users
                .doc(user.userModel.uid)
                .collection("posting")
                .orderBy("waktu", descending: true)
                .snapshots(),
            builder: (_, user) {
              if (!user.hasData) {
                return SizedBox.shrink();
              }
              return ListView.builder(
                itemCount: user.data!.docs.length,
                itemBuilder: (_, i) {
                  PostingModel posting =
                      PostingModel.fromDoc(user.data!.docs[i]);
                  return StreamBuilder<DocumentSnapshot>(
                    stream: users.doc(posting.idUser).snapshots(),
                    builder: (_, postUser) {
                      if (!postUser.hasData) {
                        return SizedBox.shrink();
                      }
                      UserModel userModel = UserModel.mapsDoc(postUser.data!);
                      return Padding(
                        padding: const EdgeInsets.all(10),
                        child: Card(
                          color: Colors.grey.shade200,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              ListTile(
                                title: Text("${userModel.nama}"),
                                subtitle: Text("${waktu(posting.waktu!)}"),
                                leading: ClipOval(
                                  child: (userModel.urlGambar == "" ||
                                          userModel.urlGambar == null)
                                      ? Image.asset("assets/logo.png")
                                      : FadeInImage(
                                          image: NetworkImage(
                                              userModel.urlGambar!),
                                          placeholder:
                                              AssetImage("assets/logo.png"),
                                          fit: BoxFit.scaleDown,
                                        ),
                                ),
                              ),
                              Container(
                                height: Get.width * 0.75,
                                width: Get.width * 0.75,
                                child: FadeInImage(
                                  image: NetworkImage(posting.urlPosting!),
                                  placeholder: AssetImage("assets/logo.png"),
                                  fit: BoxFit.scaleDown,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Text("${posting.judul}"),
                              ),
                              SizedBox(
                                height: 20,
                              )
                            ],
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
      ),
    );
  }
}
