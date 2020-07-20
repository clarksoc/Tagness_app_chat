import 'dart:ui';

import 'package:random_string/random_string.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tagnessappchat/screens/qr_screen.dart';
import 'package:tagnessappchat/widgets/qr_form.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:qr_flutter/qr_flutter.dart';

class GenerateScreen extends StatefulWidget {
  final String currentUserId;

  GenerateScreen({Key key, @required this.currentUserId}) : super(key: key);

  @override
  _GenerateScreenState createState() =>
      _GenerateScreenState(currentUserId: currentUserId);
}

class _GenerateScreenState extends State<GenerateScreen> {
  bool isLoading = false;

  String currentUserId;

  _GenerateScreenState({Key key, @required this.currentUserId});

  static const double _topSectionTopPadding = 50.0;
  static const double _topSectionBottomPadding = 20.0;
  static const double _topSectionHeight = 50.0;
  SharedPreferences sharedPreferences;

  var uuid = Uuid();

  var _dataString = "";

  Map <String, String> _dataQr = {
    "type": "",
    "holderName": "",
    "contactName": "",
    "username": "",
    "url": "",
    "email": "",
    "phoneNumber": "",
  };

  String displayName;
  String username;
  bool showQr = false;

  @override
  void initState() {
    super.initState();
    readLocal();
  }

  void readLocal() async {
    sharedPreferences = await SharedPreferences.getInstance();

    username = sharedPreferences.getString("username") ?? "";

    _dataString = "tgns.to/$username/$currentUserId";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "QR Code Generator",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).accentColor,
        centerTitle: true,
      ),
      body: QrForm(_contentWidget, _dataString),
    );
  }

  _contentWidget(
    BuildContext ctx,
    String type,
    String holderName,
    String contactName,
    String phoneNumber,
    String email,
    bool _showQr,
  ) {
    _dataQr = {
      "type": type,
      "holderName": holderName,
      "contactName": contactName,
      "username": username,
      "url": _dataString,
      "phoneNumber": phoneNumber,
      "email": email,
    };
    showQr = _showQr;
    _dataString = _dataString + randomAlphaNumeric(10).toString();
    print(_dataQr.toString());
    print(showQr);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QrScreen(_dataString, _dataQr),
      ),
    );
/*    final bodyHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).viewInsets.bottom;
    return Expanded(
            child: *//*showQr == false
                ? Center()
                :*//* Center(
                    child: RepaintBoundary(
                      child: QrImage(
                        data: _dataString,
                        size: 0.5 * bodyHeight,
                      ),
                    ),
                  ),
    );*/
  }
}
