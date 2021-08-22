import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:ngobrolkuy/config/style.dart';
import 'package:ngobrolkuy/config/warna.dart';
import 'package:ngobrolkuy/controller/authController.dart';
import 'package:ngobrolkuy/komponen_view/loading.dart';
import 'package:ngobrolkuy/view/auth/regis.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final email = TextEditingController();
    final password = TextEditingController();
    final auth = Get.find<AuthController>();
    return Scaffold(
      backgroundColor: white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                child: Lottie.network(
                  "https://assets1.lottiefiles.com/packages/lf20_qmfs6c3i.json",
                  height: 300,
                  width: 300,
                ),
              ),
              Text(
                "Login",
                style: TextStyle(color: textPrimary, fontSize: 40),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                    image: AssetImage("assets/logo.png"),
                    height: 30,
                    width: 30,
                  ),
                  Text(
                    "Ngobrol Kuy",
                    style: TextStyle(color: textSecond, fontSize: 20),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: email,
                  decoration: InputDecoration(
                    hintText: "Email",
                    focusedBorder: underlineBorderInput,
                    enabledBorder: underlineBorderInput,
                    border: underlineBorderInput,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: TextFormField(
                  controller: password,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "Password",
                    focusedBorder: underlineBorderInput,
                    enabledBorder: underlineBorderInput,
                    border: underlineBorderInput,
                  ),
                ),
              ),
              Obx(
                () => (auth.loginLoading.isTrue)
                    ? LoadingProses()
                    : Container(
                        height: 150,
                        width: double.infinity,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: primaryAccent,
                                  minimumSize: Size(double.infinity, 50),
                                ),
                                onPressed: () {
                                  auth.loginLoading.value = true;
                                  auth.login(
                                      password: password.text,
                                      email: email.text);
                                },
                                child: Text("Login"),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: GestureDetector(
                                onTap: () => Get.to(() => Registrasi()),
                                child: Text(
                                  "Registrasi",
                                  style: TextStyle(color: primary),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
