import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:ngobrolkuy/config/collection.dart';
import 'package:ngobrolkuy/controller/userController.dart';
import 'package:ngobrolkuy/model/userModel.dart';

class AuthController extends GetxController {
  Rxn<User> _user = Rxn<User>();
  User? get user => _user.value;

  final loginLoading = false.obs;
  final registrasiLoading = false.obs;

  void registrasi({String? email, String? password, String? nama}) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email!, password: password!);
      UserModel userModel = UserModel(
        email: email,
        nama: nama,
        uid: userCredential.user!.uid,
      );
      if (await Get.find<UserController>().buatAkun(userModel)) {
        Get.find<UserController>().userModel = userModel;
        Get.back();
      }
      registrasiLoading.value = false;
    } catch (e) {
      registrasiLoading.value = false;
      Get.snackbar("Error", e.toString());
    }
  }

  void login({String? email, String? password}) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email!, password: password!);
      Get.find<UserController>().userModel =
          await Get.find<UserController>().profilUser(userCredential.user!.uid);
      users.doc(userCredential.user!.uid).update({"online": true});
      loginLoading.value = false;
    } catch (e) {
      loginLoading.value = false;
      Get.snackbar("Error", e.toString());
    }
  }

  void logout() async {
    await auth.signOut();
    Get.find<UserController>().clearPengguna();
  }

  @override
  void onInit() {
    super.onInit();
    _user.bindStream(auth.authStateChanges());
  }
}

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthController(), permanent: true);
  }
}
