import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrScreen extends StatefulWidget {
  QrScreen(this.dataString, this.dataQr);

  final String dataString;
  final Map<String, String> dataQr;

  @override
  _QrScreenState createState() => _QrScreenState();
}

class _QrScreenState extends State<QrScreen> {
  GlobalKey globalKey = new GlobalKey();



  @override
  Widget build(BuildContext context) {
    var _dataQr = widget.dataQr;
    /*final bodyHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).viewInsets.bottom;*/
    //String _dataString = widget.dataString.toString();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).accentColor,
        title: Text(
          "Your QR Code",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Text("Type: ${_dataQr["type"]} \n"
              "Contact Name: ${_dataQr["contactName"]} \n"
              "Holder Name: ${_dataQr["holderName"]} \n"
              "Contact Email: ${_dataQr["email"]} \n"
              "Contact Phone Number: ${_dataQr["phoneNumber"]} \n"
          ),
          Center(
              child: RepaintBoundary(
                key: globalKey,
                child: QrImage(
                  data: widget.dataString,
                  //size: 0.5 * bodyHeight,
                ),
              ),
          ),
        ],
      ),
    );
  }
}
