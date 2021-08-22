import 'dart:math';

import 'package:jiffy/jiffy.dart';

String generateRandomString(int len) {
  var r = Random();
  const _chars = 'qwertyuiopasdfghjklzxcvbnm1234567890';
  return List.generate(len, (index) => _chars[r.nextInt(_chars.length)]).join();
}
String waktu(String tgl){
  return Jiffy(tgl).fromNow();
}