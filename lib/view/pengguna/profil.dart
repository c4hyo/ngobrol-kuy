import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ngobrolkuy/config/warna.dart';
import 'package:ngobrolkuy/controller/userController.dart';
import 'package:ngobrolkuy/controller/utilityController.dart';
import 'package:ngobrolkuy/komponen_view/fetchPostingProfil.dart';
import 'package:ngobrolkuy/komponen_view/uploadposting.dart';

class Profil extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Get.find<UserController>();
    final upload = Get.put(UtilityController());
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
              upload.resetImage();
            }
          },
          child: Icon(
            (upload.image.value == "") ? Icons.add_a_photo : Icons.cancel,
          ),
        ),
        appBar: AppBar(
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(100),
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
