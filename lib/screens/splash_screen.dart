import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splashscreen/splashscreen.dart';

import 'main_screen.dart';
import 'login_screen.dart';

class LaunchScreen extends StatefulWidget {
  @override
  _LaunchScreenState createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {

  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  SharedPreferences preferences;

  bool isLoading = false;
  bool isLogIn = false;

  FirebaseUser currentUser;

  @override
  void initState() {
    super.initState();
    //FocusScope.of(context).unfocus();//closes keyboard as app opens
    isSignedIn();

  }

  void isSignedIn() async {
    setState(() {
      isLoading = true;
    });

    preferences = await SharedPreferences.getInstance();
    isLogIn = await googleSignIn.isSignedIn();

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 5,
      navigateAfterSeconds: isLogIn == true ?
      MainScreen(
          currentUserId: preferences.getString("id")) : LoginScreen(title: "Tagness"),
      title: Text("Welcome to the Tagness App!", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),),
      image: Image.asset("images/flutter_logo_with_text.png"),
      photoSize: 200,
      backgroundColor: Colors.white,
      onClick: () => print("I'm loading here!"),
      loaderColor: Theme.of(context).primaryColor,
    );
  }
}
