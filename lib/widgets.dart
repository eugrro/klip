import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import './Constants.dart' as Constants;
import 'package:klip/currentUser.dart' as currentUser;

ChewieController klipChewieController(VideoPlayerController vp) {
  return ChewieController(
    videoPlayerController: vp,
    autoPlay: true,
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

void showError(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    margin: EdgeInsets.only(bottom: 10, left: 15, right: 15),
    behavior: SnackBarBehavior.floating,
    backgroundColor: Constants.backgroundWhite.withOpacity(.9),
    content: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(text),
        Text(
          "X",
          style: TextStyle(color: Colors.red, fontSize: 28, fontWeight: FontWeight.bold),
        ),
      ],
    ),
    duration: const Duration(seconds: 2),
  ));
}

void showSnackbar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    margin: EdgeInsets.only(bottom: 10, left: 15, right: 15),
    behavior: SnackBarBehavior.floating,
    backgroundColor: Constants.backgroundWhite.withOpacity(.9),
    content: Text(text),
    duration: const Duration(seconds: 2),
  ));
}

Widget klipTextField(double height, double width, TextEditingController contr, {String labelText, double thickness, double labelTextFontSize}) {
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
          cursorColor: Constants.backgroundWhite,
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
            color: Constants.backgroundWhite,
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
                      color: Constants.backgroundWhite,
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
                bottom: BorderSide(width: thickness, color: Constants.purpleColor),
                right: BorderSide(width: thickness, color: Constants.purpleColor),
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
              top: BorderSide(width: thickness, color: Constants.purpleColor),
              left: BorderSide(width: thickness, color: Constants.purpleColor),
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
            color: Constants.purpleColor,
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
            color: Constants.purpleColor,
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
