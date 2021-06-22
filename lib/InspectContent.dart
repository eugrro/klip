import 'package:flutter/material.dart';
import 'package:klip/currentUser.dart' as currentUser;
import './Constants.dart' as Constants;
import 'package:klip/widgets.dart';
import 'package:photo_view/photo_view.dart';

// ignore: must_be_immutable
class InspectContent extends StatefulWidget {
  dynamic content;
  InspectContent(this.content);
  @override
  _InspectContentState createState() => _InspectContentState(content);
}

class _InspectContentState extends State<InspectContent> {
  dynamic content;
  _InspectContentState(this.content);
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
    return Scaffold(
      body: Stack(
        children: [
          PhotoView.customChild(
            child: content,
            childSize: const Size(220.0, 250.0),
            backgroundDecoration: BoxDecoration(color: Colors.black),
            customSize: MediaQuery.of(context).size,
            enableRotation: true,
            minScale: PhotoViewComputedScale.contained * 0.8,
            maxScale: PhotoViewComputedScale.covered * 1.8,
            initialScale: PhotoViewComputedScale.contained,
            basePosition: Alignment.center,
          ),
        ],
      ),
    );
  }
}
