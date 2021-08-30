import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ngobrolkuy/config/collection.dart';
import 'package:ngobrolkuy/config/warna.dart';
import 'package:ngobrolkuy/controller/authController.dart';
import 'package:ngobrolkuy/controller/postingController.dart';
import 'package:ngobrolkuy/controller/userController.dart';
import 'package:ngobrolkuy/controller/utilityController.dart';
import 'package:ngobrolkuy/komponen_view/fetchPostingProfil.dart';
import 'package:ngobrolkuy/komponen_view/uploadposting.dart';

class Profil extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ProfilX();
  }
}

class ProfilX extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Get.find<UserController>();
    final upload = Get.put(UtilityController());
    final post = Get.find<PostingController>();
    final auth = Get.find<AuthController>();
    return Obx(
      () => Scaffold(
        floatingActionButtonLocation: (upload.image.value == "")
            ? FloatingActionButtonLocation.miniCenterFloat
            : FloatingActionButtonLocation.miniStartTop,
        floatingActionButton: FloatingActionButton(
          backgroundColor: (upload.image.value == "") ? primary : Colors.red,
          onPressed: () {
            if (upload.image.value == "") {
              upload.getImage(ImageSource.gallery);
            } else {
              if (upload.loadingUpload.isFalse) {
                upload.resetImage();
              }
            }
          },
          child: Icon(
            (upload.image.value == "")
                ? Icons.add_a_photo
                : (upload.loadingUpload.isTrue)
                    ? Icons.refresh
                    : Icons.cancel,
          ),
        ),
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {
                users.doc(auth.user!.uid).update({"online": false});
                auth.logout();
                Get.reset();
                Get.put(AuthController());
                Get.put(UserController());
              },
              icon: Icon(
                Icons.exit_to_app,
              ),
            )
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(150),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      primary,
                      primaryAccent,
                    ]),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage("assets/logo.png"),
                    radius: 40,
                    backgroundColor: white,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      "${user.userModel.nama}",
                      style: TextStyle(
                        color: white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Obx(
                    () => Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            "Posting: ${post.totalPosting.value}",
                            style: TextStyle(
                              color: white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            "Teman: ${post.totalTeman.value}",
                            style: TextStyle(
                              color: white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Obx(
          () => SafeArea(
            child: (upload.image.value == "")
                ? FetchPostingProfil()
                : AddPostingUser(),
          ),
        ),
      ),
    );
  }
}
