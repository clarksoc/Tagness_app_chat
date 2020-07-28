import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tagnessappchat/screens/user_found_screen.dart';
import '../models/find_user.dart';

import 'loading.dart';

class ScanForm extends StatefulWidget {
  final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

  @override
  _ScanFormState createState() => _ScanFormState();
}

class _ScanFormState extends State<ScanForm> with RouteAware {
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  String _qrCodeUrl;
  String _qrCodeUsername;
  String _qrCodeId;
  String userId;

  SharedPreferences sharedPreferences;

  TextEditingController qrCodeUsernameController;
  TextEditingController qrCodeIdController;

  @override
  void initState() {
    super.initState();
    readLocal();
    this.setState(() {
      isLoading = false;
    });
  }
  readLocal() async{
    sharedPreferences = await SharedPreferences.getInstance();

    userId = sharedPreferences.getString("id") ?? "";

  }


  _trySubmit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    _qrCodeUrl = _qrCodeUsername.trim()+_qrCodeId.trim();
    if (isValid) {
      this.setState(() {
        isLoading = true;
      });
      findUserUrl(context, _qrCodeUrl, userId);
      Future.delayed(const Duration(milliseconds: 1000), () {
        setState(() {
          isLoading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          child: Text(
            "Users QR Code URL",
            style: TextStyle(
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor),
          ),
          margin: EdgeInsets.only(left: 10.0, bottom: 5.0, top: 10.0),
        ),
        Form(
          key: _formKey,
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Text(
                  "tgns.to/",
                  textAlign: TextAlign.right,
                ),
              ),
              Expanded(
                flex: 4,
                child: Theme(
                  data: Theme.of(context)
                      .copyWith(primaryColor: Theme.of(context).primaryColor),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 0),
                    child: TextFormField(
                      key: ValueKey("url"),
                      validator: validateUsername,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: "username",
                        errorMaxLines: 2,
                        contentPadding: EdgeInsets.all(5.0),
                        hintStyle: TextStyle(
                          color: Colors.grey[300],
                        ),
                      ),
                      controller: qrCodeUsernameController,
                      onChanged: (value) {
                        _qrCodeUsername = "tgns.to/$value";
                      },
                    ),
                  ),
                ),
              ),
              Text(
                  "/",
                  textAlign: TextAlign.left,
              ),
              Expanded(
                flex: 4,
                child: Theme(
                  data: Theme.of(context)
                      .copyWith(primaryColor: Theme.of(context).primaryColor),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 60),
                    child: TextFormField(
                      key: ValueKey("url"),
                      validator: validateId,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: "ID",
                        errorMaxLines: 2,
                        contentPadding: EdgeInsets.all(5.0),
                        hintStyle: TextStyle(
                          color: Colors.grey[300],
                        ),
                      ),
                      controller: qrCodeIdController,
                      onChanged: (value) {
                        _qrCodeId = "/$value";
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        isLoading
            ? const Loading()
            : Container(
                child: FlatButton(
                  onPressed: _trySubmit,
                  child: Text(
                    "SEARCH",
                    style: TextStyle(fontSize: 16.0),
                  ),
                  color: Theme.of(context).primaryColor,
                  splashColor: Colors.transparent,
                  textColor: Colors.black,
                  padding:
                      EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                ),
              ),
      ],
    );
  }

  String validateUsername(String value) {
    value = value.trim();
    if (value.length <= 4)
      return 'Name must be more than 4 characters long!';
    else
      return null;
  }
  String validateId(String value) {
    value = value.trim();
    Pattern pattern = r'^[0-9]+$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return "ID must be a number";
    else
      return null;
  }
  String validateUrl(String value) {
    value = value.trim();
    Pattern pattern = r'^[a-zA-Z0-9]+[\/]+[0-9]+$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter a Valid Url!';
    else
      return null;
  }
}
