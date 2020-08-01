import 'package:flutter/material.dart';

class TopNavBar extends StatefulWidget {
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
  double _height = 30.0;
  bool _homeOn = true;
  bool _gameOn = false;
  bool _topOn = false;
  bool _newOn = false;

  double _width = 30.0;
  Color _color = Colors.indigo[700];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(" "),
            Text(" "),
            GestureDetector(
              child: AnimatedDefaultTextStyle(
                style: _homeOn
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
                  _homeOn = true;
                  _gameOn = false;
                  _topOn = false;
                  _newOn = false;
                });
              },
            ),
            VerticalDivider(),
            GestureDetector(
              child: AnimatedDefaultTextStyle(
                style: _gameOn
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
                  _homeOn = false;
                  _gameOn = true;
                  _topOn = false;
                  _newOn = false;
                });
              },
            ),
            VerticalDivider(),
            GestureDetector(
              child: AnimatedDefaultTextStyle(
                style: _topOn
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
                  _homeOn = false;
                  _gameOn = false;
                  _topOn = true;
                  _newOn = false;
                });
              },
            ),
            VerticalDivider(),
            GestureDetector(
              child: AnimatedDefaultTextStyle(
                style: _newOn
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
                  _homeOn = false;
                  _gameOn = false;
                  _topOn = false;
                  _newOn = true;
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
