import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flappy_search_bar/search_bar_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
    return Row(
      children: [
        //margin to the left of user pic
        Container(
          width: 10,
        ),
        //user's avatar
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 0),
          child: CircleAvatar(
            radius: 28,
            backgroundColor: Colors.black,
            child: CircleAvatar(
              //border around the avatar
              backgroundColor: Colors.grey,
              child: Text(
                'ER',
                style: TextStyle(color: Colors.white),
              ),
              radius: 25,
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SizedBox(
              width: MediaQuery.of(context).size.width / 4 * 3,
              height: MediaQuery.of(context).size.height / 8 * 1,
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                    labelText: "Search",
                    hintText: "Search",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)))),
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
    );
  }
}
