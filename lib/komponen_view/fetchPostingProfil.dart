import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ngobrolkuy/config/collection.dart';
import 'package:ngobrolkuy/controller/authController.dart';
import 'package:ngobrolkuy/komponen_view/loading.dart';
import 'package:ngobrolkuy/model/postingModel.dart';

class FetchPostingProfil extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();
    return StreamBuilder<QuerySnapshot>(
      stream: users
          .doc(auth.user!.uid)
          .collection("posting")
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
          child: GridView.builder(
            itemCount: snap.data!.docs.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
              childAspectRatio: 1 / 1.5,
            ),
            itemBuilder: (_, i) {
              DocumentSnapshot doc = snap.data!.docs[i];
              PostingModel postingModel = PostingModel.fromDoc(doc);
              return GestureDetector(
                onTap: () {
                  Get.dialog(
                    Dialog(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Container(
                              height: Get.width * 0.95,
                              width: Get.width * 0.95,
                              child: FadeInImage(
                                image: NetworkImage(postingModel.urlPosting!),
                                placeholder: AssetImage("assets/logo.png"),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: EdgeInsets.all(20),
                            child: Text(
                              "${postingModel.judul}",
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                child: Cardposting(postingModel),
              );
            },
          ),
        );
        // return Text("${snap.data!.docs.length}");
      },
    );
  }
}

class Cardposting extends StatelessWidget {
  final PostingModel postingModel;
  Cardposting(this.postingModel);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            height: Get.width / 2.7,
            width: Get.width / 2.7,
            child: FadeInImage(
              image: NetworkImage(postingModel.urlPosting!),
              placeholder: AssetImage("assets/logo.png"),
            ),
          ),
          Container(
            child: Text("${postingModel.judul}"),
          ),
        ],
      ),
    );
  }
}
