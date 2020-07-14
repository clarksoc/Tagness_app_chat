import 'package:barcode_scan/model/scan_result.dart';
import 'package:barcode_scan/platform_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
        title: Text("QR Code Scanner"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 16,
              ),
              child: RaisedButton(
                color: Colors.cyan,
                textColor: Colors.black,
                splashColor: Colors.blueGrey,
                onPressed: startScan,
                child: const Text("START CAMERA SCAN"),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 16,
              ),
              child: Text(
                qrCode,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future startScan() async {
    try{
      var qrCode = await BarcodeScanner.scan();
      setState(() {
        this.qrCode = qrCode.rawContent;
      });
    } on PlatformException catch (e){
      if (e.code == BarcodeScanner.cameraAccessDenied){
        setState(() {
          this.qrCode = "The user did not grant camera permission!";
        });
      }else{
        setState(() {
          this.qrCode = "Unknown error: $e";
        });
      }
    } on FormatException{
      setState(() {
        this.qrCode = "Null (User returned using the \"Back\"-button before scanning could complete.) Result";
      });
    } catch (e){
      setState(() {
        this.qrCode = "Unknown Error: $e";
      });
    }
  }
}
