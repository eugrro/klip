import 'package:flutter/material.dart';

import 'Vid.dart';

class HomeTab extends StatefulWidget {
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Column(
        children: [
          Container(
            color: Colors.black,
            height: MediaQuery.of(context).size.height / 8,
            child: Center(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                // Let the ListView know how many items it needs to build.
                itemCount: 25,
                // Provide a builder function. This is where the magic happens.
                // Convert each item into a widget based on the type of item it is.
                itemBuilder: (context, index) {
                  //final item = items[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 7),
                    child: CircleAvatar(
                      backgroundColor: Colors.blue,
                      radius: MediaQuery.of(context).size.height / 25,
                      child: Text("E" + index.toString()),
                    ),
                  );
                },
              ),
            ),
          ),
          Vid(),
        ],
      ),
    );
  }
}
