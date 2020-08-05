import 'package:chat_app_v1/pages/chatScreen.dart';
import 'package:chat_app_v1/pages/home.dart';
import 'package:chat_app_v1/pages/loading.dart';
import 'package:chat_app_v1/pages/search.dart';
import 'package:chat_app_v1/pages/signIn.dart';
import 'package:chat_app_v1/pages/signUp.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat App',
      initialRoute: '/loading',
      routes: {
        '/signIn': (context) => SignIn(),
        '/signUp': (context) => SignUp(),
        '/home': (context) => Home(),
        '/search': (context) => Search(),
        '/chatScreen': (context) => ChatScreen(),
        '/loading': (context) => Loading(),
      },
    );
  }
}
