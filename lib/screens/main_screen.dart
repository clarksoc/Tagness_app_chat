import 'package:flutter/material.dart';

import '../widgets/open_dialog.dart';
import 'home_screen.dart';
import 'scan_screen.dart';

import 'generate_screen.dart';

class MainScreen extends StatefulWidget {
  final String currentUserId;

  MainScreen({Key key, @required this.currentUserId});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Future<bool> onBackPress(){
    OpenDialog(context);
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("QR Code Scanner & Generator"),
      ),
      body: WillPopScope(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 18,
                ),
                child: RaisedButton(
                  color: Colors.cyan,
                  textColor: Colors.black,
                  splashColor: Colors.blueGrey,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ScanScreen(),
                      ),
                    );
                  },
                  child: const Text("SCAN QR CODE"),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 18,
                ),
                child: RaisedButton(
                  color: Colors.cyan,
                  textColor: Colors.black,
                  splashColor: Colors.blueGrey,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GenerateScreen(currentUserId: widget.currentUserId,),
                      ),
                    );
                  },
                  child: const Text("GENERATE QR CODE"),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 18,
                ),
                child: RaisedButton(
                  color: Colors.cyan,
                  textColor: Colors.black,
                  splashColor: Colors.blueGrey,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeScreen(currentUserId: widget.currentUserId,),
                      ),
                    );
                  },
                  child: const Text("CHATS"),
                ),
              ),
            ],
          ),
        ),
        onWillPop: onBackPress,
      ),
    );
  }
}
