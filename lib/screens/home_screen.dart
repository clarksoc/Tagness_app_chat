import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final GoogleSignIn googleSignIn = GoogleSignIn();
  bool isLoading = false;
  List<Selection> selection

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

class Selection{
  final String title;
  final IconData iconData;
  const Selection({this.title, this.iconData});
}
