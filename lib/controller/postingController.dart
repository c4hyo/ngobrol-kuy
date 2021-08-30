import 'package:get/get.dart';
import 'package:ngobrolkuy/config/collection.dart';
import 'package:ngobrolkuy/controller/authController.dart';
import 'package:ngobrolkuy/model/postingModel.dart';

class PostingController extends GetxController {
  var totalPosting = 0.obs;
  var totalTeman = 0.obs;
  var listTeman = <String>[].obs;
  Future<bool> addPosting({PostingModel? postingModel}) async {
    try {
      await users.doc(postingModel!.idUser).collection("posting").add({
        "id_user": postingModel.idUser,
        "judul": postingModel.judul,
        "url_posting": postingModel.urlPosting,
        "waktu": DateTime.now().toIso8601String(),
      });
      await users
          .doc(postingModel.idUser)
          .collection("teman")
          .get()
          .then((value) {
        if (value.docs.length > 0) {
          value.docs.forEach((element) {
            users.doc(element.id).collection("posting").add({
              "id_user": postingModel.idUser,
              "judul": postingModel.judul,
              "url_posting": postingModel.urlPosting,
              "waktu": DateTime.now().toIso8601String(),
            });
          });
        }
      });

      return true;
    } catch (e) {
      return false;
    }
  }

  Stream<int> getTotalPosting(String? uid) {
    return users
        .doc(uid)
        .collection("posting")
        .where("id_user", isEqualTo: uid)
        .snapshots()
        .map((event) => event.docs.length);
  }

  Stream<int> getTotalTeman(String uid) {
    return users
        .doc(uid)
        .collection("teman")
        .snapshots()
        .map((event) => event.docs.length);
  }

  Stream<List<String>> getListTeman(String id) {
    return users.doc(id).collection("teman").snapshots().map((event) {
      List<String> teman = [];
      teman.add(id);
      event.docs.forEach((element) {
        teman.add(element.id);
      });
      return teman;
    });
  }

  @override
  void onInit() {
    super.onInit();
    totalPosting.bindStream(
      getTotalPosting(Get.find<AuthController>().user!.uid),
    );
    totalTeman.bindStream(
      getTotalTeman(Get.find<AuthController>().user!.uid),
    );
    listTeman.bindStream(getListTeman(Get.find<AuthController>().user!.uid));
  }
}
