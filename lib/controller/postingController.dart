import 'package:get/get.dart';
import 'package:ngobrolkuy/config/collection.dart';
import 'package:ngobrolkuy/model/postingModel.dart';

class PostingController extends GetxController {
  var show = false.obs;
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
}
