import 'package:flutter/material.dart';
import 'package:klip/currentUser.dart' as currentUser;
import './Constants.dart' as Constants;
import 'package:klip/widgets.dart';

class AddTagWidget extends StatefulWidget {
  ValueNotifier<List<String>> tags;
  AddTagWidget(this.tags);
  @override
  _AddTagWidgetState createState() => _AddTagWidgetState(tags);
}

class _AddTagWidgetState extends State<AddTagWidget> {
  ValueNotifier<List<String>> tags;
  _AddTagWidgetState(this.tags);
  TextEditingController tagController = TextEditingController();
  List<Color> tagColors = [Colors.green, Colors.purple.shade300, Colors.red.shade300, Colors.blue, Colors.blueGrey];

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
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: 55,
          color: Colors.black26,
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 6, right: 8),
                child: Icon(Icons.search, color: Constants.backgroundWhite),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 0),
                  child: TextFormField(
                    scrollPhysics: NeverScrollableScrollPhysics(),
                    scrollPadding: EdgeInsets.zero,
                    controller: tagController,
                    decoration: InputDecoration(border: InputBorder.none, hintText: "Search or Add a Tag", hintStyle: TextStyle(fontSize: 14)),
                    onFieldSubmitted: (val) {
                      setState(() {
                        tags.value.add(val.trim());
                      });
                      tagController.text = "";
                      tags.notifyListeners();
                    },
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    tags.value.add(tagController.text.trim());
                  });
                  tagController.text = "";
                },
                child: Padding(
                  padding: EdgeInsets.only(left: 4, right: 6),
                  child: Icon(Icons.check, color: Constants.backgroundWhite),
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 4,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Wrap(
            direction: Axis.horizontal,
            children: List.generate(
              tags.value.length,
              (index) => GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  setState(() {
                    tags.value.removeAt(index);
                  });
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Card(
                      margin: EdgeInsets.only(left: 8, right: 4, top: 8, bottom: 0),
                      color: tagColors[index % 5],
                      elevation: 6.0,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                        child: Container(
                          child: Text(
                            tags.value[index],
                            style: TextStyle(color: Colors.white, fontSize: 14 + Constants.textChange),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
