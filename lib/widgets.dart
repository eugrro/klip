import 'package:flutter/material.dart';
import './Constants.dart' as Constants;
import 'package:klip/currentUser.dart' as currentUser;

Widget klipTextField(double height, double width, TextEditingController contr,
    {String labelText, double thickness, double labelTextFontSize}) {
  if (thickness == null) thickness = 2.0;
  return Stack(children: [
    IgnorePointer(
      child: Padding(
        padding: EdgeInsets.all(thickness),
        child: Container(
          height: height,
          width: width,
          //color: Colors.grey[875],
        ),
      ),
      ignoring: true, // or false to disable this behavior
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
                    fontSize: labelTextFontSize == null
                        ? 14 + Constants.textChange
                        : labelTextFontSize + Constants.textChange,
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
        borderRadius:
            BorderRadius.only(bottomRight: Radius.circular(thickness)),
        child: Container(
          height: height / 2,
          width: height / 2,
          decoration: BoxDecoration(
            border: Border(
              bottom:
                  BorderSide(width: thickness, color: Constants.purpleColor),
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
  ]);
}