import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ngobrolkuy/config/string.dart';
import 'package:ngobrolkuy/config/warna.dart';
import 'package:ngobrolkuy/model/pesanModel.dart';

Widget bubbleChatText(PesanModel pesanModel, String uid) {
  return (pesanModel.dari == uid)
      ? Bubble(
          margin: BubbleEdges.only(top: 10),
          alignment: Alignment.topRight,
          nip: BubbleNip.rightTop,
          color: primaryAccent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "${pesanModel.pesan}",
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: white,
                  fontSize: 17,
                ),
              ),
              Text(
                "${waktu(pesanModel.waktu!)}",
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 10),
              ),
            ],
          ),
        )
      : Bubble(
          margin: BubbleEdges.only(
            top: 10,
          ),
          alignment: Alignment.topLeft,
          nip: BubbleNip.leftTop,
          color: primary,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${pesanModel.pesan}",
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: white,
                  fontSize: 17,
                ),
              ),
              Text(
                "${waktu(pesanModel.waktu!)}",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 10,
                  color: white,
                ),
              ),
            ],
          ),
        );
}

Widget bubbleChatImage(PesanModel pesanModel, String uid) {
  return (pesanModel.dari == uid)
      ? Bubble(
          margin: BubbleEdges.only(top: 10),
          alignment: Alignment.topRight,
          nip: BubbleNip.rightTop,
          color: primaryAccent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                height: Get.width * 0.9,
                child: FadeInImage(
                  image: NetworkImage(pesanModel.pesan!),
                  placeholder: AssetImage("assets/logo.png"),
                ),
              ),
              Text(
                "${waktu(pesanModel.waktu!)}",
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 10),
              ),
            ],
          ),
        )
      : Bubble(
          margin: BubbleEdges.only(
            top: 10,
          ),
          alignment: Alignment.topLeft,
          nip: BubbleNip.leftTop,
          color: primary,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: Get.width * 0.9,
                child: FadeInImage(
                  image: NetworkImage(pesanModel.pesan!),
                  placeholder: AssetImage("assets/logo.png"),
                ),
              ),
              Text(
                "${waktu(pesanModel.waktu!)}",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 10,
                  color: white,
                ),
              ),
            ],
          ),
        );
}
