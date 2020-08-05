import 'package:chat_app_v1/Constants/Constants.dart';
import 'package:chat_app_v1/services/auth.dart';
import 'package:chat_app_v1/services/database.dart';
import 'package:chat_app_v1/services/helperFunctions.dart';
import 'package:flutter/material.dart';
import 'package:chat_app_v1/Constants/MyStyles.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController emailTextEditingController =
      TextEditingController();
  final TextEditingController usernameTextEditingController =
      TextEditingController();
  final TextEditingController passwordTextEditingController =
      TextEditingController();
  bool isLoading = false;

  AuthService authService = AuthService();
  DataBaseMethods _dataBaseMethods = DataBaseMethods();

  signUp() async {
    if (formKey.currentState.validate()) {
      Constants.myName = usernameTextEditingController.text;
      Map<String, String> userMap = {
        "name": usernameTextEditingController.text,
        "email": emailTextEditingController.text
      };
      HelperFucntions.setUserLoggedInSharedPreference(true);
      HelperFucntions.setUserNameSharedPreference(
          usernameTextEditingController.text);
      HelperFucntions.setUserEmailSharedPreference(
          emailTextEditingController.text);

      setState(() {
        isLoading = true;
      });

      _dataBaseMethods.uploadUserInfo(userMap);

      await authService
          .signUpWithEmailAndPassword(emailTextEditingController.text,
              passwordTextEditingController.text)
          .then((value) {
        if (value != null) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      });
    }
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
                            controller: usernameTextEditingController,
                            decoration: textFieldInputDecoration(
                                "Username", Icons.person),
                            validator: (value) {
                              return value.isEmpty || value.length < 4
                                  ? "Username = 3+ characters"
                                  : null;
                            },
                          ),
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
                              return value.length > 6
                                  ? null
                                  : "Length should be > 6 characters";
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
                              signUp();
                            },
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                "SignUp",
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
                                "SignUp with google",
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
                              "Already have an account? ",
                              style: My.textSmall,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushReplacementNamed(
                                    context, '/signIn');
                              },
                              child: Text(
                                "Sign In",
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
