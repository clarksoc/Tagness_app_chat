import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'username_screen.dart';
import 'main_screen.dart';
import '../widgets/loading.dart';

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

  Future<Null> googleSignInHandler() async {
    preferences = await SharedPreferences.getInstance();
    bool firstTime = preferences.getBool('first_time');

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
      if (documents.length == 0) {
        //New User, creates new data
        Firestore.instance
            .collection("users")
            .document(firebaseUser.uid)
            .setData({
          "displayName": firebaseUser.displayName,
          "photoUrl": firebaseUser.photoUrl,
          "id": firebaseUser.uid,
          "createdAt": Timestamp.now().toString(),
          "phoneNumber": firebaseUser.phoneNumber,
          "firstName": null,
          "lastName": null,
          "email": firebaseUser.email,
        });
        //Writing data to local device
        currentUser = firebaseUser;

        await preferences.setString("id", currentUser.uid);
        await preferences.setString("displayName", currentUser.displayName);
        await preferences.setString("photoUrl", currentUser.photoUrl);
        await preferences.setString("phoneNumber", currentUser.phoneNumber);
      } else {
        //Existing user, retrieves data
        await preferences.setString("id", documents[0]["id"]);
        await preferences.setString("displayName", documents[0]["displayName"]);
        await preferences.setString("photoUrl", documents[0]["photoUrl"]);
        await preferences.setString("phoneNumber", documents[0]["phoneNumber"]);
        await preferences.setString("email", documents[0]["email"]);
        await preferences.setString("firstName", documents[0]["firstName"]);
        await preferences.setString("lastName", documents[0]["lastName"]);
      }
      Fluttertoast.showToast(msg: "Sign in Successful",
        backgroundColor: Colors.grey,
        textColor: Colors.black,
      );
      this.setState(() {
        isLoading = false;
      });

      if(firstTime != null && !firstTime){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MainScreen(
              currentUserId: firebaseUser.uid,
            ),
          ),
        );
      }else{
        preferences.setBool('first_time', false);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserNameScreen(),
          ),
        );
      }


    }
    return null;
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).accentColor,
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
