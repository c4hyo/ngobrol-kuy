import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingProses extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Lottie.network(
        "https://assets1.lottiefiles.com/packages/lf20_x62chJ.json",
        width: 150,
        height: 150,
      ),
    );
  }
}
