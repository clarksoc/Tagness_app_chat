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

import '../widgets/settings.dart';
import '../widgets/profile.dart';

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
    firebaseMessaging.getToken().then((token) {
      print("Token: $token");
      fireInstance
          .collection("users")
          .document(currentUserId)
          .updateData({"pushToken": token});
    }).catchError((onError) {
      FlutterToast.showToast(msg: onError.message.toString());
    });
  }

  void showNotification(message) async {
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      "com.connor.tagnessappchat",
      "Tagness Chat App",
      "Channel Description",
      playSound: true,
      enableLights: true,
      enableVibration: true,
      importance: Importance.Max,
      priority: Priority.High,
    );
    IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails();
    NotificationDetails notificationDetails =
        NotificationDetails(androidNotificationDetails, iosNotificationDetails);

    print(message);

    await flutterLocalNotificationsPlugin.show(
      0,
      message["title"].toString(),
      message["body"].toString(),
      notificationDetails,
      payload: json.encode(message),
    );
  }

  void configureLocalNotification() {
    AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings("app_icon");
    IOSInitializationSettings iosInitializationSettings =
        IOSInitializationSettings();
    InitializationSettings initializationSettings = InitializationSettings(
        androidInitializationSettings, iosInitializationSettings);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void onMenuPress(Selection selection) {
    if (selection.title == "Log out") signOutHandler();
    if (selection.title == "Settings")
      Navigator.push(context, MaterialPageRoute(builder: (cxt) => Settings()));
    if(selection.title == "Profile")
      Navigator.push(context, MaterialPageRoute(builder: (cxt) => Profile()));

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      body: WillPopScope(
        child: Stack(children: <Widget>[
          Container(child: ,),
        ],),
      ),
    );
  }
}

class Selection {
  final String title;
  final IconData iconData;

  const Selection({this.title, this.iconData});
}