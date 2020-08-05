import 'package:chat_app_v1/Constants/Constants.dart';
import 'package:chat_app_v1/services/helperFunctions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  bool isLoggedIn = false;
  whereToLand() async {
    await HelperFucntions.getUserLoggedInSharedPreference().then((value) {
      if (value) {
        HelperFucntions.getUserNameSharedPreference().then((value) {
          Constants.myName = value;
          Future.delayed(Duration(seconds: 2)).then((value) {
            Navigator.pushNamed(context, "/home");
          });
        });
      } else
        Future.delayed(Duration(seconds: 2)).then((value) {
          Navigator.pushNamed(context, "/signIn");
        });
    });
  }

  @override
  void initState() {
    super.initState();
    whereToLand();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SpinKitCubeGrid(
          color: Colors.purple[100],
          size: 50.0,
        ),
      ),
    );
  }
}
