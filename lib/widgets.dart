import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import './Constants.dart' as Constants;

ChewieController klipChewieController(VideoPlayerController vp) {
  return ChewieController(
    videoPlayerController: vp,
    looping: false,
    autoInitialize: true,
    allowMuting: false,
    showControls: false,
    playbackSpeeds: [0.5, 1, 1.5, 2],
    customControls: Container(
      height: 10,
      width: 10,
      color: Colors.green,
    ),
    materialProgressColors: ChewieProgressColors(
      playedColor: Constants.purpleColor,
      handleColor: Constants.purpleColor,
      backgroundColor: Colors.grey[100],
      bufferedColor: Colors.grey,
    ),
  );
}

Widget klipLogo(double height, double width) {
  return ShaderMask(
    shaderCallback: (rect) {
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        stops: [.3, .8],
        colors: [Constants.backgroundWhite, Constants.purpleColor],
      ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
    },
    blendMode: BlendMode.srcIn,
    child: Center(
      child: Image.asset(
        "lib/assets/images/KlipLogo.png",
        width: width,
        height: height,
        fit: BoxFit.contain,
      ),
    ),
  );
}

//Converts the time the comment was posted to a string
//Expects an input of time since epoch in seconds
//returns a string like '1d' or '3w'
String getTimeFromSeconds(String input) {
  //entire function is in seconds no need to go to milliseconds
  if (input == "" || input == " " || input == null) return "";
  //get current time in seconds
  int currTime = (DateTime.now().millisecondsSinceEpoch / 1000).round();
  print("INPUT: " + input);
  int inputTime = int.tryParse(input);
  if (inputTime == null) return "";
  int differenceTime = currTime - inputTime;
  //Year
  int oneYear = 60 * 60 * 24 * 365;
  if (differenceTime > oneYear) {
    int numYears = (differenceTime / oneYear).round();
    if (numYears == 0) return "ERROR year";
    return numYears.toString() + "y";
  }
  //Month
  int oneMonth = 60 * 60 * 24 * 30;
  if (differenceTime > oneMonth) {
    int numMonths = (differenceTime / oneMonth).round();
    if (numMonths == 0) return "ERROR month";
    return numMonths.toString() + "m";
  }
  //Week
  int oneWeek = 60 * 60 * 24 * 7;
  if (differenceTime > oneWeek) {
    int numWeeks = (differenceTime / oneWeek).round();
    if (numWeeks == 0) return "ERROR week";
    return numWeeks.toString() + "w";
  }
  //Day
  int oneDay = 60 * 60 * 24;
  if (differenceTime > oneDay) {
    int numDays = (differenceTime / oneDay).round();
    if (numDays == 0) return "ERROR day";
    return numDays.toString() + "d";
  }
  //Hour
  int oneHour = 60 * 60;
  if (differenceTime > oneHour) {
    int numHours = (differenceTime / oneHour).round();
    if (numHours == 0) return "ERROR day";
    return numHours.toString() + "h";
  }
  //Minutes
  int oneMinute = 60;
  if (differenceTime > oneMinute) {
    int numMinutes = (differenceTime / oneMinute).round();
    if (numMinutes == 0) return "ERROR min";
    return numMinutes.toString() + " min";
  }
  return "< 1 minute ago";
}

void showError(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    margin: EdgeInsets.only(
        bottom: Constants.bottomNavBarHeight + 10, left: MediaQuery.of(context).size.width / 8, right: MediaQuery.of(context).size.width / 8),
    behavior: SnackBarBehavior.floating,
    padding: EdgeInsets.zero,
    backgroundColor: Constants.backgroundWhite.withOpacity(.9),
    content: Container(
      height: 50,
      child: Row(
        children: [
          Container(
            height: 50,
            width: 5,
            color: Colors.red,
          ),
          Container(
            width: 15,
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Constants.backgroundBlack,
                fontSize: 14 + Constants.textChange,
              ),
            ),
          )
        ],
      ),
    ),
    duration: const Duration(milliseconds: 1500),
  ));
}

void showSnackbar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    margin: EdgeInsets.only(
        bottom: Constants.bottomNavBarHeight + 10, left: MediaQuery.of(context).size.width / 8, right: MediaQuery.of(context).size.width / 8),
    behavior: SnackBarBehavior.floating,
    padding: EdgeInsets.zero,
    backgroundColor: Constants.backgroundWhite.withOpacity(.9),
    content: Container(
      height: 50,
      child: Row(
        children: [
          Container(
            height: 50,
            width: 5,
            color: Constants.purpleColor,
          ),
          Container(
            width: 15,
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Constants.backgroundBlack,
                fontSize: 14 + Constants.textChange,
              ),
            ),
          )
        ],
      ),
    ),
    duration: const Duration(milliseconds: 2000),
  ));
}

