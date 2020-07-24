import 'package:flutter/material.dart';

import '../screens/chat_screen.dart';

class Chat extends StatelessWidget {
  final String chatId;
  final String chatName;
  final String chatAvatar;
  final String holderName;

  Chat({Key key, @required this.chatId, @required this.chatAvatar, @required this.chatName, @required this.holderName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "$chatName: $holderName",
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).accentColor,
        centerTitle: true,
      ),
      body: ChatScreen(
        chatId: chatId,
        chatAvatar: chatAvatar,
        holderName: holderName,
      ),
    );
  }
}
