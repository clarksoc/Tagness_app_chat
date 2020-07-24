import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  String _userFoundId;
  String _qrCodeUrl2;

  TextEditingController qrCodeUrlController;

  @override
  void initState() {
    super.initState();
    this.setState(() {
      isLoading = false;
    });
  }

  _trySubmit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      this.setState(() {
        isLoading = true;
      });
      findUserUrl(context, _qrCodeUrl);
      Future.delayed(const Duration(milliseconds: 1000), () {

        setState(() {
          isLoading = false;
        });

      });
    }
  }

  /*findUser(String qrCodeUrl) async {
    List<DocumentSnapshot> documentList;
    List<DocumentSnapshot> qrList;
    print(qrCodeUrl);
    qrCodeUrl = qrCodeUrl.trim();
    String username = qrCodeUrl.substring(0, qrCodeUrl.indexOf('/'));
    print(username);
    this.setState(() {
      isLoading = true;
    });
    documentList = (await Firestore.instance
            .collection("users")
            .where("username", isEqualTo: username)
            .getDocuments())
        .documents;
    if (documentList.isEmpty) {
      Fluttertoast.showToast(
        msg: "No user found with that username",
        backgroundColor: Colors.grey[200],
        textColor: Colors.black,
      );
      print("No user found");
      this.setState(() {
        isLoading = false;
      });
    } else {
      _userFoundId = documentList[0]["id"];

      qrList = (await Firestore.instance
              .collection("users")
              .document(_userFoundId)
              .collection("QrCodes")
              .where("url", isEqualTo: "tgns.to/$qrCodeUrl")
              .getDocuments())
          .documents;

      if (qrList.isEmpty) {
        Fluttertoast.showToast(msg: "No QR code was found with that link",
          backgroundColor: Colors.grey[200],
          textColor: Colors.black,
        );
        print("No QR code was found for that user with that Id");
        this.setState(() {
          isLoading = false;
        });
      } else {
        Fluttertoast.showToast(
          msg: "QR Code Found",
          backgroundColor: Colors.grey[200],
          textColor: Colors.black,
        );
        this.setState(() {
          isLoading = false;
        });
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserFoundScreen(documentList[0], qrList[0]),
            ));
      }
    }
    return null;

  }*/

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
                color: Theme
                    .of(context)
                    .primaryColor),
          ),
          margin: EdgeInsets.only(left: 10.0, bottom: 5.0, top: 10.0),
        ),
        Row(
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
              child: Form(
                key: _formKey,
                child: Theme(
                  data: Theme.of(context)
                      .copyWith(primaryColor: Theme
                      .of(context)
                      .primaryColor),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 60),
                    child: TextFormField(
                      key: ValueKey("url"),
                      validator: validateUrl,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: "username/ID",
                        contentPadding: EdgeInsets.all(5.0),
                        hintStyle: TextStyle(
                          color: Colors.grey[300],
                        ),
                      ),
                      controller: qrCodeUrlController,
                      onChanged: (value) {
                        _qrCodeUrl = "tgns.to/$value";
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
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
            color: Theme
                .of(context)
                .primaryColor,
            splashColor: Colors.transparent,
            textColor: Colors.black,
            padding:
            EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
          ),
        ),
      ],
    );
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
