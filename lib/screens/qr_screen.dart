import 'package:flutter/material.dart';

class QrScreen extends StatefulWidget {
  QrScreen(this.dataString, this.dataQr);
  final String dataString;
  final dataQr;
  @override
  _QrScreenState createState() => _QrScreenState();
}

class _QrScreenState extends State<QrScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
