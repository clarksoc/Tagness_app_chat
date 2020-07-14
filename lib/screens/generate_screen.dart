import 'dart:typed_data';
import 'dart:ui';
import 'dart:io';

import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class GenerateScreen extends StatefulWidget {
  final String currentUserId;

  GenerateScreen({Key key, @required this.currentUserId}) : super(key: key);

  @override
  _GenerateScreenState createState() => _GenerateScreenState(currentUserId: currentUserId);
}

class _GenerateScreenState extends State<GenerateScreen> {
  String currentUserId;

  _GenerateScreenState({Key key, @required this.currentUserId});

  static const double _topSectionTopPadding = 50.0;
  static const double _topSectionBottomPadding = 20.0;
  static const double _topSectionHeight = 50.0;

  var uuid = Uuid();

  GlobalKey globalKey = new GlobalKey();
  String _dataString = "Hello from this QR";
  String _inputErrorText;
  bool showQr = false;
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("QR Code Generator"),
      ),
      body: _contentWidget(),
    );
  }

  Future<void> _captureAndSharePng() async {
    try {
      RenderRepaintBoundary boundary =
          globalKey.currentContext.findRenderObject();
      var image = await boundary.toImage();
      ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
      /*Uint8List pngBytes = byteData.buffer.asUint8List();

      final tempDir = await getTemporaryDirectory();
      final file = await File("${tempDir.path}/image.png").create();

      final channel = const MethodChannel("channel:me.con.share/share");
      channel.invokeMethod("shareFile", "image.png");*/
    } catch (e) {
      print(e.toString());
    }
  }

  _contentWidget() {
    final bodyHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).viewInsets.bottom;
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
              top: _topSectionTopPadding,
              left: 20.0,
              right: 10.0,
              bottom: _topSectionBottomPadding,
            ),
            child: Container(
              height: _topSectionHeight,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    child: Center(child: Text("Generate your unique ID!", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),))
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: FlatButton(
                      color: Colors.blueGrey,
                      textColor: Colors.white,
                      child: Text("SUBMIT", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                      onPressed: () {
                        setState(() {
                          _dataString = currentUserId;
                          showQr = true;
                          _inputErrorText = null;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: showQr == false ? Center() :  Center(
              child: RepaintBoundary(
                key: globalKey,
                child: QrImage(
                  data: _dataString,
                  size: 0.5 * bodyHeight,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}