import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tagnessappchat/models/find_user.dart';
import 'package:tagnessappchat/screens/scan_screen.dart';
import 'package:tagnessappchat/widgets/open_dialog_delete.dart';

class UserFoundScreen extends StatefulWidget {
  UserFoundScreen(
      this.documentSnapshotUser, this.documentSnapshotQr, this.isUser);

  final DocumentSnapshot documentSnapshotUser;
  final DocumentSnapshot documentSnapshotQr;
  final bool isUser;

  @override
  _UserFoundScreenState createState() => _UserFoundScreenState(
      userData: documentSnapshotUser, qrData: documentSnapshotQr);
}

class _UserFoundScreenState extends State<UserFoundScreen> {
  _UserFoundScreenState({@required this.userData, @required this.qrData});

  SharedPreferences sharedPreferences;

  DocumentSnapshot userData;
  DocumentSnapshot qrData;

  String userId = "";
  String userDisplayName = "";
  String userPhotoUrl = "";

  @override
  void initState() {
    super.initState();
    //FocusScope.of(context).unfocus();
    readLocal();
  }

  readLocal() async {
    sharedPreferences = await SharedPreferences.getInstance();
    userId = sharedPreferences.getString("id") ?? "";
    userDisplayName = sharedPreferences.getString("displayName") ?? "";
    userPhotoUrl = sharedPreferences.getString("photoUrl") ?? "";
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
                    widget.isUser == false
                        ? Container(
                            child: FlatButton(
                              onPressed: () => findUser(
                                  context,
                                  qrData["url"],
                                  qrData["holderName"],
                                  userId,
                                  userDisplayName,
                                  userPhotoUrl),
                              child: Text(
                                "START CHATTING",
                                style: TextStyle(fontSize: 16.0),
                              ),
                              color: Theme.of(context).primaryColor,
                              splashColor: Colors.transparent,
                              textColor: Colors.black,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30.0, vertical: 10.0),
                            ),
                          )
                        : Container(
                            child: Row(
                              children: <Widget>[
                                RaisedButton(
                                  child: Text("MODIFY"),
                                ),
                                RaisedButton(
                                  child: Text("DELETE"),
                                  onPressed: () {
                                    onDeletePress();
                                  },
                                ),
                              ],
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

  Future<bool> onDeletePress(){
    openDialogDelete(context, userId, qrData["url"]);
    return Future.value(false);
  }

/*  Future deleteQrCode(context) async {
      var doc = Firestore.instance
          .collection("users")
          .document(userId)
          .collection("QrCodes")
          .where("url", isEqualTo: qrData["url"]);
      return doc
          .getDocuments()
          .then((value) => value.documents.first.reference.delete());

  }*/
}
