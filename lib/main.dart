import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:tagnessappchat/screens/main_screen.dart';
import 'package:tagnessappchat/screens/qr_overview_screen.dart';

import 'screens/splash_screen.dart';

void main() {
  //FIREBASE Crashlytics
  Crashlytics.instance.enableInDevMode = true;
  // Pass all uncaught errors from the framework to Crashlytics.
  FlutterError.onError = Crashlytics.instance.recordFlutterError;

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
        backgroundColor: Colors.cyan,
        accentColor: Colors.blueGrey,
        accentColorBrightness: Brightness.dark,
        buttonTheme: ButtonTheme.of(context).copyWith(
          buttonColor: Colors.cyan,
          textTheme: ButtonTextTheme.primary,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: "/",
      routes: {
        "/MainScreen": (context) => MainScreen(),
        "/QrOverview": (context) => QrOverviewScreen(),
      },
      home: LaunchScreen(),
/*      home: Scaffold(
        appBar: AppBar(
          title: Text("CRASH"),
        ),
        body: Center(
          child: FlatButton(
            child: Text("CRASH"),
            onPressed: () {
              Crashlytics.instance.crash();
            },
          ),
        ),
      ),*/
      debugShowCheckedModeBanner: false,
    );
  }
}
