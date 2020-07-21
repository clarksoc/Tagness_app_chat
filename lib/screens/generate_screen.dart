import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:random_string/random_string.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tagnessappchat/screens/qr_overview_screen.dart';
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

  Map<String, String> _dataQr = {
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
  String qrCodeId;
  bool showQr = false;
  int counter = 0;

  @override
  void initState() {
    super.initState();
    readLocal();
    doesExist();
  }

  void readLocal() async {
    sharedPreferences = await SharedPreferences.getInstance();

    username = sharedPreferences.getString("username") ?? "";

    _dataString = "www.tgns.to/$username/";
    setState(() {});
  }

  void doesExist() async {
    DocumentSnapshot documentSnapshot = await Firestore.instance
        .collection("users")
        .document(currentUserId)
        .collection("QrCodes")
        .document("AmountOfCodes")
        .get();
    if (!documentSnapshot.exists) {
      Firestore.instance
          .collection("users")
          .document(currentUserId)
          .collection("QrCodes")
          .document("AmountOfCodes")
          .setData({"qrCount": 0});
    }
  }

  @override
  Widget build(BuildContext context) {
    counter++;
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
    String username,
    String type,
    String holderName,
    String contactName,
    String phoneNumber,
    String email,
    String url,
    String details,
    bool _showQr,
  ) async {
    var qrCodesRef = Firestore.instance
        .collection("users")
        .document(currentUserId)
        .collection("QrCodes")
        .document("AmountOfCodes");
    var batch = Firestore.instance.batch();
    batch.updateData(
      qrCodesRef,
      {"qrCount": FieldValue.increment(1)},
    );
    batch.commit();
    _dataQr = {
      "type": type,
      "holderName": holderName,
      "contactName": contactName,
      "username": username,
      "url": "$_dataString${await qrCodesRef.get().then((value) => value.data["qrCount"])}",
      "phoneNumber": phoneNumber,
      "email": email,
      "details": details,
    };
    showQr = _showQr;
    print(_dataQr.toString());
    print(showQr);
    Firestore.instance
        .collection("users")
        .document(currentUserId)
        .collection("QrCodes")
        .document("QRCode_${randomAlphaNumeric(10)}")
        .setData({
      "type": type,
      "holderNAme": holderName,
      "contactName": contactName,
      "username": username,
      "url":
          "$_dataString${await qrCodesRef.get().then((value) => value.data["qrCount"])}",
      "phoneNumber": phoneNumber,
      "email": email,
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QrScreen(_dataString, _dataQr),
      ),
    );
  }
}
