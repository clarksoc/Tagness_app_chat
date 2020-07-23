import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserFoundScreen extends StatefulWidget {
  UserFoundScreen(this.documentSnapshotUser, this.documentSnapshotQr);

  final DocumentSnapshot documentSnapshotUser;
  final DocumentSnapshot documentSnapshotQr;

  @override
  _UserFoundScreenState createState() => _UserFoundScreenState(
      userData: documentSnapshotUser, qrData: documentSnapshotQr);
}

class _UserFoundScreenState extends State<UserFoundScreen> {
  _UserFoundScreenState({@required this.userData, @required this.qrData});

  DocumentSnapshot userData;
  DocumentSnapshot qrData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "QR code for ${qrData["holderName"]}",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).accentColor,
        centerTitle: true,
      ),
      body: Center(
        child: Card(
          child: Text("Type: ${qrData["type"]} \n"
              "Contact Name: ${qrData["contactName"]} \n"
              "Holder Name: ${qrData["holderName"]} \n"
              "Contact Email: ${qrData["email"]} \n"
              "Contact Phone Number: ${qrData["phoneNumber"]} \n"
              "Description: ${qrData["details"]} \n"
              "Url: ${qrData["url"]} \n"),
        ),
      ),
    );
  }
}
