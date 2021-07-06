import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:klip/widgets.dart';
import './Constants.dart' as Constants;
import 'Requests.dart';

class ContentListItem extends StatefulWidget {
  dynamic obj;
  bool isHomeUserPage;
  ContentListItem(this.obj, this.isHomeUserPage);
  @override
  _ContentListItemState createState() => _ContentListItemState(obj, isHomeUserPage);
}

class _ContentListItemState extends State<ContentListItem> {
  dynamic obj;
  bool isHomeUserPage;
  _ContentListItemState(this.obj, this.isHomeUserPage);

  bool currentlyHolding = false;
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
    if (obj == null) return Container();
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width / 30,
        vertical: 6,
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: currentlyHolding ? Constants.purpleColor : Colors.transparent,
            width: currentlyHolding ? 1.5 : 0,
          ),
        ),
        child: GestureDetector(
          onLongPress: () {
            if (!isHomeUserPage) {
              setState(() {
                currentlyHolding = true;
              });
              contentPopUp(context, obj["pid"], obj["thumb"] ?? "").then((val) {
                setState(() {
                  currentlyHolding = false;
                });
              });
            }
          },
          child: InkWell(
            onTap: () {
              showSnackbar(context, "In development");
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    right: 10,
                  ),
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: obj["type"] == "txt"
                        ? Container(
                            height: 120,
                            width: 220,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(obj["title"]),
                                Container(
                                  height: 10,
                                ),
                                Text(obj["body"]),
                                Container(
                                  height: 10,
                                )
                              ],
                            ),
                          )
                        : obj["type"] == "poll"
                            ? Container(
                                height: 120,
                                width: 220,
                                color: Colors.black.withOpacity(.5),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      obj["title"],
                                      style: TextStyle(
                                        fontSize: 16 + Constants.textChange,
                                      ),
                                    ),
                                    Container(
                                      height: 10,
                                    ),
                                    Text(
                                      "Click to expand",
                                      style: TextStyle(
                                        fontSize: 12 + Constants.textChange,
                                      ),
                                    ),
                                    Container(
                                      height: 10,
                                    )
                                  ],
                                ),
                              )
                            : Image.network(
                                obj["type"] == "vid" ? obj["thumb"] : obj["link"],
                                height: 120,
                                width: 220,
                                fit: BoxFit.cover,
                              ),
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
                          obj["title"] ?? "",
                          style: TextStyle(
                            fontSize: 13,
                            color: Constants.backgroundWhite,
                          ),
                          maxLines: 3,
                        ),
                      ),
                    ),
                    Text(
                      (obj["numViews"].toString() ?? "0") + " views",
                      style: TextStyle(
                        fontSize: 13,
                        color: Constants.backgroundWhite,
                      ),
                    ),
                    Text(
                      (obj["comm"].length.toString() ?? "0") + " comments",
                      style: TextStyle(
                        fontSize: 13,
                        color: Constants.backgroundWhite,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> contentPopUp(BuildContext ctx, String pid, String thumb) {
    return showDialog<bool>(
      context: ctx,
      builder: (BuildContext context) {
        return Center(
          child: Container(
            width: MediaQuery.of(context).size.width * .8,
            height: MediaQuery.of(context).size.height * .3,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Constants.backgroundBlack,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 20, bottom: 5),
                    child: Text(
                      "Content Options",
                      style: TextStyle(
                        color: Constants.backgroundWhite,
                        fontSize: 18 + Constants.textChange,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 15, left: 10, right: 10),
                    child: Column(
                      children: [
                        Container(
                          height: .5,
                          color: Constants.hintColor.withOpacity(.5),
                        ),
                        GestureDetector(
                          onTap: () {
                            deleteContent(pid, thumb);
                            Navigator.of(context).pop();
                          },
                          child: Padding(
                            padding: EdgeInsets.only(top: 12, bottom: 12),
                            child: Text(
                              "Delete Content",
                              style: TextStyle(color: Colors.red[400]),
                            ),
                          ),
                        ),
                        Container(
                          height: .5,
                          color: Constants.hintColor.withOpacity(.5),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
