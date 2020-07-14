import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:photo_view/photo_view.dart';

class Messages extends StatelessWidget {
  Messages(this.message, this.userName, this.userImage, this.isUser,
      {this.key});

  final Key key;
  final String message;
  final String userName;
  final String userImage;
  final bool isUser;

  @override
  Widget build(BuildContext context) {
    print(isUser.toString());
    return Stack(
      children: [
        Row(
          mainAxisAlignment:
              isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color:
                    isUser ? Colors.grey[300] : Theme.of(context).accentColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                  bottomLeft:
                      !isUser ? Radius.circular(0) : Radius.circular(12),
                  bottomRight:
                      isUser ? Radius.circular(0) : Radius.circular(12),
                ),
              ),
              width: 140,
              padding: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 16,
              ),
              margin: EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 8,
              ),
              child: Column(
                crossAxisAlignment:
                    isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    userName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isUser
                          ? Colors.black
                          : Theme.of(context).accentTextTheme.headline6.color,
                    ),
                  ),
                  Text(
                    message,
                    style: TextStyle(
                      color: isUser
                          ? Colors.black
                          : Theme.of(context).accentTextTheme.headline6.color,
                    ),
                    textAlign: isUser ? TextAlign.end : TextAlign.start,
                  ),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          top: 0,
          right: isUser ? 120 : null,
          left: isUser ? null : 120,
          child: CircleAvatar(
            backgroundImage: NetworkImage(userImage),
          ),
        ),
      ],
      overflow: Overflow.visible,
    );
  }
}

Widget buildItemChat(BuildContext context, int index,
    DocumentSnapshot documentSnapshot, userId, fromId) {
  var progressIndicator = CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(
          Theme.of(context).primaryColor)); //Right (user) message

  return LayoutBuilder(builder: (ctx, constraint) {
    return Stack(
      children: <Widget>[
        Row(
          mainAxisAlignment: userId == documentSnapshot["fromId"]
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: <Widget>[
            documentSnapshot["type"] == 0 //Text message
                ? Flexible(
                  child: Container(
                      decoration: BoxDecoration(
                          color: userId == documentSnapshot["fromId"]
                              ? Colors.grey[300]
                              : Theme.of(context).accentColor,
                          borderRadius: BorderRadius.circular(8)),
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      child: Column(
                        crossAxisAlignment: userId == documentSnapshot["fromId"]
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            documentSnapshot["content"],
                            style: TextStyle(
                              color: userId == documentSnapshot["fromId"]
                                  ? Colors.black
                                  : Theme.of(context)
                                      .accentTextTheme
                                      .headline6
                                      .color,
                            ),
                            textAlign: userId == documentSnapshot["fromId"]
                                ? TextAlign.start
                                : TextAlign.start,
                          ),
                        ],
                      ),
                      //width: constraint.maxWidth * 0.9,
                      margin: EdgeInsets.only(
                          bottom: /*isLastMessageRight(index) ? 20 :*/ 10,
                          right: 10),
                    ),
                )
                : Container(
                    //Image message
                    child: FlatButton(
                      child: Material(
                        child: CachedNetworkImage(
                          placeholder: (context, url) => Container(
                            child: progressIndicator,
                            width: 200,
                            height: 200,
                            padding: EdgeInsets.all(70.0),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              color: Colors.grey,
                            ),
                          ),
                          errorWidget: (context, url, error) => Material(
                            child: Image.asset(
                              "images/img_not_available.jpeg",
                              width: 200,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            clipBehavior: Clip.hardEdge,
                          ),
                          imageUrl: documentSnapshot["content"],
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        clipBehavior: Clip.hardEdge,
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PhotoView(
                                      imageProvider: NetworkImage(
                                          documentSnapshot["content"]),
                                    )));
                      },
                    ),
                    margin: EdgeInsets.only(
                        bottom: /*isLastMessageRight(index) ? 20 : */ 10,
                        right: 10),
                  ),
          ],
        ),
        //Container(),//TODO: Add time stamps
        /* Positioned(
          top: 0,
          right: isUser ? 120 : null,
          left: isUser ? null : 120,
          child: CircleAvatar(
            backgroundImage: NetworkImage(documentSnapshot["photoUrl"]),
          ),
        ),*/
      ],
      overflow: Overflow.visible,
    );
  });
}
