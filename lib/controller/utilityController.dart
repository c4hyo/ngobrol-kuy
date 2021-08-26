import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart' as store;
import 'package:uuid/uuid.dart';

class UtilityController extends GetxController {
  final pencarian = "".obs;
  final image = "".obs;
  final urlImage = "".obs;
  final loadingUpload = false.obs;

  void getImage(ImageSource source) async {
    var img = await ImagePicker().pickImage(source: source);
    if (img != null) {
      image.value = img.path;
    }
  }

  void resetImage() {
    image.value = "";
    urlImage.value = "";
    loadingUpload.value = false;
  }
}

class ImageConfig {
  static compressImage(String imageId, File image) async {
    final tempDir = await getTemporaryDirectory();
    final paths = tempDir.path;
    File? compress = await FlutterImageCompress.compressAndGetFile(
      image.absolute.path,
      "$paths/img_$imageId.jpg",
      quality: 70,
    );
    return compress;
  }
}

class StorageServices {
  static store.Reference storage = store.FirebaseStorage.instance.ref();

  static Future<String> uploadImage(
      {File? fileImage, String? userId, String? jenis}) async {
    String imageId = Uuid().v4();
    File image = await ImageConfig.compressImage(imageId, fileImage!);
    store.UploadTask uploadTask =
        storage.child("$jenis/$userId/$imageId.jpg").putFile(image);
    store.TaskSnapshot snaps = await uploadTask.whenComplete(() => null);
    String imageUrl = await snaps.ref.getDownloadURL();
    return imageUrl;
  }
}
