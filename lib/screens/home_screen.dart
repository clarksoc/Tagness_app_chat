import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tagnessappchat/main.dart';
import 'package:tagnessappchat/screens/chat_screen.dart';
import 'package:tagnessappchat/widgets/pop_up_menu.dart';

import 'settings_screen.dart';
import '../widgets/profile.dart';
import '../widgets/build_item.dart';
import '../widgets/loading.dart';
import '../widgets/open_dialog.dart';
import '../widgets/chat.dart';

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
  var fireAuth = FirebaseAuth.instance;
  bool isLoading = false;

  List<Selection> selections = const <Selection>[
    //Drop down menu options
    const Selection(title: "Settings", iconData: Icons.settings),
    const Selection(title: "Profile", iconData: Icons.person),
    const Selection(title: "Log out", iconData: Icons.exit_to_app),
  ];

  void onMenuPress(Selection selection) {
    if (selection.title == "Log out") signOutHandler();
    if (selection.title == "Settings")
      Navigator.push(context, MaterialPageRoute(builder: (cxt) => SettingsScreen("SETTINGS")));
    if (selection.title == "Profile")
      Navigator.push(context, MaterialPageRoute(builder: (cxt) => SettingsScreen("PROFILE")));

    //TODO: Add user profile page for display/editing & Settings screen
  }

  Future<Null> signOutHandler() async {
    this.setState(() {
      isLoading = true;
    });

    await fireAuth.signOut();
    await googleSignIn
        .disconnect(); //needed for when user logged in with google
    await googleSignIn.signOut();

    this.setState(() {
      isLoading = false;
    });

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (ctx) => MyApp()),
        (Route<dynamic> route) => false);
  }

  int counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).accentColor,
        title: Text(
          "Welcome",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton<Selection>(
            onSelected: onMenuPress,
            itemBuilder: (BuildContext context) {
              return selections.map((Selection selection) {
                return PopupMenuItem<Selection>(
                  value: selection,
                  child: Row(
                    children: <Widget>[
                      Icon(selection.iconData),
                      Container(
                        width: 10.0,
                      ),
                      Text(selection.title),
                    ],
                  ),
                );
              }).toList();
            },
          )
        ],
      ),
      body: Stack(
          children: <Widget>[
            Container(
              child: StreamBuilder(
                stream: fireInstance.collection("users").snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                      ),
                    );
                  } else {
                    return FlatButton(
                      onPressed: () {
                        setState(() {
                          counter = 0;
                        });
                      },
                      child: ListView.builder(
                        itemBuilder: (context, index) => buildItem(context,//calls the build_item widget and passes in the current User
                            snapshot.data.documents[index], currentUserId),
                        itemCount: snapshot.data.documents.length,
                      ),
                    );
                  }
                },
              ),
            ),
            Positioned(child: isLoading? const Loading() : Container())//Displays loading circle if loading users in the database or an empty container if there are no more
          ],
        ),
    );
  }
}



class Selection {
  final String title;
  final IconData iconData;

  const Selection({this.title, this.iconData});
}
