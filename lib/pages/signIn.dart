import 'package:chat_app_v1/Constants/Constants.dart';
import 'package:chat_app_v1/services/auth.dart';
import 'package:chat_app_v1/services/database.dart';
import 'package:chat_app_v1/services/helperFunctions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chat_app_v1/Constants/MyStyles.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController emailTextEditingController =
      TextEditingController();
  final TextEditingController passwordTextEditingController =
      TextEditingController();
  bool isLoading = false;
  AuthService authService = AuthService();
  DataBaseMethods dataBaseMethods = DataBaseMethods();

  signIn() async {
    if (formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      await authService
          .signInWithEmailAndPassword(emailTextEditingController.text,
              passwordTextEditingController.text)
          .then((value) async {
        if (value != null) {
          QuerySnapshot userInfoSnapshot = await dataBaseMethods
              .getUserByUserEmail(emailTextEditingController.text);
          HelperFucntions.setUserLoggedInSharedPreference(true);
          HelperFucntions.setUserEmailSharedPreference(
              userInfoSnapshot.documents[0].data["email"]);
          HelperFucntions.setUserNameSharedPreference(
              userInfoSnapshot.documents[0].data["name"]);
          Constants.myName = userInfoSnapshot.documents[0].data["name"];
          Navigator.pushReplacementNamed(context, '/home');
        }
      });
    }
  }

  clearShared() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  @override
  void initState() {
    super.initState();
    clearShared();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : SafeArea(
            child: Scaffold(
              backgroundColor: Colors.white,
              body: Container(
                padding: EdgeInsets.all(40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Form(
                      key: formKey,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            controller: emailTextEditingController,
                            decoration:
                                textFieldInputDecoration("E-Mail", Icons.email),
                            validator: (val) {
                              return RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(val)
                                  ? null
                                  : "Enter correct email";
                            },
                          ),
                          TextFormField(
                            obscureText: true,
                            controller: passwordTextEditingController,
                            decoration: textFieldInputDecoration(
                                "Password", Icons.vpn_key),
                            validator: (value) {
                              return value.length > 3
                                  ? null
                                  : "Length should be > 3 characters";
                            },
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.fromLTRB(10, 30, 10, 0),
                          child: GestureDetector(
                            onTap: () {
                              signIn();
                            },
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                "SignIn",
                                style: My.textMedium,
                              ),
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(
                                      color: Colors.black, width: 1)),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(10, 30, 10, 20),
                          child: GestureDetector(
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                "SignIn with google",
                                style: My.textMedium,
                              ),
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(
                                      color: Colors.black, width: 1)),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have account? ",
                              style: My.textSmall,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.popAndPushNamed(context, '/signUp');
                              },
                              child: Text(
                                "Register now",
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 16,
                                    decoration: TextDecoration.underline),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 50,
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
