import 'package:flutter/material.dart';

class HomeScrollValueNotifier with ChangeNotifier {
  ScrollController headerScroll = ScrollController();
  PageController pageScroll = PageController();

  double offset;

  void update(double value) {
    offset = value;
    if (headerScroll.hasClients) {
      headerScroll.jumpTo(offset);
    } else {
      print(offset);
    }
    //pageScroll.jumpTo(offset);
    notifyListeners();
  }

  ScrollController getHeaderScroll() {
    return headerScroll;
  }

  PageController getPageScroll() {
    return pageScroll;
  }

  double value() {
    return offset;
  }
}
