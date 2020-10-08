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
        //x`border: Border.all(width: 2, color: Constants.backgroundBlack),
        color: Constants.backgroundBlack,
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 0,
              bottom: 0,
              left: 10,
              right: 5,
            ),
            //child: CircleAvatar(
            //border around the avatar
            //backgroundColor: Constants.purpleColor,
            child: Image.asset("lib/assets/images/logo6White.png"),
            //radius: 25,
            //),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 15,
            ),
            child: SizedBox(
              width: MediaQuery.of(context).size.width / 5 * 3,
              height: MediaQuery.of(context).size.height / 20 * 1,
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  labelText: "Search Klip",
                  labelStyle: TextStyle(color: Constants.backgroundWhite),
                  hintText: "Search",
                  hintStyle: TextStyle(color: Constants.backgroundWhite),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Constants.backgroundWhite,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(15.0),
                    ),
                    borderSide: BorderSide(
                      color: Constants.purpleColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
          //search bar
          /*SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SearchBar<Post>(
              searchBarStyle: SearchBarStyle(
                backgroundColor: Colors.lightBlue,
                padding: EdgeInsets.all(10),
                borderRadius: BorderRadius.circular(10),
              ),
              onSearch: null,
              onItemFound: null,
            ),
          ),
        ),*/
        ],
      ),
    );
  }
}
