import 'package:flutter/material.dart';
import './Constants.dart' as Constants;
import 'Pages.dart';
import 'TopNavBar.dart';
import 'TopSection.dart';

class UserPage extends StatefulWidget {
  UserPage();

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.backgroundBlack,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: 10,
              bottom: 10,
            ),
            child: Text(
              "UserName",
              style: TextStyle(
                fontSize: 24 + Constants.textChange,
                color: Constants.backgroundWhite,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Text(
                    "1805",
                    style: TextStyle(
                      fontSize: 28 + Constants.textChange,
                      color: Constants.backgroundWhite,
                    ),
                  ),
                  Text(
                    "views",
                    style: TextStyle(
                      fontSize: 14 + Constants.textChange,
                      color: Constants.backgroundWhite.withOpacity(.5),
                    ),
                  ),
                ],
              ),
              CircleAvatar(
                radius: 65,
                child: Image.asset("assets/images/personOutline.png"),
              ),
              Column(
                children: [
                  Text(
                    "8,705",
                    style: TextStyle(
                      fontSize: 28 + Constants.textChange,
                      color: Constants.backgroundWhite,
                    ),
                  ),
                  Text(
                    "Kredits",
                    style: TextStyle(
                      fontSize: 14 + Constants.textChange,
                      color: Constants.backgroundWhite.withOpacity(.5),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Text(
            "Sample bio text for the current user",
            style: TextStyle(
              fontSize: 16 + Constants.textChange,
              color: Constants.backgroundWhite,
            ),
          ),
          Row(
            children: [],
          ),
        ],
      ),
    );
  }
}
