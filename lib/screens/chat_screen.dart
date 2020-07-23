import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tagnessappchat/screens/chat_overview_screen.dart';
import 'package:uuid/uuid.dart';

import '../widgets/build_item_chat.dart';
import '../models/app_badge.dart';
import 'main_screen.dart';

class ChatScreen extends StatefulWidget {
  //TODO: Dismiss notification if on this page
  final String chatId;
  final String chatAvatar;
  final String payload;

  ChatScreen(
      {Key key, @required this.chatId, @required this.chatAvatar, this.payload})
      : super(key: key);

  @override
  _ChatScreenState createState() =>
      _ChatScreenState(chatId: chatId, chatAvatar: chatAvatar);
}

class _ChatScreenState extends State<ChatScreen> {
  final textEditingController = TextEditingController();
  SharedPreferences preferences;

  final FocusNode focusNode = FocusNode();
  final fireStoreInstance = Firestore.instance;

  String chatId;
  String chatAvatar;

  _ChatScreenState({Key key, @required this.chatId, @required this.chatAvatar});

  String userId;

  ScrollController scrollController;

  var listMessage;
  String groupChatId;
  SharedPreferences sharedPreferences;
  File imageFile;
  bool isLoading;
  bool showSticker;
  String imageUrl;

  var uuid = Uuid();

  @override
  void initState() {
    super.initState();
    focusNode.addListener(onFocusChange);

    groupChatId = "";
    isLoading = false;
    showSticker = false;
    imageUrl = "";

    //scrollController = new ScrollController()..addListener(_scrollListener);

    readLocal();
    removeBadge();
  }

  readLocal() async {
    sharedPreferences = await SharedPreferences.getInstance();
    userId = sharedPreferences.getString("id") ?? "";
    //groupChatId = uuid.v4();
    print(groupChatId);
    if (userId.hashCode <= chatId.hashCode) {
      groupChatId = "$userId-$chatId";
    } else {
      groupChatId = "$chatId-$userId";
    }

    fireStoreInstance
        .collection("users")
        .document(userId)
        .updateData({"chatWith": chatId});

    setState(() {});
  }

  Future getImage() async {
    final pickedImageFile =
        await ImagePicker().getImage(source: ImageSource.gallery);

    if (pickedImageFile != null) {
      setState(() {
        imageFile = File(pickedImageFile.path);
        isLoading = true;
      });
      uploadFile();
    }
  }

  Future uploadFile() async {
    String fileName = uuid.v4();
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask storageUploadTask = storageReference.putFile(imageFile);
    StorageTaskSnapshot storageTaskSnapshot =
        await storageUploadTask.onComplete;
    storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
      imageUrl = downloadUrl;
      setState(() {
        isLoading = false;
        onSendMessage(imageUrl, 1);
      });
    }, onError: (onError) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: "File is not an image",
        backgroundColor: Colors.grey,
        textColor: Colors.black,
      );
    });
  }

  void onSendMessage(String _enteredMessage, int messageType) {
    if (_enteredMessage.trim() != "") {
      textEditingController.clear();

      var documentReference = fireStoreInstance
          .collection("messages")
          .document(groupChatId)
          .collection(groupChatId)
          .document(Timestamp.now().toString());

      fireStoreInstance.runTransaction((transaction) async {
        await transaction.set(
          documentReference,
          {
            "fromId": userId,
            "toId": chatId,
            "timestamp": Timestamp.now(),
            "content": _enteredMessage,
            "type": messageType,
          },
        );
        textEditingController.clear();
      });
      scrollController.animateTo(0.0,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {
      Fluttertoast.showToast(msg: "Message is empty",
        backgroundColor: Colors.grey,
        textColor: Colors.black,
      );
    }
  }

  void onFocusChange() {
    //This function will hide sticker when keyboard pops up
    if (focusNode.hasFocus) {
      setState(() {
        showSticker = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              buildListMessage(),
              buildInput(),
            ],
          )
        ],
      ),
      onWillPop: onBackPress,
    );
  }

  Future<bool> onBackPress() {
    Firestore.instance
        .collection("users")
        .document(userId)
        .updateData({"chattingWith": null});
    Navigator.of(context).pop();
/*    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatOverviewScreen(
          currentUserId: userId,
        ),
      ),
    );*/
    return Future.value(false);
  }

  Widget buildListMessage() {
    return Flexible(
      child: FutureBuilder(
          future: FirebaseAuth.instance.currentUser(),
          builder: (ctx, futureSnapshot) {
            if (futureSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return StreamBuilder(
              stream: Firestore.instance
                  .collection("messages")
                  .document(groupChatId)
                  .collection(groupChatId)
                  .orderBy("timestamp", descending: true)
                  .snapshots(),
              builder: (context, messageSnapshot) {
                //listMessage = messageSnapshot.data.documents;
                if (messageSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  final messageDocs = messageSnapshot.data.documents;
                  return ListView.builder(
                    itemBuilder: (context, index) => buildItemChat(
                      context,
                      index,
                      messageSnapshot.data.documents[index],
                      userId,
                      chatId,
                    ),
                    itemCount: messageSnapshot.data.documents.length,
                    reverse: true,
                    controller: scrollController,
                  );
                }
              },
            );
          }),
    );
  }

  Widget buildInput() {
    return Container(
      child: Row(
        children: <Widget>[
          // Button send image
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1.0),
              child: IconButton(
                icon: Icon(Icons.image),
                onPressed: getImage,
                color: Theme.of(context).primaryColor,
              ),
            ),
            color: Colors.white,
          ),
          // Edit text
          Flexible(
            child: Container(
              child: TextField(
                textInputAction: TextInputAction.newline,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 15.0),
                controller: textEditingController,
                decoration: InputDecoration.collapsed(
                  hintText: 'Type your message...',
                  hintStyle: TextStyle(color: Colors.grey[300]),
                ),
                focusNode: focusNode,
              ),
            ),
          ),

          // Button send message
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8.0),
              child: IconButton(
                icon: Icon(Icons.send),
                onPressed: () => onSendMessage(textEditingController.text, 0),
                color: Theme.of(context).primaryColor,
              ),
            ),
            color: Colors.white,
          ),
        ],
      ),
      width: double.infinity,
      height: 50.0,
      decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey[300], width: 0.5)),
          color: Colors.white),
    );
  }
}
