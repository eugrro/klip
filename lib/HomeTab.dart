import 'package:flutter/material.dart';
import './Constants.dart' as Constants;

import 'Vid.dart';

class HomeTab extends StatefulWidget {
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(width: 0, color: Constants.backgroundBlack),
              color: Constants.backgroundBlack,
            ),

            /*child: Column(
          children: [
            Container(
              color: Colors.black,
              height: MediaQuery.of(context).size.height / 8,
            ),
            Vid(),
          ],
        ),*/
          ),
        ),
      ],
    );
  }
}
