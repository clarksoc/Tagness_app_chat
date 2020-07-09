import 'dart:io';

import 'package:flutter/material.dart';

Future<Null> OpenDialog(BuildContext context) async {
  switch (await showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          children: <Widget>[
            Container(
              color: Theme.of(context).primaryColor,
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
                    "Exit App",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Are you sure you want to exit?",
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
                      Icons.check_circle,
                      color: Theme.of(context).primaryColor,
                    ),
                    margin: EdgeInsets.only(right: 10),
                  ),
                  Text(
                    "YES",
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
      exit(0);
      break;
  }
}
