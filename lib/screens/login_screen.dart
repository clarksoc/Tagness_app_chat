import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../widgets/loading.dart';

import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  final String title;

  LoginScreen({Key key, this.title}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  SharedPreferences preferences;

  bool isLoading = false;
  bool isLogIn = false;

  FirebaseUser currentUser;

  void isSignedIn() async {
    this.setState(() {
      isLoading = true;
    });

    preferences = await SharedPreferences.getInstance();
    isLogIn = await googleSignIn.isSignedIn();

    if (isLogIn) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            currentUserId: preferences.getString("id"),
          ),
        ),
      );
    }

    this.setState(() {
      isLoading = false;
    });
  }

  Future<Null> googleSignInHandler() async {
    preferences = await SharedPreferences.getInstance();

    this.setState(() {
      isLoading = true;
    });

    GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      idToken: googleSignInAuthentication.idToken,
      accessToken: googleSignInAuthentication.accessToken,
    );

    FirebaseUser firebaseUser =
        (await firebaseAuth.signInWithCredential(credential)).user;

    if (firebaseUser != null) {
      final QuerySnapshot result = await Firestore.instance
          .collection("users")
          .where("id", isEqualTo: firebaseUser.uid)
          .getDocuments();
      final List<DocumentSnapshot> documents = result.documents;
      //TODO: IF PHONE NUMBER IS NULL ASK FOR PHONE NUMBER
      if (documents.length == 0) {
        //New User, creates new data
        Firestore.instance
            .collection("users")
            .document(firebaseUser.uid)
            .setData({
          "username": firebaseUser.displayName,
          "photoUrl": firebaseUser.photoUrl,
          "id": firebaseUser.uid,
          "createdAt": DateTime.now().millisecondsSinceEpoch.toString(),
          "currentChat": null,
          "phoneNumber": firebaseUser.phoneNumber
        });
        //Writing data to local device
        currentUser = firebaseUser;

        await preferences.setString("id", currentUser.uid);
        await preferences.setString("username", currentUser.displayName);
        await preferences.setString("photoUrl", currentUser.photoUrl);
        await preferences.setString("phoneNumber", currentUser.phoneNumber);
      } else {
        //Existing user, retrieves data
        await preferences.setString("id", documents[0]["id"]);
        await preferences.setString("username", documents[0]["username"]);
        await preferences.setString("photoUrl", documents[0]["photoUrl"]);
        await preferences.setString("phoneNumber", documents[0]["phoneNumber"]);
        await preferences.setString("address", documents[0]["address"]);
        await preferences.setString("fullName", documents[0]["fullName"]);
      }
      FlutterToast.showToast(msg: "Sign in Successful");
      this.setState(() {
        isLoading = false;
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            currentUserId: firebaseUser.uid,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: <Widget>[
          Center(
            child: FlatButton(
              onPressed: googleSignInHandler,
              child: Text(
                "SIGN IN WITH GOOGLE",
                style: TextStyle(fontSize: 16),
              ),
              color: Color(0xffdd4b39),
              highlightColor: Color(0xffff7f7f),
              splashColor: Colors.transparent,
              textColor: Colors.white,
              padding: EdgeInsets.fromLTRB(30, 15, 30, 15),
            ),
          ),
          Positioned(
            child: isLoading ? const Loading() : Container(),
          )
        ],
      ),
    );
  }
}
