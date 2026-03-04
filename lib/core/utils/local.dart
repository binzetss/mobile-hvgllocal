import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Local {

  static saveLocal(String key, Object data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, jsonEncode(data));
  }

  static getLocal(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(key);
    if (data != null) {
      return jsonDecode(data);
    }
    return null;
  }

  static cleanLocalAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static cleanWithKey(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
}
