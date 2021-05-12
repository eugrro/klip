import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:klip/widgets.dart';
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
    //TextEditingController searchController = new TextEditingController();
    return Container(
      decoration: BoxDecoration(
        color: Constants.purpleColor.withOpacity(.3),
        boxShadow: kElevationToShadow[2],
      ),
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: EdgeInsets.only(
          top: Constants.statusBarHeight,
          left: 15,
          right: 15,
          bottom: 10,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            klipLogo(200, MediaQuery.of(context).size.width * .75),
            Icon(
              Icons.search,
              color: Constants.backgroundWhite,
              size: 25,
            ),
          ],
        ),
      ),
    );
  }
}
