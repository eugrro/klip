import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:klip/TopNavBar.dart';
import 'TopSection.dart';

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
  TabController _tabController;
  PageController _pageController;

  @override
  void initState() {
    _pageController = new PageController();
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
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
              height: 30,
            ),
            TopSection(),
            TopNavBar(),
            SizedBox(
              height: 300.0,
              child: PageView(
                scrollDirection: Axis.horizontal,
                controller: _pageController,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    color: Colors.red,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    color: Colors.blue,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    color: Colors.green,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    color: Colors.orange,
                  ),
                ],
              ),
            ),
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
