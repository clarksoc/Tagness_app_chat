import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tagnessappchat/screens/settings_screen.dart';
import 'package:tagnessappchat/widgets/profile.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';



import '../main.dart';
import '../widgets/chat.dart';
import '../widgets/open_dialog.dart';
import 'chat_overview_screen.dart';
import 'login_screen.dart';
import 'scan_screen.dart';

import 'generate_screen.dart';

class MainScreen extends StatefulWidget {
  final String currentUserId;

  MainScreen({Key key, @required this.currentUserId});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  var fireInstance = Firestore.instance;
  var fireAuth = FirebaseAuth.instance;

  final GoogleSignIn googleSignIn = GoogleSignIn();

  bool isLoading = false;

  List<Selection> selections = const <Selection>[
    //Drop down menu options
    const Selection(title: "Settings", iconData: Icons.settings),
    const Selection(title: "Profile", iconData: Icons.person),
    const Selection(title: "Log out", iconData: Icons.exit_to_app),
  ];

  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  String _appBadgeSupported = "Unknown";
  String groupKey = "groupKey";

  @override
  void initState() {
    super.initState();
    initPlatformState();
    registerNotification();
    configureLocalNotification();
  }

  initPlatformState() async{
    String appBadgeSupported;
    try{
      bool res = await FlutterAppBadger.isAppBadgeSupported();
      if(res){
        appBadgeSupported = "Supported";
      }else{
        appBadgeSupported = "Not Supported";
      }
    }on PlatformException {
      appBadgeSupported = "Failed to get badge support";
    }

    if(!mounted) return;

    setState(() {
      _appBadgeSupported = appBadgeSupported;
    });
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
        print("Supported? $_appBadgeSupported");
        _addBadge();
        return;
      },
      onLaunch: (Map<String, dynamic> message) {
        print("onMessage: $message");

        Platform.isAndroid ?
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Chat(chatId: message["data"]["id"], chatName: message["data"]["name"], chatAvatar: message["data"]["photo_url"],)),
        ) : Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Chat(chatId: message["id"], chatName: message["name"], chatAvatar: message["photo_url"],)),
        );
        _removeBadge();
        print("Supported? $_appBadgeSupported");
        return;
      },
      onResume: (Map<String, dynamic> message) {
        print("onMessage: $message");

        Platform.isAndroid ?
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Chat(chatId: message["data"]["id"], chatName: message["data"]["name"], chatAvatar: message["data"]["photo_url"],)),
        ) : Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Chat(chatId: message["id"], chatName: message["name"], chatAvatar: message["photo_url"],)),
        );
        _removeBadge();
        print("$_appBadgeSupported");
        return;
      },
    );
    firebaseMessaging.getToken().then((token) {
      print("Token: $token");
      fireInstance
          .collection("users")
          .document(widget.currentUserId)
          .updateData({"pushToken": token});
    }).catchError((onError) {
      Fluttertoast.showToast(msg: onError.message.toString());
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
      groupKey: groupKey,
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
  Future selectNotification(String message) async {
    if (message != null) {
      debugPrint('notification payload: $message');
    }
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Chat(chatId: message,)),
    );
  }

  onMenuPress(selection) {
    if (selection.title == "Log out") signOutHandler();
    if (selection.title == "Settings")
      Navigator.push(context, MaterialPageRoute(builder: (cxt) => SettingsScreen("SETTINGS")));
    if (selection.title == "Profile")
      Navigator.push(context, MaterialPageRoute(builder: (cxt) => SettingsScreen("PROFILE")));

    return;
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
        MaterialPageRoute(builder: (ctx) => LoginScreen(title: "Tagness",)),
            (Route<dynamic> route) => false);
  }

  Future<bool> onBackPress(){
    OpenDialog(context);
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        title: Text("Tagness Home Screen",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).accentColor,
      ),
      body: WillPopScope(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 18,
                ),
                child: RaisedButton(
                  color: Colors.cyan,
                  textColor: Colors.black,
                  splashColor: Colors.blueGrey,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ScanScreen(),
                      ),
                    );
                  },
                  child: const Text("SCAN QR CODE"),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 18,
                ),
                child: RaisedButton(
                  color: Colors.cyan,
                  textColor: Colors.black,
                  splashColor: Colors.blueGrey,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GenerateScreen(currentUserId: widget.currentUserId,),
                      ),
                    );
                  },
                  child: const Text("GENERATE QR CODE"),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 18,
                ),
                child: RaisedButton(
                  color: Colors.cyan,
                  textColor: Colors.black,
                  splashColor: Colors.blueGrey,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatOverviewScreen(currentUserId: widget.currentUserId,),
                      ),
                    );
                  },
                  child: const Text("CHATS"),
                ),
              ),
            ],
          ),
        ),
        onWillPop: onBackPress,
      ),
    );
  }
}
void _addBadge(){
  FlutterAppBadger.updateBadgeCount(1);
}

void _removeBadge(){
  FlutterAppBadger.removeBadge();
}
//TODO: Make a separate file for selections
class Selection {
  final String title;
  final IconData iconData;

  const Selection({this.title, this.iconData});
}
