import 'package:flutter/material.dart';
import 'package:tagnessappchat/screens/main_screen.dart';
import 'package:tagnessappchat/screens/qr_overview_screen.dart';

import 'screens/splash_screen.dart';

void main() {
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
      debugShowCheckedModeBanner: false,
    );
  }
}