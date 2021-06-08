import 'package:flutter/material.dart';

Color invertColor(Color c) {
  String util = c.toString();
  int r = int.parse(util.substring(10, 12), radix: 16);
  int g = int.parse(util.substring(12, 14), radix: 16);
  int b = int.parse(util.substring(14, 16), radix: 16);
  int o = int.parse(util.substring(8, 10), radix: 16);
  return Color.fromRGBO(255 - r, 255 - g, 255 - b, (o / 255));
}
