import 'package:chat_app_v1/Constants/Constants.dart';
import 'package:chat_app_v1/Constants/MyStyles.dart';
import 'package:chat_app_v1/services/auth.dart';
import 'package:chat_app_v1/services/database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'chatScreen.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  AuthService authService = AuthService();
  DataBaseMethods dataBaseMethods = DataBaseMethods();
  Stream chatRoomsStream;
  bool isLoading = true;
  Widget chatRoomList() {
    return StreamBuilder(
      stream: chatRoomsStream,
      builder: (context, snapshot) {
        return ListView.separated(
          shrinkWrap: true,
          separatorBuilder: (context, index) {
            return Divider(
              color: Colors.black,
            );
          },
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context, index) {
            return ChatScreenTile(
              chatroomId: snapshot.data.documents[index].data["chatroomId"],
            );
          },
        );
      },
    );
  }

  loader() async {
    await dataBaseMethods.getChatRooms(Constants.myName).then((value) {
      setState(() {
        chatRoomsStream = value;
        isLoading = false;
      });
    });
  }

  _signOut() async {
    await authService.signOut().then((value) {
      print("Signed out\nMessage : ${value.toString()}");
    });
    Navigator.pushReplacementNamed(context, '/signIn');
  }

  justcheck() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getBool("ISLOGGEDIN").toString());
    print(prefs.getString("USERNAMEKEY"));
    print(prefs.getString("USEREMAILKEY"));
  }

  @override
  void initState() {
    super.initState();
    // justcheck();
    loader();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text("Convo Chat"),
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              _signOut();
            },
            child: Container(
              padding: EdgeInsets.only(left: 5, right: 10),
              child: Icon(
                Icons.exit_to_app,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/search');
        },
        child: Icon(Icons.search),
      ),
      body: isLoading ? Container() : chatRoomList(),
    );
  }
}

class ChatScreenTile extends StatelessWidget {
  final String chatroomId;
  ChatScreenTile({this.chatroomId});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.lightBlue[100],
      child: ListTile(
        contentPadding: EdgeInsets.all(10),
        leading: Container(
          height: 40,
          width: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.lightBlue[100],
            border: Border.all(
              color: Colors.black,
              width: 1,
            ),
            shape: BoxShape.circle,
          ),
          child: Text(
            chatroomId.substring(0, 1).toUpperCase(),
            style: My.textMedium,
          ),
        ),
        title: Text(
            chatroomId.replaceAll(r'_', '').replaceAll(Constants.myName, "")),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatScreen(
                  chatRoomId: chatroomId,
                ),
              ));
        },
      ),
    );
  }
}
