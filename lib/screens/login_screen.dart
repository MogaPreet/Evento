import 'package:email_password_login/admin/dummy.dart';
import 'package:email_password_login/admin/event_form.dart';
import 'package:email_password_login/screens/blockedUser.dart';
import 'package:email_password_login/screens/chat/charMain.dart';
import 'package:email_password_login/screens/home.dart';
import 'package:email_password_login/screens/homescreen.dart';
import 'package:email_password_login/screens/registration_screen.dart';
import 'package:email_password_login/screens/resetPassword.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  //Firebasase
  final _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  String? errorMessage;
  SharedPreferences? logindata;
  bool? newuser;
  @override
  void initState() {
    // TODO: implement initState
    checkAuth();
    checkforblock();
    super.initState();
  }

  void checkAuth() async {
    logindata = await SharedPreferences.getInstance();
    newuser = (logindata!.getBool('login') ?? true);

    if (newuser == false) {
      Navigator.pushReplacement(
          context, new MaterialPageRoute(builder: (context) => MainScreen()));
    }
  }

  checkforblock() async {
    if (emailController.text == null) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.clear();
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const blockedUser()));
    }
  }

  @override
  Widget build(BuildContext context) {
    //forgot Password
    Widget forgotPassword(BuildContext context) {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: 35,
        alignment: Alignment.bottomRight,
        child: TextButton(
          child: Text(
            "Forget Password?",
            textAlign: TextAlign.right,
            style: TextStyle(
              color: Colors.blue,
            ),
          ),
          onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => ResetPassword())),
        ),
      );
    }

    final emailField = TextFormField(
      autofocus: false,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Please Enter Your Email");
        }
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
          return ("Please Enter Valid Email");
        }
        return null;
      },
      onSaved: (value) {
        emailController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.mail),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Email",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
    );

    final passwordField = TextFormField(
      autofocus: false,
      controller: passwordController,
      validator: (value) {
        RegExp regex = RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return ("Password is required for login");
        }
        if (!regex.hasMatch(value)) {
          return ("Please Enter Valid Password");
        }
        return null;
      },
      onSaved: (value) {
        passwordController.text = value!;
      },
      obscureText: true,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.lock),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Password",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
    );
    final loginButton = Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(5),
        color: Color.fromARGB(255, 0, 0, 0),
        child: MaterialButton(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () async {
            signIn(emailController.text, passwordController.text);
            logindata!.setBool('login', false);
            logindata!.setString('email', emailController.text);
          },
          child: _isLoading
              ? SizedBox(
                  width: 20.0,
                  height: 20.0,
                  child: const CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : const Text(
                  "Login",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ));

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(right: 15),
                        child: SizedBox(
                          width: 200.0,
                          child: Image.asset(
                            "assets/login.png",
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const SizedBox(height: 35),
                      emailField,
                      const SizedBox(height: 25),
                      passwordField,
                      const SizedBox(height: 35),
                      loginButton,
                      const SizedBox(height: 5),
                      forgotPassword(context),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text("Don't have an account? "),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const registration()));
                            },
                            child: const Text(
                              "Sign up",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.0,
                                  color: Colors.redAccent),
                            ),
                          )
                        ],
                      )
                    ],
                  )),
            ),
          ),
        ),
      ),
    );
  }

  //Login Function
  void signIn(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((uid) => {
                checkforblock(),
                Fluttertoast.showToast(msg: "Login Successfully"),
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => (email == "preetmoga777@gmail.com")
                        ? Dummy()
                        : MainScreen())),
              })
          .catchError((error) {
        switch (error.code) {
          case "invalid-email":
            errorMessage = "Your email address appears to be malformed.";

            break;
          case "wrong-password":
            errorMessage = "Your password is wrong.";
            break;
          case "user-not-found":
            errorMessage = "User with this email doesn't exist.";
            break;
          case "user-disabled":
            errorMessage = "User with this email has been disabled.";
            break;
          case "too-many-requests":
            errorMessage = "Too many requests";
            break;
          case "operation-not-allowed":
            errorMessage = "Signing in with Email and Password is not enabled.";
            break;
          default:
            errorMessage = "An undefined Error happened.";
        }

        setState(() {
          _isLoading = false;
        });
        Fluttertoast.showToast(msg: errorMessage!);
        print(error.code);
      });
    }
  }
}
