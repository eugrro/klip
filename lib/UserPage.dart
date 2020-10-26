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
                child: Image.asset("lib/assets/images/personOutline.png"),
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
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 15,
            ),
            child: Text(
              "Sample bio text for the current user",
              style: TextStyle(
                fontSize: 16 + Constants.textChange,
                color: Constants.backgroundWhite,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                height: 35,
                width: MediaQuery.of(context).size.width / 3,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: kElevationToShadow[3],
                  color: Constants.purpleColor,
                ),
                child: Center(child: Text("Follow", style: ,)),
              ),
              Container(),
            ],
          ),
        ],
      ),
    );
  }
}
