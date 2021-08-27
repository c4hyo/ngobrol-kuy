import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ngobrolkuy/config/collection.dart';
import 'package:ngobrolkuy/config/warna.dart';
import 'package:ngobrolkuy/controller/authController.dart';
import 'package:ngobrolkuy/controller/userController.dart';
import 'package:ngobrolkuy/komponen_view/loading.dart';
import 'package:ngobrolkuy/view/pengguna/beranda.dart';
import 'package:ngobrolkuy/view/pengguna/pencarian.dart';
import 'package:ngobrolkuy/view/pengguna/profil.dart';
import 'package:ngobrolkuy/view/pengguna/teman.dart';

class Beranda extends StatefulWidget {
  @override
  _BerandaState createState() => _BerandaState();
}

class _BerandaState extends State<Beranda> with WidgetsBindingObserver {
  final auth = Get.find<AuthController>();

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        users.doc(auth.user!.uid).update({"online": true});
        break;
      case AppLifecycleState.inactive:
        users.doc(auth.user!.uid).update({
          "online": false,
          "menulis": false,
        });
        break;
      case AppLifecycleState.paused:
        users.doc(auth.user!.uid).update({"online": false, "menulis": false});
        break;

      case AppLifecycleState.detached:
        break;
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetUserModel();
  }
}

class GetUserModel extends StatelessWidget with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserController>(
        init: Get.find<UserController>(),
        initState: (_) async {
          Get.find<UserController>().userModel =
              await Get.find<UserController>()
                  .profilUser(Get.find<AuthController>().user!.uid);
        },
        builder: (user) {
          return Obx(() {
            return (user.userModel.uid == null)
                ? Scaffold(
                    body: Center(
                      child: LoadingProses(),
                    ),
                  )
                : UserMain();
          });
        });
  }
}

class UserMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Get.find<UserController>();
    List<Widget> _tabs() => listScreen;
    final List<Widget> _tab = _tabs();
    return Obx(() {
      return Scaffold(
        backgroundColor: white,
        bottomNavigationBar: BottomNavigationBar(
          items: bottomItem,
          type: BottomNavigationBarType.fixed,
          currentIndex: user.indexTab.value,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.white,
          iconSize: 30,
          onTap: (i) => user.indexTab.value = i,
          backgroundColor: primary,
          showSelectedLabels: false,
          showUnselectedLabels: false,
        ),
        body: SafeArea(
          child: Container(child: _tab[user.indexTab.value]),
        ),
      );
    });
  }
}

List<Widget> listScreen = [
  BerandaHome(),
  Pencarian(),
  Teman(),
  Profil(),
];

List<BottomNavigationBarItem> bottomItem = [
  BottomNavigationBarItem(
    icon: Icon(Icons.message),
    label: "Beranda",
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.search),
    label: "Pencarian",
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.people),
    label: "Teman",
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.person),
    label: "Profil",
  ),
];
