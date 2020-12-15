import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './Constants.dart' as Constants;

class Post {
  final String title;
  final String description;

  Post(this.title, this.description);
}

class TopSection extends StatelessWidget {
  Future<List<Post>> search(String search) async {
    await Future.delayed(Duration(seconds: 2));
    return List.generate(5, (int index) {
      return Post('AA', 'BB');
    });
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController searchController = new TextEditingController();
    return Container(
      decoration: BoxDecoration(
        color: Constants.backgroundBlack,
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          top: 10,
          left: 15,
          right: 15,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Icon(
                  Icons.search,
                  color: Constants.backgroundWhite,
                  size: 30,
                ),
                Container(
                  height: 3,
                ),
                Text(
                  "Search",
                  style: TextStyle(
                    color: Constants.backgroundWhite,
                    fontSize: 12 + Constants.textChange,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Image.asset("lib/assets/images/logo6WhiteV2.png"),
                Padding(
                  padding: EdgeInsets.only(top: 5, bottom: 5),
                  child: Container(
                    width: MediaQuery.of(context).size.width / 3,
                    height: 2,
                    color: Constants.purpleColor,
                  ),
                )
              ],
            ),
            Text(
              "103 K",
              style: TextStyle(
                color: Constants.backgroundWhite,
                fontSize: 18 + Constants.textChange,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
