import 'package:flutter/material.dart';
import 'package:klip/profileSettings.dart';
import 'package:klip/widgets.dart';
import './Constants.dart' as Constants;
import './PaymentFunctions.dart';
import 'package:klip/currentUser.dart' as currentUser;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:stripe_payment/stripe_payment.dart';

class UserPage extends StatefulWidget {
  final String uid;
  UserPage(this.uid);

  @override
  _UserPageState createState() => _UserPageState(uid);
}

class _UserPageState extends State<UserPage> {
  String uid;
  _UserPageState(this.uid);
  bool isFollowing;

  @override
  void initState() {
    super.initState();
    StripePayment.setOptions(StripeOptions(
      publishableKey: Constants.StripePKey,
      androidPayMode: 'test',
    ));
    currentUser.displayCurrentUser();
    if (currentUser.currentUserFollowing.contains(uid)) {
      isFollowing = true;
    } else {
      isFollowing = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.backgroundBlack,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: Constants.statusBarHeight + 10,
            ),
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Text(
                            currentUser.numViews.toString(),
                            style: TextStyle(
                              fontSize: 28 + Constants.textChange,
                              color: Constants.backgroundWhite,
                            ),
                          ),
                          Text(
                            "Views",
                            style: TextStyle(
                              fontSize: 14 + Constants.textChange,
                              color: Constants.backgroundWhite.withOpacity(.5),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: 10,
                      ),
                      Container(
                        width: 10,
                      ),
                      Column(
                        children: [
                          Text(
                            currentUser.numKredits.toString(),
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
                ),
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 100),
                    child: Container(
                      width: MediaQuery.of(context).size.width * .95,
                      height: 135,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Constants.purpleColor.withOpacity(.02), Constants.purpleColor.withOpacity(.1)],
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 25, left: 15, right: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    if (currentUser.uid == uid) {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileSettings())).then((value) {
                                        setState(() {});
                                      });
                                    } else {
                                      currentUser.currentUserFollowing.add(uid);
                                    }
                                  },
                                  child: Container(
                                    height: 35,
                                    width: MediaQuery.of(context).size.width / 50 * 12,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3),
                                      boxShadow: kElevationToShadow[4],
                                      gradient: LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors: [Colors.purple, Constants.purpleColor.withOpacity(.4)],
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        uid == currentUser.uid
                                            ? "Settings"
                                            : isFollowing
                                                ? "Following"
                                                : "Follow",
                                        style: TextStyle(
                                          color: Constants.backgroundWhite.withOpacity(.9),
                                          fontSize: 15 + Constants.textChange,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    checkIfNativePayReady();
                                  },
                                  child: Container(
                                    height: 35,
                                    width: MediaQuery.of(context).size.width / 50 * 12,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3),
                                      boxShadow: kElevationToShadow[4],
                                      gradient: LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors: [Constants.purpleColor.withOpacity(.4), Colors.purple],
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Subscribe",
                                        style: TextStyle(
                                          color: Constants.backgroundWhite.withOpacity(.9),
                                          fontSize: 15 + Constants.textChange,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                currentUser.uName,
                                style: TextStyle(
                                  fontSize: 20 + Constants.textChange,
                                  color: Constants.backgroundWhite.withOpacity(.9),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Text(
                              currentUser.bio,
                              style: TextStyle(
                                fontSize: 13 + Constants.textChange,
                                color: Constants.backgroundWhite.withOpacity(.6),
                              ),
                            ),
                          ),

                          // Padding(
                          //   padding: EdgeInsets.symmetric(
                          //     vertical: 10,
                          //   ),
                          //   child: Container(
                          //     height: 2,
                          //     width: MediaQuery.of(context).size.width / 15 * 14,
                          //     color: Constants.purpleColor,
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Container(
                      width: 150,
                      child: CircleAvatar(
                          radius: 75,
                          child: ClipOval(
                            child: FutureBuilder<Widget>(
                              future: currentUser.userProfileImg, // a previously-obtained Future<String> or null
                              builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
                                if (snapshot.hasData) {
                                  return snapshot.data;
                                } else {
                                  return Constants.tempAvatar;
                                }
                              },
                            ),
                          )),
                    ),
                  ),
                ),
              ],
            ),
          ),
          ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(top: 10, bottom: 0),
            children: [
              //vidListItem(),
              vidListItem(),
            ],
          ),
        ],
      ),
    );
  }

  Widget vidListItem() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width / 30,
        vertical: 7,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
              right: 10,
            ),
            child: Container(
              height: 120,
              width: 220,
              color: Colors.indigo,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  bottom: 15,
                ),
                child: Container(
                  width: 125,
                  child: AutoSizeText(
                    'Woah what an epic video Title!',
                    style: Constants.tStyle(),
                    maxLines: 3,
                  ),
                ),
              ),
              Text(
                "104 Views",
                style: Constants.tStyle(fontSize: 13),
              ),
              Text(
                "13 Comments",
                style: Constants.tStyle(fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
