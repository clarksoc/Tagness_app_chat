import 'package:barcode_scan/platform_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tagnessappchat/models/find_user.dart';
import 'package:tagnessappchat/screens/main_screen.dart';
import 'package:tagnessappchat/widgets/scan_form.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';


class ScanScreen extends StatefulWidget {
  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  String qrCode = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "QR Code Finder",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme
            .of(context)
            .accentColor,
        centerTitle: true,
      ),
      body: WillPopScope(
        child: Center(
          child: Card(
            margin: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                  child: ScanForm(),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                  child: RaisedButton(
                    color: Colors.cyan,
                    textColor: Colors.black,
                    splashColor: Colors.blueGrey,
                    onPressed: () {
                      Crashlytics.instance.crash();
                      //startScan;
                    },
                    child: const Text("START CAMERA SCAN"),
                  ),
                ),
              ],
            ),
          ),
        ),
        onWillPop: onBackPress,
      ),
    );
  }

  Future<bool> onBackPress() {
    Navigator.of(context).pop();
    return Future.value(false);
  }

  Future startScan() async {
    try {
      var qrCode = await BarcodeScanner.scan();
      setState(() {
        this.qrCode = qrCode.rawContent;
      });
      findUserUrl(this.context, this.qrCode);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.cameraAccessDenied) {
        setState(() {
          this.qrCode = "The user did not grant camera permission!";
        });
      } else {
        setState(() {
          this.qrCode = "Unknown error: $e";
        });
      }
    } on FormatException {
      setState(() {
        this.qrCode =
        "Null (User returned using the \"Back\"-button before scanning could complete.) Result";
      });
    } catch (e) {
      setState(() {
        this.qrCode = "Unknown Error: $e";
      });
    }
  }
}
