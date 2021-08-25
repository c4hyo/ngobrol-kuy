import 'package:bubble/bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ngobrolkuy/config/collection.dart';
import 'package:ngobrolkuy/config/string.dart';
import 'package:ngobrolkuy/config/warna.dart';
import 'package:ngobrolkuy/controller/authController.dart';
import 'package:ngobrolkuy/controller/userController.dart';
import 'package:ngobrolkuy/komponen_view/loading.dart';
import 'package:ngobrolkuy/model/pesanModel.dart';
import 'package:ngobrolkuy/model/userModel.dart';

class RuangPesan extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final pesanController = TextEditingController();
    final user = Get.find<UserController>();
    return GetBuilder<AuthController>(dispose: (_) {
      users
          .doc(Get.find<AuthController>().user!.uid)
          .update({"menulis": false});
    }, builder: (auth) {
      return Scaffold(
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SafeArea(
            child: Column(
              children: [
                Container(
                  height: 70,
                  color: primary,
                  child: StreamBuilder<DocumentSnapshot>(
                    stream:
                        users.doc(Get.arguments['userModel'].uid).snapshots(),
                    builder: (_, s) {
                      if (!s.hasData) {
                        return Row(
                          children: [
                            IconButton(
                              onPressed: () => Get.back(),
                              icon: Icon(
                                Icons.arrow_back,
                                color: white,
                              ),
                            ),
                            CircleAvatar(
                              backgroundColor: white,
                              radius: 30,
                              backgroundImage:
                                  (Get.arguments['userModel'].urlGambar == "")
                                      ? AssetImage("assets/logo.png")
                                      : NetworkImage(Get.arguments['userModel']
                                          .urlGambar!) as ImageProvider,
                            ),
                            CircleAvatar(
                              radius: 7,
                              backgroundColor: primary,
                            ),
                            SizedBox(
                              width: 30,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "${Get.arguments['userModel'].nama}",
                                  style: TextStyle(
                                    color: white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  " ",
                                  style: TextStyle(color: white, fontSize: 15),
                                )
                              ],
                            ),
                          ],
                        );
                      }
                      DocumentSnapshot doc = s.data!;
                      UserModel userModel = UserModel.mapsDoc(doc);
                      return Row(
                        children: [
                          IconButton(
                            onPressed: () => Get.back(),
                            icon: Icon(
                              Icons.arrow_back,
                              color: white,
                            ),
                          ),
                          CircleAvatar(
                            backgroundColor: white,
                            radius: 20,
                            backgroundImage: (userModel.urlGambar == "")
                                ? AssetImage(
                                    "assets/logo.png",
                                  )
                                : NetworkImage(
                                    userModel.urlGambar!,
                                  ) as ImageProvider,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          CircleAvatar(
                            radius: 7,
                            backgroundColor:
                                (userModel.online!) ? Colors.green : Colors.red,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                " ${userModel.nama}",
                                style: TextStyle(
                                  color: white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              (userModel.menulis!)
                                  ? Text(
                                      "Sedang menulis",
                                      style:
                                          TextStyle(color: white, fontSize: 13),
                                    )
                                  : SizedBox(),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ),
                Expanded(
                  child: Container(
                    color: secondary,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: users
                          .doc(auth.user!.uid)
                          .collection("teman")
                          .doc(Get.arguments['userModel'].uid)
                          .collection("pesan")
                          .orderBy("waktu", descending: true)
                          .snapshots(),
                      builder: (_, snaps) {
                        if (!snaps.hasData) {
                          return Center(
                            child: LoadingProses(),
                          );
                        }
                        return Padding(
                          padding: const EdgeInsets.all(10),
                          child: ListView.builder(
                            itemCount: snaps.data!.docs.length,
                            reverse: true,
                            itemBuilder: (_, i) {
                              DocumentSnapshot doc = snaps.data!.docs[i];
                              PesanModel pesanModel = PesanModel.fromDoc(doc);
                              return (pesanModel.dari == auth.user!.uid)
                                  ? Bubble(
                                      margin: BubbleEdges.only(top: 10),
                                      alignment: Alignment.topRight,
                                      nip: BubbleNip.rightTop,
                                      color: primaryAccent,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            "${pesanModel.pesan}",
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                              color: white,
                                              fontSize: 17,
                                            ),
                                          ),
                                          Text(
                                            "${waktu(pesanModel.waktu!)}",
                                            textAlign: TextAlign.right,
                                            style: TextStyle(fontSize: 10),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Bubble(
                                      margin: BubbleEdges.only(
                                        top: 10,
                                      ),
                                      alignment: Alignment.topLeft,
                                      nip: BubbleNip.leftTop,
                                      color: primary,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${pesanModel.pesan}",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              color: white,
                                              fontSize: 17,
                                            ),
                                          ),
                                          Text(
                                            "${waktu(pesanModel.waktu!)}",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 12,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Container(
                          height: 60,
                          child: TextFormField(
                            controller: pesanController,
                            onChanged: (s) {
                              users
                                  .doc(auth.user!.uid)
                                  .update({"menulis": true});
                              if (s.isEmpty) {
                                users
                                    .doc(auth.user!.uid)
                                    .update({"menulis": false});
                              }
                            },
                            decoration: InputDecoration(
                                fillColor: white,
                                filled: true,
                                hintText: "Ketikan pesan",
                                hintStyle: TextStyle(
                                  color: primaryAccent,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(color: primary),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(color: primary),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(color: primary),
                                )),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.image,
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.send_outlined,
                              color: primaryAccent,
                            ),
                            onPressed: () async {
                              FocusScope.of(context).unfocus();
                              if (pesanController.text.isNotEmpty) {
                                PesanModel pesan = PesanModel(
                                    dari: auth.user!.uid,
                                    ke: Get.arguments['userModel'].uid,
                                    pesan: pesanController.text);
                                await user.kirimPesan(pesan: pesan);
                              }
                              pesanController.clear();
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
