import 'dart:convert';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:klip/login/StartPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './Constants.dart' as Constants;
import "package:http/http.dart" as http;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) {
    runApp(new MyApp());
  });
}

//LOOK INTO THIS https://pub.dev/packages/animated_text_kit

class MyApp extends StatelessWidget {
  String defaultTheme = "dark";

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
    return ThemeProvider(
      themes: Constants.allThemes,
      child: ThemeConsumer(
        child: Builder(
          builder: (themeContext) => MaterialApp(
            debugShowCheckedModeBanner: false,
            builder: (context, child) {
              ThemeProvider.controllerOf(context).setTheme(defaultTheme);
              return ScrollConfiguration(
                behavior: MyBehavior(),
                child: child,
              );
            },
            theme: ThemeProvider.themeOf(themeContext).data,
            home: StartPage(),
          ),
        ),
      ),
    );
  }
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
