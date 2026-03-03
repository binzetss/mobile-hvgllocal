import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationSettingsProvider extends ChangeNotifier {
  static const String _keyAll = 'notif_all';
  static const String _keyChamCom = 'notif_cham_com';
  static const String _keyChamCong = 'notif_cham_cong';
  static const String _keyVanBan = 'notif_van_ban';
  static const String _keyLichTruc = 'notif_lich_truc';

  bool _allEnabled = true;
  bool _chamComEnabled = true;
  bool _chamCongEnabled = true;
  bool _vanBanEnabled = true;
  bool _lichTrucEnabled = true;

  bool get allEnabled => _allEnabled;
  bool get chamComEnabled => _chamComEnabled;
  bool get chamCongEnabled => _chamCongEnabled;
  bool get vanBanEnabled => _vanBanEnabled;
  bool get lichTrucEnabled => _lichTrucEnabled;

  NotificationSettingsProvider() {
    _loadFromPrefs();
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _allEnabled = prefs.getBool(_keyAll) ?? true;
    _chamComEnabled = prefs.getBool(_keyChamCom) ?? true;
    _chamCongEnabled = prefs.getBool(_keyChamCong) ?? true;
    _vanBanEnabled = prefs.getBool(_keyVanBan) ?? true;
    _lichTrucEnabled = prefs.getBool(_keyLichTruc) ?? true;
    notifyListeners();
  }

  Future<void> setAll(bool value) async {
    _allEnabled = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyAll, value);
  }

  Future<void> setChamCom(bool value) async {
    _chamComEnabled = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyChamCom, value);
  }

  Future<void> setChamCong(bool value) async {
    _chamCongEnabled = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyChamCong, value);
  }

  Future<void> setVanBan(bool value) async {
    _vanBanEnabled = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyVanBan, value);
  }

  Future<void> setLichTruc(bool value) async {
    _lichTrucEnabled = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyLichTruc, value);
  }
}
