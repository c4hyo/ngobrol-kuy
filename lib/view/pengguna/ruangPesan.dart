import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ngobrolkuy/config/collection.dart';
import 'package:ngobrolkuy/config/warna.dart';
import 'package:ngobrolkuy/controller/authController.dart';
import 'package:ngobrolkuy/controller/userController.dart';
import 'package:ngobrolkuy/controller/utilityController.dart';
import 'package:ngobrolkuy/komponen_view/loading.dart';
import 'package:ngobrolkuy/model/pesanModel.dart';
import 'package:ngobrolkuy/model/userModel.dart';
import 'package:ngobrolkuy/komponen_view/bubble.dart';

class RuangPesan extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final pesanController = TextEditingController();
    final user = Get.find<UserController>();
    final upload = Get.put(UtilityController());
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
                        return Obx(
                          () => Padding(
                            padding: const EdgeInsets.all(10),
                            child: (upload.image.value == "")
                                ? ListView.builder(
                                    itemCount: snaps.data!.docs.length,
                                    reverse: true,
                                    itemBuilder: (_, i) {
                                      DocumentSnapshot doc =
                                          snaps.data!.docs[i];
                                      PesanModel pesanModel =
                                          PesanModel.fromDoc(doc);
                                      return (pesanModel.tipe == "text")
                                          ? bubbleChatText(
                                              pesanModel, auth.user!.uid)
                                          : bubbleChatImage(
                                              pesanModel, auth.user!.uid);
                                    },
                                  )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Text(
                                        "Preview Gambar",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 30,
                                          color: primary,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Container(
                                        height: Get.width,
                                        child: Image.file(
                                          File(upload.image.value),
                                          fit: BoxFit.scaleDown,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Obx(
                  () => Container(
                    child: (upload.image.value == "")
                        ? Row(
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
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            borderSide:
                                                BorderSide(color: primary),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            borderSide:
                                                BorderSide(color: primary),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            borderSide:
                                                BorderSide(color: primary),
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
                                      onPressed: () {
                                        upload.getImage(ImageSource.gallery);
                                      },
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
                                              ke: Get
                                                  .arguments['userModel'].uid,
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
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              IconButton(
                                onPressed: () {
                                  upload.resetImage();
                                },
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.redAccent,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  upload.getImage(ImageSource.gallery);
                                },
                                icon: Icon(
                                  Icons.update_outlined,
                                  color: brown,
                                ),
                              ),
                              (upload.loadingUpload.isTrue)
                                  ? CircularProgressIndicator()
                                  : IconButton(
                                      icon: Icon(
                                        Icons.send_outlined,
                                        color: primaryAccent,
                                      ),
                                      onPressed: () async {
                                        upload.loadingUpload.value = true;
                                        upload.urlImage.value =
                                            await StorageServices.uploadImage(
                                          fileImage: File(upload.image.value),
                                          userId: auth.user!.uid,
                                          jenis: "pesan",
                                        );
                                        PesanModel pesan = PesanModel(
                                          dari: auth.user!.uid,
                                          ke: Get.arguments['userModel'].uid,
                                          pesan: upload.urlImage.value,
                                        );
                                        await user.kirimPesanGambar(
                                            pesan: pesan);
                                        upload.resetImage();
                                        pesanController.clear();
                                      },
                                    ),
                            ],
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
