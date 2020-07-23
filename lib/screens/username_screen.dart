import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main_screen.dart';

class UserNameScreen extends StatefulWidget {
  @override
  _UserNameScreenState createState() => _UserNameScreenState();
}

class _UserNameScreenState extends State<UserNameScreen> {
  final _formKey = GlobalKey<FormState>();

  final usernameFocusNode = FocusNode();
  SharedPreferences sharedPreferences;
  bool isLoading = false;

  TextEditingController usernameController;

  String username = "";
  String userId = "";

  @override
  void initState() {
    super.initState();
    readLocal();
  }

  readLocal() async {
    sharedPreferences = await SharedPreferences.getInstance();

    userId = sharedPreferences.getString("id") ?? "";
    username = sharedPreferences.getString("username") ?? "";

    usernameController = TextEditingController(text: username);

    setState(() {});
  }

  void updateData(String username) {
    setState(() {
      isLoading = true;
    });
    Firestore.instance
        .collection("users")
        .document(userId)
        .updateData({"username": username}).then((data) async {
      await sharedPreferences.setString("username", username);

      setState(() {
        isLoading = false;
      });

      Fluttertoast.showToast(msg: "Username Set!",
        backgroundColor: Colors.grey,
        textColor: Colors.black,
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MainScreen(
            currentUserId: userId,
          ),
        ),
      );
    }).catchError((error) {
      setState(() {
        isLoading = false;
      });

      Fluttertoast.showToast(msg: error.toString(),
        backgroundColor: Colors.grey,
        textColor: Colors.black,
      );
    });
  }

  void _trySubmit() async {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    final valid = await usernameCheck(username);
    if (!valid) {
      print("test");
      // username exists
      Fluttertoast.showToast(
        msg: "Username already exists!",
        backgroundColor: Colors.red,
        textColor: Colors.black,
      );
    } else if (isValid) {
      _formKey.currentState.save();
      updateData(
        username.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Create your username!",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).accentColor,
      ),
      body: Center(
        child: Card(
          margin: EdgeInsets.all(20),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text("Create your unique username"),
                  TextFormField(
                    key: ValueKey("username"),
                    keyboardType: TextInputType.text,
                    onChanged: (value) {
                      username = value;
                    },
                    controller: usernameController,
                    validator: validateUsername,
                  ),
                  Container(
                    child: FlatButton(
                      onPressed: _trySubmit,
                      child: Text(
                        "SAVE",
                        style: TextStyle(fontSize: 16.0),
                      ),
                      color: Theme.of(context).primaryColor,
                      splashColor: Colors.transparent,
                      textColor: Colors.black,
                      padding: EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 10.0),
                    ),
                    margin: EdgeInsets.symmetric(vertical: 50.0),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String validateUsername(String value) {
    if (value.length <= 4) {
      return "Username must be more than 4 characters long!";
    } else if (value.contains(" ")) {
      return "Username cannot include spaces";
    } else
      return null;
  }

  Future<bool> usernameCheck(String username) async {
    final result = await Firestore.instance
        .collection("users")
        .where("username", isEqualTo: username)
        .getDocuments();
    return result.documents.isEmpty;
  }
}
