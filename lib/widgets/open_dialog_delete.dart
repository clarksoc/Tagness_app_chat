import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

Future<Null> openDialogDelete(BuildContext context, String userId, String url) async {
  switch (await showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          children: <Widget>[
            Container(
              color: Colors.red,
              padding: EdgeInsets.symmetric(vertical: 10),
              height: 100.0,
              child: Column(
                children: <Widget>[
                  Container(
                      child: Icon(
                        Icons.exit_to_app,
                        size: 30,
                        color: Colors.white,
                      ),
                      margin: EdgeInsets.only(top: 10)),
                  Text(
                    "Delete QR Code",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Are you sure you want to delete this QR code?",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14.0,
                    ),
                  ),
                ],
              ),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, 0);
              },
              child: Row(
                children: <Widget>[
                  Container(
                    child: Icon(
                      Icons.cancel,
                      color: Theme.of(context).primaryColor,
                    ),
                    margin: EdgeInsets.only(right: 10),
                  ),
                  Text(
                    "Cancel",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, 1);
              },
              child: Row(
                children: <Widget>[
                  Container(
                    child: Icon(
                      Icons.delete_forever,
                      color: Theme.of(context).primaryColor,
                    ),
                    margin: EdgeInsets.only(right: 10),
                  ),
                  Text(
                    "Delete",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        );
      })) {
    case 0:
      break;

    case 1:
      deleteQrCode(context, userId, url);
      Fluttertoast.showToast(msg: "Successfully deleted the QR code",
      backgroundColor: Colors.grey[300],
        textColor: Colors.black
      );
      Navigator.of(context).pop();
      break;
  }

}
Future deleteQrCode(context, String userId, String url) async {
  var doc = Firestore.instance
      .collection("users")
      .document(userId)
      .collection("QrCodes")
      .where("url", isEqualTo: url);
  return doc
      .getDocuments()
      .then((value) => value.documents.first.reference.delete());


}
