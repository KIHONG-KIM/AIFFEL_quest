import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MoodRepository {
  final String _mood = "기쁨";
  final SharedPreferences _preferences;

  MoodRepository(this._preferences);

  Future<void> setMood(String value) async {
    await _preferences.setString(_mood, value);
  }

  String getMood() {
    return _preferences.getString(_mood) ?? "상처";
  }
}

Map<String, Color> moodColors = {
  "기쁨": Colors.yellow,
  "슬픔": Colors.blue,
  "분노": Colors.red,
  "불안": Colors.orange,
  "당황": Colors.green,
  "상처": Colors.pinkAccent.shade100,
};
