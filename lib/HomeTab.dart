import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import './Constants.dart' as Constants;

//import 'Vid.dart';

class HomeTab extends StatefulWidget {
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchVideoUrl(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Column(
          children: <Widget>[
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border:
                      Border.all(width: 0, color: Constants.backgroundBlack),
                  color: Constants.backgroundBlack,
                ),
                child: snapshot.data == null
                    ? CircularProgressIndicator()
                    : Text(
                        snapshot.data,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                /*child: Column(
          children: [
            Container(
              color: Colors.black,
              height: MediaQuery.of(context).size.height / 8,
            ),
            Vid(),
          ],
        ),*/
              ),
            ),
          ],
        );
      },
    );
  }

  Future<String> fetchVideoUrl() async {
    var url = Constants.nodeURL;
    var response;
    try {
      response = await http.get(url);
      if (response.statusCode == 200) {
        print("Returned 200");
        print(response.body);
        if(response.body is String)
        return "Hello";
      } else {
        print("Returned error " + response.statusCode.toString());
        return "Error";
      }
    } catch (err) {
      print("Ran Into Error!" + err.toString());
    }
    return "";
  }
}
