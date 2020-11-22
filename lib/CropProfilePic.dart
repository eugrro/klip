import 'dart:io';

import 'package:flutter/material.dart';
import 'package:simple_image_crop/simple_image_crop.dart';
import './Constants.dart' as Constants;

// ignore: must_be_immutable
class CropProfilePic extends StatefulWidget {
  File img;
  var imgKey;
  CropProfilePic(this.img, this.imgKey);

  @override
  _CropProfilePicState createState() => _CropProfilePicState(img, imgKey);
}

class _CropProfilePicState extends State<CropProfilePic> {
  File img;
  var imgKey;
  _CropProfilePicState(this.img, this.imgKey);
  @override
  void initState() {
    print("AAAAAAAAAAAAAAA");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Colors.black,
            child: ImgCrop(
              key: imgKey,
              chipRadius: 150, // crop area radius
              chipShape: ChipShape.circle, // crop type "circle" or "rect"
              image: FileImage(img), // you selected image file
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height - 80,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width * .25,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: kElevationToShadow[3],
                      color: Constants.purpleColor,
                    ),
                    child: Center(
                      child: Text(
                        "X",
                        style: TextStyle(
                          color: Constants.backgroundWhite,
                          fontSize: 30 + Constants.textChange,
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      Navigator.of(context).pop(true);
                    });
                  },
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width * .25,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: kElevationToShadow[3],
                      color: Constants.purpleColor,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 35,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
