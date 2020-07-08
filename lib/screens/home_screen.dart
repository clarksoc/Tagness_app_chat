import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomeScreen extends StatefulWidget {
  final String currentUserId;

  HomeScreen({Key key, @required this.currentUserId}) : super(key: key);

  @override
  _HomeScreenState createState() =>
      _HomeScreenState(currentUserId: currentUserId);
}

class _HomeScreenState extends State<HomeScreen> {
  String currentUserId;

  _HomeScreenState({Key key, @required this.currentUserId});

  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final GoogleSignIn googleSignIn = GoogleSignIn();
  var fireInstance = Firestore.instance;
  bool isLoading = false;
  List<Selection> selections = const <Selection>[
    //Drop down menu options
    const Selection(title: "Settings", iconData: Icons.settings),
    const Selection(title: "Profile", iconData: Icons.person),
    const Selection(title: "Log out", iconData: Icons.exit_to_app),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void registerNotification() {
    firebaseMessaging
        .requestNotificationPermissions(); //Only needed for IOS devices

    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) {
        print("onMessage: $message");

        Platform.isAndroid
            ? showNotification(message["notification"])
            : showNotification(message["apps"]["alert"]);
        return;
      },
      onLaunch: (Map<String, dynamic> message) {
        print("onMessage: $message");
        return;
      },
      onResume: (Map<String, dynamic> message) {
        print("onMessage: $message");
        return;
      },
    );
    firebaseMessaging.getToken().then((token){
      print("Token: $token");
      fireInstance.collection("users").document(currentUserId).updateData({"pushToken": token});
    }).catchError((onError){
      FlutterToast.showToast(msg: onError.message.toString());
    });
  }

  void showNotification(message) async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome"),
      ),
      body: Container(
        child: Text("User Id used for QR Code: $currentUserId"),
      ),
    );
  }
}

class Selection {
  final String title;
  final IconData iconData;

  const Selection({this.title, this.iconData});
}
