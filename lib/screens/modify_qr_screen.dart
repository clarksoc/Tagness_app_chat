import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tagnessappchat/screens/main_screen.dart';
import 'package:tagnessappchat/widgets/modify_qr_form.dart';

class ModifyQrScreen extends StatefulWidget {
  ModifyQrScreen(this.qrData);

  final Map<String, dynamic> qrData;

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
    print(widget.qrData["url"]);

    setState(() {});
  }

  void updateQrCode(
    BuildContext ctx,
    Map<String, dynamic> _qrData,
  ) {
    setState(() {
      isLoading = true;
    });

    Firestore.instance
        .collection("users")
        .document(userId)
        .collection("QrCodes")
        .where("url", isEqualTo: _qrData["url"])
        .getDocuments()
        .then(
          (value) => value.documents.first.reference.updateData({
            "type": _qrData["type"],
            "holderName": _qrData["holderName"],
            "contactName": _qrData["contactName"],
            "username": _qrData["username"],
            "url": _qrData["url"],
            "email": _qrData["email"],
            "phoneNumber": _qrData["phoneNumber"],
            "details": _qrData["details"],
          }).then((data) async {
            setState(() {
              isLoading = false;
            });
            Fluttertoast.showToast(
              msg: "Update Successful!",
              backgroundColor: Colors.grey,
              textColor: Colors.black,
            );
            Navigator.of(context).popAndPushNamed("/QrOverview");
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
    //Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    var qrData = widget.qrData;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit QR Code",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).accentColor,
      ),
      body: WillPopScope(
        child: SingleChildScrollView(
          child: ModifyQrForm(qrData, updateQrCode, isLoading),
        ),
        onWillPop: onBackPress,
      ),
    );
  }

  Future<bool> onBackPress() {
    Navigator.of(context).pop();
    return Future.value(false);
  }
}
