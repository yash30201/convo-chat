import 'dart:math';

import 'package:chat_app_v1/Constants/Constants.dart';
import 'package:chat_app_v1/Constants/MyStyles.dart';
import 'package:chat_app_v1/services/database.dart';
import 'package:chat_app_v1/widgets/appBarMain.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String chatRoomId;
  ChatScreen({this.chatRoomId});
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController messageEditingController = TextEditingController();
  Stream chatMessageStream;
  DataBaseMethods _dataBaseMethods = DataBaseMethods();
  bool isLoading = true;

  Widget chatMessages() {
    return StreamBuilder(
      stream: chatMessageStream,
      builder: (context, snapshot) {
        int len = snapshot.data.documents.length;
        return ListView.builder(
          shrinkWrap: true,
          itemCount: len + 1,
          itemBuilder: (context, index) {
            if (index == len) {
              return SizedBox(
                height: 80,
              );
            } else
              return MessageTile(
                message: snapshot.data.documents[index].data["message"],
                sendByMe: snapshot.data.documents[index].data["sendBy"] ==
                    Constants.myName,
              );
          },
        );
      },
    );
  }

  sendMessage() {
    if (messageEditingController.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "message": messageEditingController.text,
        "sendBy": Constants.myName,
        "time": DateTime.now().millisecondsSinceEpoch
      };
      _dataBaseMethods.addConversationMessages(widget.chatRoomId, messageMap);
    }
  }

  @override
  void initState() {
    super.initState();
    _dataBaseMethods.getConversationMessages(widget.chatRoomId).then((value) {
      setState(() {
        chatMessageStream = value;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context, "Twisted Tempo"),
      body: Container(
        child: Stack(
          children: [
            isLoading ? Container() : chatMessages(),
            Container(
              alignment: Alignment.bottomCenter,
              width: MediaQuery.of(context).size.width,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                color: Color(0x54FFFFFF),
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                      controller: messageEditingController,
                      style: My.textMidSmall,
                      decoration: InputDecoration(
                          hintText: "Message ...",
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(
                            color: Colors.grey,
                            width: 1,
                          ))),
                    )),
                    SizedBox(
                      width: 16,
                    ),
                    GestureDetector(
                      onTap: () {
                        sendMessage();
                      },
                      child: Container(
                          child: Transform.rotate(
                        angle: pi / 4,
                        child: Image.asset(
                          "asset/images/send_icon.png",
                          height: 30,
                          width: 30,
                          fit: BoxFit.fitHeight,
                        ),
                      )),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool sendByMe;
  final double boxRadius = 20;
  final double marginVertical = 7;
  MessageTile({this.message, this.sendByMe});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: sendByMe
          ? EdgeInsets.only(
              bottom: marginVertical,
              top: marginVertical,
              right: 15,
            )
          : EdgeInsets.only(
              bottom: marginVertical,
              top: marginVertical,
              left: 15,
            ),
      width: MediaQuery.of(context).size.width,
      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: sendByMe ? Colors.cyan[100] : Colors.purple[50],
          borderRadius: sendByMe
              ? BorderRadius.only(
                  topLeft: Radius.circular(boxRadius),
                  bottomLeft: Radius.circular(boxRadius),
                  bottomRight: Radius.circular(boxRadius),
                )
              : BorderRadius.only(
                  topRight: Radius.circular(boxRadius),
                  bottomLeft: Radius.circular(boxRadius),
                  bottomRight: Radius.circular(boxRadius),
                ),
        ),
        child: Text(
          message,
          style: My.textMidSmall,
        ),
      ),
    );
  }
}
