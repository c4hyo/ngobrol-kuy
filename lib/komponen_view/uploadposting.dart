import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ngobrolkuy/controller/authController.dart';
import 'package:ngobrolkuy/controller/postingController.dart';
import 'package:ngobrolkuy/controller/utilityController.dart';
import 'package:ngobrolkuy/model/postingModel.dart';

class AddPostingUser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final upload = Get.find<UtilityController>();
    final judul = TextEditingController();
    final auth = Get.find<AuthController>();
    final posting = Get.put(PostingController());
    return Padding(
      padding: const EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: Get.width,
              width: double.infinity,
              child: Image.file(
                File(upload.image.value),
                fit: BoxFit.scaleDown,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextField(
                controller: judul,
                decoration: InputDecoration(hintText: "deskripsi"),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Obx(
              () => Container(
                child: (upload.loadingUpload.isTrue)
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : ElevatedButton(
                        onPressed: () async {
                          upload.loadingUpload.value = true;
                          upload.urlImage.value =
                              await StorageServices.uploadImage(
                            fileImage: File(upload.image.value),
                            userId: auth.user!.uid,
                            jenis: "posting",
                          );
                          PostingModel postingModel = PostingModel(
                            idUser: auth.user!.uid,
                            judul: judul.text,
                            urlPosting: upload.urlImage.value,
                          );
                          await posting.addPosting(postingModel: postingModel);
                          upload.resetImage();
                          judul.clear();
                        },
                        child: Text("Simpan"),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
