import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tagnessappchat/screens/main_screen.dart';

class QrScreen extends StatefulWidget {
  QrScreen(this.dataQr);

  final Map<String, String> dataQr;

  @override
  _QrScreenState createState() => _QrScreenState();
}

class _QrScreenState extends State<QrScreen> {
  GlobalKey globalKey = new GlobalKey();
  SharedPreferences sharedPreferences;
  String userId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readLocal();
  }

  readLocal() async {
    sharedPreferences = await SharedPreferences.getInstance();
    userId = sharedPreferences.getString("id") ?? "";

    setState(() {});
  }





  @override
  Widget build(BuildContext context) {
    var _dataQr = widget.dataQr;
    print(_dataQr["url"]);
    return WillPopScope(
      child: Scaffold(
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
                "Description: ${_dataQr["details"]} \n"
                "Url: ${_dataQr["url"]} \n"
            ),
            Center(
                child: RepaintBoundary(
                  key: globalKey,
                  child: QrImage(
                    data: _dataQr["url"],
                    /*embeddedImage: AssetImage("images/flutter_logo.png"),
                    embeddedImageStyle: QrEmbeddedImageStyle(
                        size: Size(100, 100)),*/
                    //size: 0.5 * bodyHeight,
                  ),
                ),
            ),
            RaisedButton(
              child: Text(
                "BACK TO HOME",
                style: TextStyle(fontSize: 16.0),
              ),
              color: Theme.of(context).primaryColor,
              splashColor: Colors.transparent,
              textColor: Colors.black,
              padding: EdgeInsets.symmetric(
                  horizontal: 30.0, vertical: 10.0),
              onPressed: () => Navigator.push(context, MaterialPageRoute(
                builder: (context) => MainScreen(
                  currentUserId: userId,
                ),
              )),
            ),
          ],
        ),
      ),
      onWillPop: onBackPress,
    );
  }
  Future<bool> onBackPress() {
    Navigator.of(context).pop();
    return Future.value(false);
  }
}
