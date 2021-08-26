import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ngobrolkuy/config/collection.dart';
import 'package:ngobrolkuy/controller/authController.dart';
import 'package:ngobrolkuy/controller/postingController.dart';
import 'package:ngobrolkuy/komponen_view/loading.dart';
import 'package:ngobrolkuy/model/postingModel.dart';

class FetchPostingProfil extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();
    final post = Get.put(PostingController());
    return StreamBuilder<QuerySnapshot>(
      stream: posting
          .where("id_user", isEqualTo: auth.user!.uid)
          .orderBy("waktu", descending: true)
          .snapshots(),
      builder: (_, snap) {
        if (!snap.hasData) {
          return Center(
            child: LoadingProses(),
          );
        }
        return Padding(
          padding: EdgeInsets.all(5),
          child: Obx(
            () => GridView.builder(
              itemCount: snap.data!.docs.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: (post.show.isTrue) ? 1 : 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (_, i) {
                DocumentSnapshot doc = snap.data!.docs[i];
                PostingModel postingModel = PostingModel.fromDoc(doc);
                return GestureDetector(
                  onTap: () {
                    post.show.toggle();
                  },
                  child: GridTile(
                    header: FadeInImage(
                      image: NetworkImage(postingModel.urlPosting!),
                      placeholder: AssetImage("assets/logo.png"),
                      fit: BoxFit.scaleDown,
                    ),
                    footer: Text("yy"),
                    child: Text("${postingModel.judul}"),
                  ),
                );
              },
            ),
          ),
        );
        // return Text("${snap.data!.docs.length}");
      },
    );
  }
}
