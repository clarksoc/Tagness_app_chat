import 'package:flutter/material.dart';

import '../screens/chat_screen.dart';

class Chat extends StatelessWidget {
  final String chatId;
  final String chatAvatar;

  Chat({Key key, @required this.chatId, @required this.chatAvatar})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "CHAT",
          style: TextStyle(
              color: Theme.of(context).primaryColor,
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
