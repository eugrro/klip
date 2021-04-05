import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:helpers/helpers.dart';
import 'package:flutter/material.dart';
import 'package:klip/Requests.dart';
import 'package:klip/widgets.dart';
import 'package:video_editor/video_editor.dart';
import 'Constants.dart' as Constants;

class VideoEditor extends StatefulWidget {
  VideoEditor(this.input);

  dynamic input;

  @override
  _VideoEditorState createState() => _VideoEditorState(input);
}

class _VideoEditorState extends State<VideoEditor> {
  dynamic input;
  _VideoEditorState(this.input);
  final _exportingProgress = ValueNotifier<double>(0.0);
  final _isExporting = ValueNotifier<bool>(false);
  final double height = 60;

  bool _exported = false;
  String _exportText = "";
  VideoEditorController _controller;

  @override
  void initState() {
    if (input.runtimeType == String) {
      //downloadXboxAsFile(input);
      /*_controller = VideoEditorController.file(input)
        ..initialize().then((_) => setState(() {
              _controller.video.pause();
            }));*/
    } else if (widget.input.runtimeType == File) {
      _controller = VideoEditorController.file(input)
        ..initialize().then((_) => setState(() {
              _controller.video.pause();
            }));
    } else {
      //showSnackbar(context, 'Unknown Type: ' + widget.input.runtimeType.toString());
      print('Unknown Type: ' + widget.input.runtimeType.toString());
      Navigator.of(context).pop();
    }

    super.initState();
  }

  @override
  void dispose() async {
    super.dispose();
    if (_controller != null) await _controller.dispose();
  }

  void _exportVideo() async {
    //NOTE: To use [-crf 17] and [VideoExportPreset] you need ["min-gpl-lts"] package
    final File file = await _controller.exportVideo(
      customInstruction: "-crf 17",
      preset: VideoExportPreset.veryslow,
      progressCallback: (statics) {
        if (_controller.video != null) _exportingProgress.value = statics.time / _controller.video.value.duration.inMilliseconds;
      },
    );
    Navigator.of(context).pop(file);
  }

  void _openCropScreen() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => CropScreen(controller: _controller)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _controller.initialized
          ? AnimatedBuilder(
              animation: _controller,
              builder: (_, __) {
                return Stack(children: [
                  Column(children: [
                    _topNavBar(),
                    Expanded(
                      child: ClipRRect(
                        child: CropGridViewer(
                          controller: _controller,
                          showGrid: false,
                        ),
                      ),
                    ),
                    ..._trimSlider(),
                  ]),
                  Center(
                    child: OpacityTransition(
                      visible: !_controller.isPlaying,
                      child: GestureDetector(
                        onTap: _controller.video.play,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.play_arrow,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  _customSnackBar(),
                  ValueListenableBuilder(
                    valueListenable: _isExporting,
                    builder: (_, bool export, __) => OpacityTransition(
                      visible: export,
                      child: AlertDialog(
                        title: ValueListenableBuilder(
                          valueListenable: _exportingProgress,
                          builder: (_, double value, __) => TextDesigned(
                            "Exporting video ${(value * 100).ceil()}%",
                            color: Colors.black,
                            bold: true,
                          ),
                        ),
                      ),
                    ),
                  )
                ]);
              })
          : Center(child: CircularProgressIndicator()),
    );
  }

  Widget _topNavBar() {
    return SafeArea(
      child: Container(
        height: height,
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => _controller.rotate90Degrees(RotateDirection.left),
                child: Icon(Icons.rotate_left, color: Colors.white),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => _controller.rotate90Degrees(RotateDirection.right),
                child: Icon(Icons.rotate_right, color: Colors.white),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: _openCropScreen,
                child: Icon(Icons.crop, color: Colors.white),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: _exportVideo,
                child: Icon(Icons.save, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _trimSlider() {
    final duration = _controller.videoDuration.inSeconds;
    final pos = _controller.trimPosition * duration;
    final start = _controller.minTrim * duration;
    final end = _controller.maxTrim * duration;

    String formatter(Duration duration) =>
        duration.inMinutes.remainder(60).toString().padLeft(2, '0') + ":" + (duration.inSeconds.remainder(60)).toString().padLeft(2, '0');

    return [
      Padding(
        padding: Margin.horizontal(height / 4),
        child: Row(children: [
          TextDesigned(
            formatter(Duration(seconds: pos.toInt())),
            color: Colors.white,
          ),
          Expanded(child: SizedBox()),
          OpacityTransition(
            visible: _controller.isTrimming,
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              TextDesigned(
                formatter(Duration(seconds: start.toInt())),
                color: Colors.white,
              ),
              SizedBox(width: 10),
              TextDesigned(
                formatter(Duration(seconds: end.toInt())),
                color: Colors.white,
              ),
            ]),
          )
        ]),
      ),
      Container(
        height: height,
        margin: Margin.all(height / 4),
        child: TrimSlider(
          controller: _controller,
          height: height,
        ),
      )
    ];
  }

  Widget _customSnackBar() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SwipeTransition(
        visible: _exported,
        direction: SwipeDirection.fromBottom,
        child: Container(
          height: height,
          width: double.infinity,
          color: Colors.black.withOpacity(0.8),
          child: Center(
            child: TextDesigned(
              _exportText,
              color: Colors.white,
              bold: true,
            ),
          ),
        ),
      ),
    );
  }
}

//-----------------//
//CROP VIDEO SCREEN//
//-----------------//
class CropScreen extends StatefulWidget {
  CropScreen({
    Key key,
    @required this.controller,
  }) : super(key: key);

  final VideoEditorController controller;

  @override
  _CropScreenState createState() => _CropScreenState();
}

class _CropScreenState extends State<CropScreen> {
  Offset _minCrop;
  Offset _maxCrop;

  @override
  void initState() {
    _minCrop = widget.controller.minCrop;
    _maxCrop = widget.controller.maxCrop;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: Margin.all(30),
          child: Column(children: [
            Expanded(
              child: CropGridViewer(
                controller: widget.controller,
                onChangeCrop: (min, max) => setState(() {
                  _minCrop = min;
                  _maxCrop = max;
                }),
              ),
            ),
            SizedBox(height: 15),
            Row(children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Center(
                    child: TextDesigned("Cancel", color: Colors.white, bold: true),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    widget.controller.updateCrop(_minCrop, _maxCrop);
                    Navigator.of(context).pop();
                  },
                  child: Center(
                    child: TextDesigned("OK", color: Colors.white, bold: true),
                  ),
                ),
              ),
            ]),
          ]),
        ),
      ),
    );
  }
}
