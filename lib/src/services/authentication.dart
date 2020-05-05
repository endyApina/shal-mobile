import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Learn/src/models/user.dart';
import 'package:Learn/src/models/settings.dart';

abstract class BaseAuth {
  Future <String> signIn(String email, String password);

  Future <String> signUp(String email, String password);

  Future<FirebaseUser> getCurrentUser();

  Future <void> sendEmailVerification();

  Future <void> signOut();

  Future <bool> isEmailVerified();

  Future <void> addUserSettingsDB(User user);
  
  Future <bool> checkUserExist(String userID);

  Future <void> addSettings(Settings settings);
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String> signIn(String email, String password) async {
    AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password
    );
    FirebaseUser user = result.user;
    return user.uid;
  }

  Future<String> signUp(String email, String password) async {
    AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password
    );
    FirebaseUser user = result.user;
    return user.uid;
  }

  Future <FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  Future<void> sendEmailVerification() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    user.sendEmailVerification();
  }

  Future<bool> isEmailVerified() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.isEmailVerified;
  }

  Future<void> addUserSettingsDB(User user) async {
    checkUserExist(user.userID).then((value) {
      if (!value) {
        print("user ${user.fullName} ${user.email} added");
        Firestore.instance.document("users/${user.userID}").setData(user.toJson());
        addSettings(new Settings(
          settingsID: user.userID,
        ));
      } else {
        print("user ${user.fullName} ${user.email} exists");
      }
    }); 
  }

  Future <void> addSettings(Settings settings) async {
    Firestore.instance.document("settings/${settings.settingsID}").setData(settings.toJson());
  }
  
  Future<bool> checkUserExist(String userID) async {
    bool exists = false;
    try {
      await Firestore.instance.document("user/$userID").get().then((doc) {
        if (doc.exists)
          exists = true;
        else
          exists = false;
      });
      return exists;
    } catch (e) {
      return false;
    }
  }
}