import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tagnessappchat/widgets/user_form.dart';
import 'package:uuid/uuid.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final usernameFocusNode = FocusNode();
  final emailFocusNode = FocusNode();
  final phoneNumberFocusNode = FocusNode();
  final firstNameFocusNode = FocusNode();
  final lastNameFocusNode = FocusNode();

  TextEditingController usernameController;
  TextEditingController emailController;
  TextEditingController phoneNumberController;
  TextEditingController firstNameController;
  TextEditingController lastNameController;

  SharedPreferences sharedPreferences;

  String userId = "";
  String email = "";
  String username = "";
  String phoneNumber = "";
  String firstName = "";
  String lastName = "";
  String photoUrl = "";

  bool isLoading = false;
  File userImageFile;

  var uuid = Uuid();

  @override
  void initState() {
    super.initState();
    readLocal();
  }

  void readLocal() async {
    sharedPreferences = await SharedPreferences.getInstance();

    userId = sharedPreferences.getString("id") ?? "";
    username = sharedPreferences.getString("username") ?? "";
    email = sharedPreferences.getString("email") ?? "";
    phoneNumber = sharedPreferences.getString("phoneNumber") ?? "";
    firstName = sharedPreferences.getString("firstName") ?? "";
    lastName = sharedPreferences.getString("lastName") ?? "";
    photoUrl = sharedPreferences.getString("photoUrl") ?? "";

    usernameController = TextEditingController(text: username);
    emailController = TextEditingController(text: email);
    phoneNumberController = TextEditingController(text: phoneNumber);
    firstNameController = TextEditingController(text: firstName);
    lastNameController = TextEditingController(text: lastName);

    setState(() {});
    print(username);

  }

  Future getImage() async {
    final pickedImageFile =
        await ImagePicker().getImage(source: ImageSource.gallery);

    if (pickedImageFile != null) {
      setState(() {
        userImageFile = File(pickedImageFile.path);
        isLoading = true;
      });
      uploadFile();
    }
  }

  Future uploadFile() async {
    String fileName = uuid.v4();
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask storageUploadTask =
        storageReference.putFile(userImageFile);
    StorageTaskSnapshot storageTaskSnapshot;
    Firestore.instance.collection("users").document(userId).collection("username");
    storageUploadTask.onComplete.then((value) {
      if (value.error == null) {
        storageTaskSnapshot = value;
        storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
          photoUrl = downloadUrl;
          Firestore.instance.collection("users").document(userId).updateData({
            "username": username,
            "email": email,
            "phoneNumber": phoneNumber,
            "firstName": firstName,
            "lastName": lastName,
            "photoUrl": photoUrl,
          }).then((data) async {
            await sharedPreferences.setString("photoUrl", photoUrl);
            setState(() {
              isLoading = false;
            });
            FlutterToast.showToast(msg: "Upload Successful!");
          }).catchError((error) {
            setState(() {
              isLoading = false;
            });
            FlutterToast.showToast(msg: error.toString());
          });
        }, onError: (error) {
          setState(() {
            isLoading = false;
          });
          FlutterToast.showToast(msg: "This file is not an image!");
        });
      } else {
        setState(() {
          isLoading = false;
        });
        FlutterToast.showToast(msg: "This file is not an image!");
      }
    }, onError: (error) {
      setState(() {
        isLoading = false;
      });
      FlutterToast.showToast(msg: error.toString());
    });
  }

  void updateData(
    BuildContext ctx,
    String username,
    String email,
    String phoneNumber,
    String firstName,
    String lastName,
  ) {
    usernameFocusNode.unfocus();
    emailFocusNode.unfocus();
    phoneNumberFocusNode.unfocus();
    firstNameFocusNode.unfocus();
    lastNameFocusNode.unfocus();

    setState(() {
      isLoading = true;
    });

    Firestore.instance.collection("users").document(userId).updateData({
      "username": username,
      "email": email,
      "phoneNumber": phoneNumber,
      "firstName": firstName,
      "lastName": lastName,
      "photoUrl": photoUrl,
    }).then((data) async {
      await sharedPreferences.setString("username", username);
      await sharedPreferences.setString("email", email);
      await sharedPreferences.setString("phoneNumber", phoneNumber);
      await sharedPreferences.setString("firstName", firstName);
      await sharedPreferences.setString("lastName", lastName);

      setState(() {
        isLoading = false;
      });
      FlutterToast.showToast(msg: "Update Successful!");
    }).catchError((error) {
      setState(() {
        isLoading = false;
      });
      FlutterToast.showToast(msg: error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "SETTINGS",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).accentColor,
      ),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  child: Stack(
                    children: <Widget>[
                      userImageFile == null
                          ? (photoUrl != ""
                              ? Material(
                                  child: CachedNetworkImage(
                                    placeholder: (context, url) => Container(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.0,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Theme.of(context).primaryColor),
                                      ),
                                      width: 90.0,
                                      height: 90.0,
                                      padding: EdgeInsets.all(20.0),
                                    ),
                                    imageUrl: photoUrl,
                                    width: 90.0,
                                    height: 90.0,
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(45.0),
                                  ),
                                  clipBehavior: Clip.hardEdge,
                                )
                              : Icon(
                                  Icons.account_circle,
                                  size: 90.0,
                                  color: Colors.grey[300],
                                ))
                          : Material(
                              child: Image.file(
                                userImageFile,
                                width: 90.0,
                                height: 90.0,
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(45.0),
                              ),
                              clipBehavior: Clip.hardEdge,
                            ),
                      IconButton(
                        icon: Icon(
                          Icons.camera_enhance,
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.5),
                        ),
                        onPressed: getImage,
                        padding: EdgeInsets.all(30.0),
                        splashColor: Colors.transparent,
                        highlightColor: Colors.grey[300],
                        iconSize: 30.0,
                      ),
                    ],
                  ),
                  width: double.infinity,
                  margin: EdgeInsets.all(20.0),
                ),
                UserForm(
                  updateData,
                  isLoading,
                )
                /*Form(
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Text(
                          "Username",
                          style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor),
                        ),
                        margin:
                            EdgeInsets.only(left: 10.0, bottom: 5.0, top: 10.0),
                      ),
                      Container(
                        child: Theme(
                          data: Theme.of(context).copyWith(
                              primaryColor: Theme.of(context).primaryColor),
                          child: TextField(
                            decoration: InputDecoration(
                                hintText: "Update your username!",
                                contentPadding: EdgeInsets.all(5.0),
                                hintStyle: TextStyle(
                                  color: Colors.grey[300],
                                ),
                            ),
                            controller: usernameController,
                          ),
                        ),
                        margin: EdgeInsets.symmetric(vertical: 30.0),
                      ),
                      Container(
                        child: Text(
                          "Email Address",
                          style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor),
                        ),
                        margin:
                        EdgeInsets.only(left: 10.0, bottom: 5.0, top: 10.0),
                      ),
                      Container(
                        child: Theme(
                          data: Theme.of(context).copyWith(
                              primaryColor: Theme.of(context).primaryColor),
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: "Update your email!",
                              contentPadding: EdgeInsets.all(5.0),
                              hintStyle: TextStyle(
                                color: Colors.grey[300],
                              ),
                            ),
                            controller: emailController,
                            key: ValueKey("email"),
                            validator: (value) {
                              if (value.isEmpty || !value.contains("@")) {
                                return "Please Enter a Valid Email Address";
                              }
                              return null;
                            },
                          ),
                        ),
                        margin: EdgeInsets.symmetric(vertical: 30.0),
                      ),
                      Container(
                        child: Text(
                          "Phone Number",
                          style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor),
                        ),
                        margin:
                        EdgeInsets.only(left: 10.0, bottom: 5.0, top: 10.0),
                      ),
                      Container(
                        child: Theme(
                          data: Theme.of(context).copyWith(
                              primaryColor: Theme.of(context).primaryColor),
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: "Update your phone number!",
                              contentPadding: EdgeInsets.all(5.0),
                              hintStyle: TextStyle(
                                color: Colors.grey[300],
                              ),
                            ),
                            controller: emailController,
                            key: ValueKey("phone"),
                            validator: (value) {
                              if (value.isEmpty || !value.contains("@")) {
                                return "Please Enter a Valid Email Address";
                              }
                              return null;
                            },
                          ),
                        ),
                        margin: EdgeInsets.symmetric(vertical: 30.0),
                      ),

                    ],
                  ),
                )

                 */
              ],
            ),
          )
        ],
      ),
    );
  }
}
