import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ngobrolkuy/config/warna.dart';
import 'package:ngobrolkuy/controller/authController.dart';
import 'package:ngobrolkuy/controller/userController.dart';
import 'package:ngobrolkuy/view/auth/login.dart';
import 'package:ngobrolkuy/view/pengguna/mainUser.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: AuthBinding(),
      theme: ThemeData(
        textTheme: GoogleFonts.latoTextTheme(),
        primaryColor: primary,
      ),
      home: WrapAuth(),
    );
  }
}

class WrapAuth extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetX<UserController>(
      init: UserController(),
      builder: (_) {
        if (Get.find<AuthController>().user?.uid != null) {
          return Beranda();
        } else {
          return Login();
        }
      },
    );
  }
}
