import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:klip/ContentVideoWidget.dart';
import 'package:klip/Requests.dart';
import 'package:klip/currentUser.dart' as currentUser;
import './Constants.dart' as Constants;
import 'package:klip/widgets.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'InspectContent.dart';

// ignore: must_be_immutable
class ShowContentPreview extends StatefulWidget {
  dynamic content;
  String typeOfContent;
  ShowContentPreview(this.content, this.typeOfContent);
  @override
  _ShowContentPreviewState createState() => _ShowContentPreviewState(content, typeOfContent);
}

class _ShowContentPreviewState extends State<ShowContentPreview> {
  dynamic content;
  String typeOfContent;
  _ShowContentPreviewState(this.content, this.typeOfContent);

  TextEditingController titleController = TextEditingController();
  String title = "";
  int titleMaxLength = 60;
  bool isUploadingContent = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 15, right: 15, top: MediaQuery.of(context).padding.top + 15, bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Icon(
                        Icons.arrow_back,
                        color: Constants.backgroundWhite,
                        size: 20,
                      ),
                    ),
                    Text(
                      "Preview",
                      style: TextStyle(
                        color: Constants.backgroundWhite,
                        fontSize: 18 + Constants.textChange,
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        setState(() {
                          isUploadingContent = true;
                        });
                        if (typeOfContent == "img") {
                          uploadImage(content.path, currentUser.uid, titleController.text).then((value) {
                            if (value == null || value == "" || value == '') {
                              showError(context, "Unable to Upload Content");
                            } else {
                              Navigator.of(context).pop();
                              setState(() {});
                            }
                          });
                        } else if (typeOfContent == "vid") {
                          print("Uploading Klip");
                          final videoThumbnail = await VideoThumbnail.thumbnailData(
                            video: content.path,
                            imageFormat: ImageFormat.JPEG,
                            maxWidth: 500, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
                            quality: 100,
                          );
                          uploadKlip(content.path, currentUser.uid, titleController.text, videoThumbnail).then((value) {
                            if (value == null || value == "" || value == '') {
                              showError(context, "Unable to Upload Content");
                            } else {
                              Navigator.of(context).pop();
                              setState(() {});
                            }
                          });
                        } else {
                          showError(context, "Unknown content upload: " + typeOfContent);
                          setState(() {
                            isUploadingContent = false;
                          });
                        }
                      },
                      child: isUploadingContent
                          ? CircularProgressIndicator.adaptive()
                          : Icon(
                              Icons.check,
                              color: Constants.backgroundWhite,
                              size: 20,
                            ),
                    ),
                  ],
                ),
              ),
              ConstrainedBox(
                constraints: new BoxConstraints(
                  minHeight: 5.0,
                  minWidth: 5.0,
                  maxHeight: MediaQuery.of(context).size.height / 2,
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => InspectContent(
                        typeOfContent == "vid" ? ContentVideoWidget({"link": "file", "file": content}) : Image.file(content) ?? Container(),
                      ),
                    ));
                  },
                  child: typeOfContent == "vid" ? ContentVideoWidget({"link": "file", "file": content}) : Image.file(content) ?? Container(),
                ),
              ),
              Container(
                height: 5,
              ),
              TextFormField(
                scrollPhysics: NeverScrollableScrollPhysics(),
                onChanged: (String value) {
                  if (value.length > titleMaxLength) {
                    value = value.substring(0, 60);
                    titleController.text = value;
                    //move cursor to end
                    titleController.selection = TextSelection.fromPosition(TextPosition(offset: titleController.text.length));
                  }
                  setState(() {
                    title = value;
                  });
                },
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                controller: titleController,
                maxLines: null,
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
                    hintText: "An Interesting Title",
                    hintStyle: TextStyle(fontSize: 14)),
              ),
              Container(
                width: double.infinity,
                color: Constants.hintColor,
                height: 1,
              ),
              Padding(
                padding: EdgeInsets.only(
                  right: 8,
                  bottom: 5,
                ),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    title.length.toString() + "/" + titleMaxLength.toString(),
                    style: TextStyle(
                      color: title.length >= 55
                          ? Colors.red
                          : title.length >= 40
                              ? Colors.yellow
                              : Constants.hintColor,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
