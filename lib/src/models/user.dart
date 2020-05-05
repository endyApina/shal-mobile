import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

User userFromJson(String str) {
  final jsonData = json.decode(str);
  return User.fromJson(jsonData);
}

String userToJson(User data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class User {
  String userID;
  String fullName;
  String email;

  User({
    this.userID,
    this.fullName,
    this.email,
});

  factory User.fromJson(Map<String, dynamic> json) => new User(
    userID: json["user_id"],
    fullName: json["full_name"],
    email: json["email"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userID,
    "full_name": fullName,
    "email": email,
  };

  factory User.fromDocument(DocumentSnapshot doc) {
    return User.fromJson(doc.data);
  }
}