//check this widget
Widget klipTextField(double height, double width, TextEditingController contr, {String labelText, double thickness, double labelTextFontSize}) {
  Color purpleColor;
  Color textColor;
  void initColors() {
    Builder(builder: (BuildContext context) {
      purpleColor = Constants.purpleColor;
      textColor = Constants.backgroundWhite;
    });
  }

  initColors();
  if (thickness == null) thickness = 2.0;
  FocusNode fcs = FocusNode();
  return Stack(
    children: [
      GestureDetector(
        onTap: () {
          if (!fcs.hasFocus) fcs.requestFocus();
        },
        child: IgnorePointer(
          child: Padding(
            padding: EdgeInsets.all(thickness),
            child: Container(
              height: height,
              width: width,
              //color: Colors.grey[875],
            ),
          ),
          ignoring: false, // or false to disable this behavior
        ),
      ),
      Align(
        alignment: Alignment.center,
        child: TextFormField(
          cursorColor: textColor,
          decoration: new InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            //errorBorder: InputBorder.none,
            //disabledBorder: InputBorder.none,
            contentPadding: EdgeInsets.only(
              left: 15,
              bottom: 0,
              top: (16 + Constants.textChange) / 4,
              right: 15,
            ),
          ),
          controller: contr,
          focusNode: fcs,
          style: TextStyle(
            color: textColor,
            fontSize: 16 + Constants.textChange,
          ),
        ),
      ),
      labelText != null
          ? Padding(
              padding: EdgeInsets.only(
                top: height - (14 + Constants.textChange) / 2 + thickness,
                left: width / 2,
                right: 0,
                bottom: 0,
              ),
              child: Container(
                width: width / 2 - height / 2,
                child: Center(
                  child: Text(
                    labelText,
                    style: TextStyle(
                      fontSize: labelTextFontSize == null ? 14 + Constants.textChange : labelTextFontSize + Constants.textChange,
                      color: textColor,
                    ),
                  ),
                ),
              ),
            )
          : Container(),
      Padding(
        //BR
        padding: EdgeInsets.only(
          top: height / 2 + thickness * 2,
          left: width - height / 2,
          right: 0,
          bottom: 0,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(bottomRight: Radius.circular(thickness)),
          child: Container(
            height: height / 2,
            width: height / 2,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(width: thickness, color: purpleColor),
                right: BorderSide(width: thickness, color: purpleColor),
              ),
            ),
          ),
        ),
      ),
      ClipRRect(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(thickness)),
        child: Container(
          height: height / 2,
          width: height / 2,
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(width: thickness, color: purpleColor),
              left: BorderSide(width: thickness, color: purpleColor),
            ),
          ),
        ),
      ),
      Padding(
        //BL
        padding: EdgeInsets.only(
          top: height + thickness,
          left: 0,
          right: 0,
          bottom: 0,
        ),
        child: Container(
          height: thickness,
          width: width / 2,
          decoration: BoxDecoration(
            color: purpleColor,
            borderRadius: BorderRadius.circular(thickness),
          ),
        ),
      ),
      Padding(
        //TR
        padding: EdgeInsets.only(
          top: 0,
          left: width / 2,
          right: 0,
          bottom: 0,
        ),
        child: Container(
          height: thickness,
          width: width / 2,
          decoration: BoxDecoration(
            color: purpleColor,
            borderRadius: BorderRadius.circular(thickness),
          ),
        ),
      ),
    ],
  );
}

///0 is from bottom to top
///
///1 is from top to bottom
///
///2 is from left to right
///
///3 if from right to left
///
class SlideInRoute extends PageRouteBuilder {
  final Widget page;

  final int direction;
  SlideInRoute({this.page, this.direction})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              SlideTransition(
            position: Tween<Offset>(
              begin: direction == 0
                  ? Offset(0, 1)
                  : direction == 1
                      ? Offset(0, -1)
                      : direction == 2
                          ? Offset(-1, 0)
                          : Offset(1, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
}

// Textfield widget customised to be expanding when handle large body of texts gracefully
class ExpandingTextField extends StatelessWidget {
  const ExpandingTextField({
    Key key,
    @required this.maxHeightPx,
    @required this.child,
    @required this.width,
  }) : super(key: key);

  final TextField child;
  final double maxHeightPx; // height after which textfield won't expand to fit text but will be scrollable
  final double width;
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: maxHeightPx,
      ),
      child: SizedBox(
        width: width,
        child: child,
      ),
    );
  }
}
