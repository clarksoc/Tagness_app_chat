import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tagnessappchat/screens/user_found_screen.dart';
import 'package:tagnessappchat/widgets/chat.dart';

findUserUrl(BuildContext context, String _qrCodeUrl) async {
  List<DocumentSnapshot> documentList;
  List<DocumentSnapshot> qrList;
  String _userFoundId;
  String _qrUsernameId;
  print("URL: " + _qrCodeUrl);
  _qrCodeUrl = _qrCodeUrl.trim();
  _qrUsernameId = _qrCodeUrl.substring(_qrCodeUrl.indexOf("/") + 1);
  print("Username/Id: " + _qrUsernameId);
  String _foundUsername =
  _qrUsernameId.substring(0, _qrUsernameId.indexOf('/'));
  print("Username: " + _foundUsername);
  documentList = (await Firestore.instance
      .collection("users")
      .where("username", isEqualTo: _foundUsername)
      .getDocuments())
      .documents;
  if (documentList.isEmpty) {
    Fluttertoast.showToast(
      msg: "No user found with that username",
      backgroundColor: Colors.grey[200],
      textColor: Colors.black,
    );
    print("No user found");
    return null;
  } else {
    _userFoundId = documentList[0]["id"];

    qrList = (await Firestore.instance
        .collection("users")
        .document(_userFoundId)
        .collection("QrCodes")
        .where("url", isEqualTo: _qrCodeUrl)
        .getDocuments())
        .documents;

    if (qrList.isEmpty) {
      Fluttertoast.showToast(
        msg: "No QR code was found with that link",
        backgroundColor: Colors.grey[200],
        textColor: Colors.black,
      );
      print("No QR code was found for that user with that Id");
      return null;
    } else {
      Fluttertoast.showToast(
        msg: "QR Code Found",
        backgroundColor: Colors.grey[200],
        textColor: Colors.black,
      );
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserFoundScreen(documentList[0], qrList[0]),
          ));
    }
  }
  return null;
}

findUser(BuildContext context, String _qrCodeUrl, String _holderName,
    String userId, String userDisplayName, String userPhotoUrl) async {
  List<DocumentSnapshot> documentList;
  String _userFoundId;
  String _qrUsernameId;
  print("URL: " + _qrCodeUrl);
  _qrCodeUrl = _qrCodeUrl.trim();
  _qrUsernameId = _qrCodeUrl.substring(_qrCodeUrl.indexOf("/") + 1);
  print("Username/Id: " + _qrUsernameId);
  String _foundUsername =
  _qrUsernameId.substring(0, _qrUsernameId.indexOf('/'));
  print("Username: " + _foundUsername);
  documentList = (await Firestore.instance
      .collection("users")
      .where("username", isEqualTo: _foundUsername)
      .getDocuments())
      .documents;
  if (documentList.isEmpty) {
    Fluttertoast.showToast(
      msg: "No user found with that username",
      backgroundColor: Colors.grey[200],
      textColor: Colors.black,
    );
    print("No user found");
    return null;
  }else {
    _userFoundId = documentList[0]["id"];
/*    var doesHolderNameExist = await Firestore.instance
        .collection("users")
        .where("chatWithHolder", arrayContains: _holderName)
        .getDocuments();
    var doesUserExist = await Firestore.instance
        .collection("users")
        .where("hasChatWith", arrayContains: userId)
        .getDocuments();
    if(doesUserExist.documents.isEmpty != true){
      Firestore.instance.collection("users").document(_userFoundId).updateData({
        "hasChatWith": FieldValue.arrayUnion([userId]),
        //"chatWithHolderName": FieldValue.arrayUnion([_holderName]),
      });
      Firestore.instance.collection("users").document(userId).updateData({
        "hasChatWith": FieldValue.arrayUnion([_userFoundId]),
        //"chatWithHolderName": FieldValue.arrayUnion([_holderName]),
        //"hasChatWith" : _userFoundId: FieldValue.arrayUnion([_holderName]),
      });
    }else{

    }*/
    Firestore.instance
        .collection("users")
        .document(userId)
        .collection("hasChatWith")
        .document("$_userFoundId-$_holderName")
        .setData(
      {
        "chatName": documentList[0]["displayName"],
        "holderName": _holderName,
        "chatAvatar": documentList[0]["photoUrl"],
        "chatId" : _userFoundId,
      },
    );
    Firestore.instance
        .collection("users")
        .document(_userFoundId)
        .collection("hasChatWith")
        .document("$userId-$_holderName")
        .setData(
      {
        "chatName": userDisplayName,
        "holderName": _holderName,
        "chatAvatar": userPhotoUrl,
        "chatId" : userId,

      },
    );
    Firestore.instance.collection("users").document(_userFoundId).updateData({
      "hasChatWith": FieldValue.arrayUnion([userId]),
      "chatWithHolderName": FieldValue.arrayUnion([_holderName]),
    });
    Firestore.instance.collection("users").document(userId).updateData({
      "hasChatWith": FieldValue.arrayUnion([_userFoundId]),
      "chatWithHolderName": FieldValue.arrayUnion([_holderName]),
      //"hasChatWith" : _userFoundId: FieldValue.arrayUnion([_holderName]),
    });
    //TODO: is userId == userFoundID: Display weird Error
    /*var arrayUserId = [userId, _holderName];
    var arrayUserFoundId = [_userFoundId, _holderName];*/

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Chat(
          chatId: _userFoundId,
          chatAvatar: documentList[0]["photoUrl"],
          chatName: "${documentList[0]["displayName"]}",
          holderName: _holderName,
        ),
      ),
    );
    print(_userFoundId);
  }
}

/*    //TODO: Implement this to find a User
     if (documentList.isEmpty) {
      Fluttertoast.showToast(msg: "No user found with that username");
      print("No user found");
    } else {
      print("User Found: " + documentList[0]["username"]);
      this.setState(() {
        isLoading = false;
      });
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserFoundScreen(documentList[0]),
          ));
    } */
