import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class QrOverviewScreen extends StatefulWidget {
  QrOverviewScreen(this.dataString, this.qrData);
  final String dataString;
  final Map<String, String> qrData;

  @override
  _QrOverviewScreenState createState() => _QrOverviewScreenState();
}

class _QrOverviewScreenState extends State<QrOverviewScreen> {
  final fireStoreInstance = Firestore.instance;

  //TODO: Create a new database of Qr codes for each user (based on userId)
  String qrCodeId;
  bool isLoading;
  SharedPreferences sharedPreferences;
  var uuid = Uuid();
  String userId;
  String username;
  int counter;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    qrCodeId = "";
    isLoading = false;
    readLocal();
  }

  readLocal() async {
    sharedPreferences = await SharedPreferences.getInstance();
    userId = sharedPreferences.getString("id") ?? "";
    username = sharedPreferences.getString("username") ?? "";
    qrCodeId = "www.tgns.to/$username/";

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Your QR Codes",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme
            .of(context)
            .accentColor,
      ),
      body: WillPopScope(
        child: Stack(
          children: <Widget>[
            //buildQrCodes(),
          ],
        ),
      ),
    );
  }

/*  Widget buildQrCodes() {
    return Flexible(
      child: FutureBuilder(
        future: FirebaseAuth.instance.currentUser(),
        builder: (ctx, futureSnapshot) {
          if (futureSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return StreamBuilder(
            stream: fireStoreInstance.collection("QRCodes").document(qrCodeId)
                .collection(qrCodeId).orderBy("url", descending: true)
                .snapshots(),
            builder: (context, qrSnapshot){
              if (qrSnapshot.connectionState ==
                  ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else{
                return ListView.builder(itemBuilder: (context, index) => buildItemQr(
                  context,
                  index,
                  qrSnapshot.data.documents[index],
                  userId,
                  widget.dataString,
                  widget.qrData,

                ));
              }
            },
          );
        },
      ),
    );
  }*/
}
