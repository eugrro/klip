import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:klip/TopNavBar.dart';
import 'package:toast/toast.dart';
import 'TopSection.dart';
import 'package:klip/Pages.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);

    return MaterialApp(
      title: 'Klips',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        backgroundColor: Colors.white,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  int pagePosition = 0;
  ValueNotifier pageValueNotifier = ValueNotifier(0);
  PageController pageController = new PageController(initialPage: 0);

  callback(newPagePosition) {
    setState(() {
      pagePosition = newPagePosition;
      pageController.jumpToPage(pagePosition);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            Container(
              height: 15,
            ),
            TopSection(),
            pagePosition == 0
                ? TopNavBar(0, callback)
                : pagePosition == 1
                    ? TopNavBar(1, callback)
                    : pagePosition == 2
                        ? TopNavBar(2, callback)
                        : TopNavBar(3, callback),
            Pages(pagePosition, callback, pageController),
          ],
        ),
      ),
    );
  }
}
/*      children: [
        Container(
          height: 30,
        ),
        Container(
          color: Colors.white,
          child: Text("HI"),
        ),
        TopSection(),
        TopNavBar(),
        SizedBox(
          height: 300.0,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              Text("HI"),
              Text("HI"),
              Text("HI"),
            ],
          ),
        ),
        */
