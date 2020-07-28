import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ModifyQrScreen extends StatefulWidget {
  ModifyQrScreen(this.qrData);

  final Map<String, String> qrData;

  @override
  _ModifyQrScreenState createState() => _ModifyQrScreenState();
}

class _ModifyQrScreenState extends State<ModifyQrScreen> {
  TextEditingController holderNameController;
  TextEditingController emailController;
  TextEditingController phoneNumberController;
  TextEditingController contactNameController;
  TextEditingController descriptionController;
  TextEditingController typeController;

  SharedPreferences sharedPreferences;

  String userId = "";

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    readLocal();
  }

  void readLocal() async {
    sharedPreferences = await SharedPreferences.getInstance();

    userId = sharedPreferences.getString("id") ?? "";

    setState(() {});
  }

  void updateQrCode(
    BuildContext ctx,
    Map<String, String> qrData,
  ) {
    setState(() {
      isLoading = true;
    });

    Firestore.instance
        .collection("users")
        .document(userId)
        .collection("QrCodes")
        .where("url", isEqualTo: qrData["url"])
        .getDocuments()
        .then(
          (value) => value.documents.first.reference.updateData({
            "type": qrData["type"],
            "holderName": qrData["holderName"],
            "contactName": qrData["contactName"],
            "username": qrData["username"],
            "url": qrData["url"],
            "email": qrData["email"],
            "phoneNumber": qrData["phoneNumber"],
          }).then((data) async {
            setState(() {
              isLoading = false;
            });
            Fluttertoast.showToast(
              msg: "Update Successful!",
              backgroundColor: Colors.grey,
              textColor: Colors.black,
            );
          }).catchError((error) {
            setState(() {
              isLoading = false;
            });
            Fluttertoast.showToast(
              msg: error.toString(),
              backgroundColor: Colors.grey,
              textColor: Colors.black,
            );
          }),
        );
  }

  @override
  Widget build(BuildContext context) {
    var qrData = widget.qrData;
    return Container();
  }
}
