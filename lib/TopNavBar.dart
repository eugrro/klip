import 'package:flutter/material.dart';
import './Constants.dart' as Constants;

ValueNotifier pageValueNotifier = ValueNotifier(0);

class TopNavBar extends StatefulWidget {
  int pagePosition;
  TopNavBar(this.pagePosition, this.callback);
  Function(int) callback; //callback to change the pagview
  @override
  _TopNavBarState createState() => _TopNavBarState();
}

class VerticalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      height: 30.0,
      width: 1.5,
      color: Constants.purpleColor,
    );
  }
}

class _TopNavBarState extends State<TopNavBar> {
  Color _color = Constants.purpleColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        //border: Border.all(width: 1, color: Constants.backgroundBlack),
        color: Constants.backgroundBlack,
      ),
      child: Padding(
        padding: EdgeInsets.only(
          bottom: 15,
          top: 9,
          left: MediaQuery.of(context).size.width / 6,
          right: MediaQuery.of(context).size.width / 6,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              child: AnimatedDefaultTextStyle(
                style: widget.pagePosition == 0
                    ? TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25.0,
                        color: _color,
                      )
                    : TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 15.0,
                        color: Constants.backgroundWhite,
                      ),
                duration: const Duration(milliseconds: 200),
                child: Text("Home"),
              ),
              onTap: () {
                setState(() {
                  widget.pagePosition = 0;
                  widget.callback(0);
                });
              },
            ),
            VerticalDivider(),
            GestureDetector(
              child: AnimatedDefaultTextStyle(
                style: widget.pagePosition == 1
                    ? TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25.0,
                        color: _color,
                      )
                    : TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 15.0,
                        color: Constants.backgroundWhite,
                      ),
                duration: const Duration(milliseconds: 200),
                child: Text("Games"),
              ),
              onTap: () {
                setState(() {
                  widget.pagePosition = 1;
                  widget.callback(1);
                });
              },
            ),
            VerticalDivider(),
            GestureDetector(
              child: AnimatedDefaultTextStyle(
                style: widget.pagePosition == 2
                    ? TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25.0,
                        color: _color,
                      )
                    : TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 15.0,
                        color: Constants.backgroundWhite,
                      ),
                duration: const Duration(milliseconds: 200),
                child: Text("Top"),
              ),
              onTap: () {
                setState(() {
                  widget.pagePosition = 2;
                  widget.callback(2);
                });
              },
            ),
            VerticalDivider(),
            GestureDetector(
              child: AnimatedDefaultTextStyle(
                style: widget.pagePosition == 3
                    ? TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25.0,
                        color: _color,
                      )
                    : TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 15.0,
                        color: Constants.backgroundWhite,
                      ),
                duration: const Duration(milliseconds: 200),
                child: Text("New"),
              ),
              onTap: () {
                setState(() {
                  widget.pagePosition = 3;
                  widget.callback(3);
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
