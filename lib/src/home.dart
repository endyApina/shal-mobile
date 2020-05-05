//import 'dart:html';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:Learn/src/signup.dart';
import 'package:Learn/src/loginPage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:Learn/src/services/authentication.dart';

class HomePage extends StatefulWidget {
  HomePage({this.auth});

  final BaseAuth auth;
  _HomePageState createState() => _HomePageState();
}

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  String _userID = "";

  @override
  void initState() {
    super.initState();
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        if (user != null) {
          _userID = user?.uid;
        }
        authStatus = user ?.uid == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
      });
    });
  }

  void _loginCallback() {
    setState(() {
      authStatus = AuthStatus.LOGGED_IN;
      _userID = "";
    });
  }

  Widget _buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _homePage() {
   return Scaffold(
     appBar: AppBar(
       title: Text('Home'),
       actions: <Widget>[
         IconButton(
           icon: Icon(
             Icons.exit_to_app,
             color: Colors.white,
           ),
           onPressed: () {
             FirebaseAuth auth = FirebaseAuth.instance;
             auth.signOut().then((res) {
               Navigator.pushReplacement(
                 context,
                 MaterialPageRoute(builder: (context) => SignUpPage()),
               );
             });
           },
         )
       ],
     ),
     body: Center(
       child: Text('Welcome to the Home page'),
     ),
   );
 }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    switch (authStatus) {
      case AuthStatus.NOT_DETERMINED:
        return _buildWaitingScreen();
        break;
      case AuthStatus.NOT_LOGGED_IN:
        return new LoginPage(
          auth: widget.auth,
          loginCallback: _loginCallback,
        );
        break;
      case AuthStatus.NOT_LOGGED_IN:
        if (_userID.length > 0 && _userID != null) {
          print(_userID);
          return _homePage();
        } else
          return _buildWaitingScreen();
        break;
      default:
        return _buildWaitingScreen();
    }
    _homePage();
  }

}