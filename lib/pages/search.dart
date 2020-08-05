import 'package:chat_app_v1/pages/chatScreen.dart';
import 'package:chat_app_v1/services/database.dart';
import 'package:chat_app_v1/services/helperFunctions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  AppBar appBar = AppBar(
    title: Text("Convo Chat"),
    centerTitle: false,
  );
  Map data;
  String myName = "";
  TextEditingController _controller = TextEditingController();
  DataBaseMethods _dataBaseMethods = DataBaseMethods();
  QuerySnapshot _querySnapshot;

  getOwnUserName() async {
    await HelperFucntions.getUserNameSharedPreference().then((value) {
      setState(() {
        myName = value;
      });
    });
  }

  searchUser() {
    _dataBaseMethods.getUserByUsername(_controller.text).then((val) {
      setState(() {
        _querySnapshot = val;
      });
    });
  }

  createChatroomAndStartConversation(String userName) {
    print("My name is : $myName");
    if (userName != myName) {
      String chatRoomId = getChatRoomId(userName, myName);
      List<String> users = {userName, myName}.toList();
      users.sort();
      Map<String, dynamic> chatRoomMap = {
        "users": users,
        "chatroomId": chatRoomId
      };
      _dataBaseMethods.createChatroom(chatRoomId, chatRoomMap);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              chatRoomId: chatRoomId,
            ),
          ));
    } else
      print("You cannot send messages to yourself");
    // Navigator.pushReplacementNamed(context, '')
  }

  Widget searchList() {
    return (_querySnapshot != null && _querySnapshot.documents.length != 0)
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: _querySnapshot.documents.length,
            itemBuilder: (context, index) {
              return userTile(
                name: _querySnapshot.documents[index].data["name"],
                email: _querySnapshot.documents[index].data["email"],
              );
            },
          )
        : Container(
            padding: EdgeInsets.all(20),
            child: Text("No results to show"),
          );
  }

  Widget userTile({String name, String email}) {
    return ListTile(
      title: Text(name),
      subtitle: Text(email),
      trailing: FlatButton(
        color: Colors.lightBlue[300],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        child: Text("Message"),
        onPressed: () {
          createChatroomAndStartConversation(name);
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getOwnUserName();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBar,
        body: Container(
          child: Column(
            children: <Widget>[
              searchList(),
              Spacer(),
              Container(
                height: 60,
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: TextField(
                          textAlignVertical: TextAlignVertical.center,
                          controller: _controller,
                          maxLines: null,
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 1,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        searchUser();
                        // Constants.myName = "hello";
                        // print(Constants.myName);
                      },
                      child: Container(
                        child: Icon(Icons.search),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

getChatRoomId(String a, String b) {
  int flag = a.compareTo(b);
  if (flag == 1)
    return "$b\_$a";
  else
    return "$a\_$b";
}
