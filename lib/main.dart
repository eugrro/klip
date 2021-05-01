import 'dart:convert';
import 'dart:ui';
import 'package:klip/login/StartPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './Constants.dart' as Constants;

void main() {
  runApp(MyApp());
}

//////////////////////////////////////////////////////////
///////////////////TO REMOVE IN PRODUCTION////////////////
Future<String> loadIP() async {
  return (jsonDecode(await rootBundle.loadString('lib/server/ip.json')))["dartUrl"];
}
//"nodeUrl": "127.0.0.1",
//"dartUrl": "http://10.0.2.2:3000/"
///////////////////TO REMOVE IN PRODUCTION////////////////
//////////////////////////////////////////////////////////

//LOOK INTO THIS https://pub.dev/packages/animated_text_kit

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Constants.purpleColor.withOpacity(0),
        //statusBarIconBrightness: Brightness.light,
        //statusBarBrightness: Brightness.dark,
      ),
    );
    setConstantsIp();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return ScrollConfiguration(
          behavior: MyBehavior(),
          child: child,
        );
      },
      home: StartPage(),
      theme: ThemeData(
        textSelectionTheme: TextSelectionThemeData(
          selectionHandleColor: Constants.purpleColor,
          selectionColor: Constants.purpleColor.withOpacity(.5),
          cursorColor: Constants.purpleColor,
        ),
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Constants.backgroundBlack,
      ),
    );
  }
}

setConstantsIp() async {
  Constants.nodeURL = await loadIP();
}

Map<String, Widget Function(BuildContext)> klipRoutes = {
  '/': (context) => StartPage(),
  //'/second': (context) => SecondScreen(),
};

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
