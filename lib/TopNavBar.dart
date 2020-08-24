import 'package:flutter/material.dart';

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
      width: 1.0,
      color: Colors.grey,
    );
  }
}

class _TopNavBarState extends State<TopNavBar> {
  Color _color = Colors.indigo[700];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 1.4, //lmao just to look nice
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(" "),
            Text(" "),
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
                        color: Colors.black,
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
                        color: Colors.black,
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
                        color: Colors.black,
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
                        color: Colors.black,
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
            Text(" "),
            Text(" "),
          ],
        ),
        Container(
          height: 15,
        )
      ],
    );
  }
}
