import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'chat.dart';

Widget buildItem(
    BuildContext context, DocumentSnapshot documentSnapshot, currentUserId) {
  if (documentSnapshot["id"] == currentUserId) {
    //will not display the current user as a chat option
    return Container();
  } else {
    return Container(
      child: FlatButton(
          child: Row(
        children: <Widget>[
          Material(
            child: documentSnapshot["photoUrl"] != null
                ? CachedNetworkImage(
                    placeholder: (context, photoUrl) => Container(
                      width: 50,
                      height: 50,
                      padding: EdgeInsets.all(15.0),
                      child: CircularProgressIndicator(
                        strokeWidth: 1.0,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                      ),
                    ),
                    imageUrl: documentSnapshot["photoUrl"],
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  )
                : Icon(
                    Icons.account_circle,
                    size: 50.0,
                    color: Theme.of(context).primaryColor,
                  ),
            borderRadius: BorderRadius.all(
              Radius.circular(18.0),
            ),
            clipBehavior: Clip.hardEdge,
          ),
          Flexible(
              child: Container(
                child: Text(
                  "${documentSnapshot["username"]}",
                  style: TextStyle(color: Colors.black),
                ),
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(left: 10, right: 5.0),
              ),
          ),
        ],
      ),
        onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => Chat()));
        },
        color: Theme.of(context).primaryColor,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      margin: EdgeInsets.only(left: 15, right: 15, top: 20),
    );
  }
}
