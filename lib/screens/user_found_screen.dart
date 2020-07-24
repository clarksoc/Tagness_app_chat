import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tagnessappchat/models/find_user.dart';
import 'package:tagnessappchat/screens/scan_screen.dart';

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
  void initState() {
    super.initState();
    //FocusScope.of(context).unfocus();
  }

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
      body: WillPopScope(
        child: SingleChildScrollView(
          child: Center(
            child: Card(
              margin: EdgeInsets.only(top: 25),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "QR Code Holder's Name: ",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 15),
                          ),
                          Text(
                            "${qrData["holderName"]}",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ],
                      ),
                      margin:
                          EdgeInsets.only(left: 10.0, bottom: 10, top: 10.0),
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Emergency Contact's Name: ",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 15),
                          ),
                          Text(
                            "${qrData["contactName"]}",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ],
                      ),
                      margin:
                          EdgeInsets.only(left: 10.0, bottom: 10, top: 10.0),
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Emergency Contact's Email: ",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 15),
                          ),
                          Text(
                            "${qrData["email"]}",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ],
                      ),
                      margin:
                          EdgeInsets.only(left: 10.0, bottom: 10, top: 10.0),
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Emergency Contact's Phone Number: ",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 15),
                          ),
                          Text(
                              "${qrData["phoneNumber"]}",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                        ],
                      ),
                      margin:
                          EdgeInsets.only(left: 10.0, bottom: 10, top: 10.0),
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                              "URL For Contact's Profile: ",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor),
                            ),
                          Padding(
                            padding: EdgeInsets.only(top: 15),
                          ),
                            Text(
                              "${qrData["url"]}",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                        ],
                      ),
                      margin:
                          EdgeInsets.only(left: 10.0, bottom: 10, top: 10.0),
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Description of Holder: ",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 15),
                          ),
                          Text(
                            "${qrData["details"]}",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                            maxLines: null,
                          ),
                        ],
                      ),
                      margin:
                          EdgeInsets.only(left: 10.0, bottom: 10, top: 10.0),
                    ),
                    Container(
                      child: FlatButton(
                        onPressed: () => findUser(context, qrData["url"], qrData["holderName"]),
                        child: Text(
                          "SEARCH",
                          style: TextStyle(fontSize: 16.0),
                        ),
                        color: Theme
                            .of(context)
                            .primaryColor,
                        splashColor: Colors.transparent,
                        textColor: Colors.black,
                        padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                      ),
                    )
                  ],
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
              ),
            ),
          ),
        ),
        onWillPop: onBackPress,
      ),
    );
  }

  Future<bool> onBackPress() {
    Navigator.of(context).pop();
    return Future.value(false);
  }
}
