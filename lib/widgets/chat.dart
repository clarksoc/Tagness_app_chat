import 'package:flutter/material.dart';

import '../screens/chat_screen.dart';

class Chat extends StatelessWidget {
  final String chatId;
  final String chatName;
  final String chatAvatar;

  Chat({Key key, @required this.chatId, @required this.chatAvatar, @required this.chatName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "$chatName",
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ChatScreen(
        chatId: chatId,
        chatAvatar: chatAvatar,
      ),
    );
  }
}
