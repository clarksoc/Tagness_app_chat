import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tagnessappchat/widgets/build_item_qr.dart';
import 'package:tagnessappchat/widgets/loading.dart';
import 'package:uuid/uuid.dart';

class QrOverviewScreen extends StatefulWidget {
/*  QrOverviewScreen(this.dataString, this.qrData);
  final String dataString;
  final Map<String, String> qrData;*/

  @override
  _QrOverviewScreenState createState() => _QrOverviewScreenState();
}

class _QrOverviewScreenState extends State<QrOverviewScreen> {
  final fireStoreInstance = Firestore.instance;

  //TODO: Create a new database of Qr codes for each user (based on userId)
  String qrCodeId;
  bool isLoading= false;
  SharedPreferences sharedPreferences;
  var uuid = Uuid();
  String userId;
  String username;
  int counter;
  String qrId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readLocal();
  }

  readLocal() async {
    sharedPreferences = await SharedPreferences.getInstance();
    userId = sharedPreferences.getString("id") ?? "";
    qrId = sharedPreferences.getString("url") ?? "";
    //qrData = sharedPreferences.getString(key)
    /*username = sharedPreferences.getString("username") ?? "";
    qrCodeId = "www.tgns.to/$username/";*/

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Your QR Codes",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Theme
              .of(context)
              .accentColor,
        ),
        body: Stack(
            children: <Widget>[
              Container(
                child: StreamBuilder(
                  stream: fireStoreInstance.collection("users").document(userId).collection("QrCodes").snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                        ),
                      );
                    } else {
                      if(snapshot.data.documents.length <= 1){
                        return Text("Create some QR Codes!");
                      }
                      return ListView.builder(
                        itemBuilder: (context, index) => buildItemQr(context,//calls the build_item widget and passes in the current User
                            snapshot.data.documents[index], qrId),
                        itemCount: snapshot.data.documents.length,
                      );

                    }
                  },
                ),
              ),
              Positioned(child: isLoading? const Loading() : Container())//Displays loading circle if loading users in the database or an empty container if there are no more
            ],
        ),
      ),
      //onWillPop: onBackPress,
    );
  }
}
