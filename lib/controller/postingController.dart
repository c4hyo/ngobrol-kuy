import 'package:get/get.dart';
import 'package:ngobrolkuy/config/collection.dart';
import 'package:ngobrolkuy/controller/authController.dart';
import 'package:ngobrolkuy/model/postingModel.dart';

class PostingController extends GetxController {
  var totalPosting = 0.obs;
  var totalTeman = 0.obs;
  Future<bool> addPosting({PostingModel? postingModel}) async {
    try {
      await posting.add({
        "id_user": postingModel!.idUser,
        "judul": postingModel.judul,
        "url_posting": postingModel.urlPosting,
        "waktu": DateTime.now().toIso8601String(),
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Stream<int> getTotalPosting(String? uid) {
    return posting
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

  @override
  void onInit() {
    super.onInit();
    String uid = Get.find<AuthController>().user!.uid;
    totalPosting.bindStream(
      getTotalPosting(uid),
    );
    totalTeman.bindStream(getTotalTeman(uid));
  }
}
