import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';

Settings settingsFromJson(String str) {
  final jsonData = json.decode(str);
  return Settings.fromJson(jsonData);
}

class Settings {
  String settingsID;

  Settings({
   this.settingsID,
  });

  factory Settings.fromJson(Map<String, dynamic> json) => new Settings(
    settingsID: json["settings_id"],
  );

  Map<String, dynamic> toJson() => {
    "setting_id": settingsID,
  };

  factory Settings.fromDocument(DocumentSnapshot doc) {
    return Settings.fromJson(doc.data);
  }
}