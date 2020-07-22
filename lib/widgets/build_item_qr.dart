import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tagnessappchat/screens/qr_screen.dart';

Widget buildItemQr(
    BuildContext context, DocumentSnapshot documentSnapshot, qrId) {
  var dataQr = {
    "type": documentSnapshot["type"].toString(),
    "holderName": documentSnapshot["holderName"].toString(),
    "contactName": documentSnapshot["contactName"].toString(),
    "username": documentSnapshot["username"].toString(),
    "url": documentSnapshot["url"].toString(),
    "phoneNumber": documentSnapshot["phoneNumber"].toString(),
    "email": documentSnapshot["email"].toString(),
    "details": documentSnapshot["details"].toString(),
  };

  return documentSnapshot["type"].toString() == "null" ? Container() : Container(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: FlatButton(
        child: Row(
          children: <Widget>[
            Flexible(
              child: Container(
                child: Text(
                  "QR Code for: ${documentSnapshot["holderName"]}",
                  style: TextStyle(color: Colors.black),
                ),
                alignment: Alignment.center,
                margin: EdgeInsets.only(left: 10, right: 5.0),
              ),
            ),
          ],
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QrScreen(dataQr),
            ),
          );
        },
        color: Theme.of(context).primaryColor,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
  );
}
