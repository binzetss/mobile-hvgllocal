import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/services/firebase_notification_service.dart';
import '../data/models/reminder_model.dart';

class ReminderProvider extends ChangeNotifier {
  static const _prefsKey = 'hvgl_reminders';

  List<ReminderModel> _reminders = [];
  bool _loaded = false;

  List<ReminderModel> get reminders => _reminders;
  bool get isLoaded => _loaded;

                         
  Future<void> load() async {
    if (_loaded) return;
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsKey);
    if (raw != null) {
      final list = jsonDecode(raw) as List;
      _reminders = list
          .map((e) => ReminderModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    _loaded = true;
    notifyListeners();
  }


  Future<void> add(ReminderModel reminder) async {
    _reminders.add(reminder);
    await _persist();
    await FirebaseNotificationService().scheduleCustomReminder(reminder);
    notifyListeners();
  }

  Future<void> update(ReminderModel reminder) async {
    final idx = _reminders.indexWhere((r) => r.id == reminder.id);
    if (idx == -1) return;
    _reminders[idx] = reminder;
    await _persist();
    await FirebaseNotificationService().scheduleCustomReminder(reminder);
    notifyListeners();
  }

  Future<void> remove(String id) async {
    final reminder = _reminders.firstWhere((r) => r.id == id,
        orElse: () => throw StateError('not found'));
    await FirebaseNotificationService().cancelCustomReminder(reminder);
    _reminders.removeWhere((r) => r.id == id);
    await _persist();
    notifyListeners();
  }

  Future<void> toggle(String id) async {
    final idx = _reminders.indexWhere((r) => r.id == id);
    if (idx == -1) return;
    final updated = _reminders[idx].copyWith(
      isEnabled: !_reminders[idx].isEnabled,
    );
    _reminders[idx] = updated;
    await _persist();
    if (updated.isEnabled) {
      await FirebaseNotificationService().scheduleCustomReminder(updated);
    } else {
      await FirebaseNotificationService().cancelCustomReminder(updated);
    }
    notifyListeners();
  }
  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _prefsKey,
      jsonEncode(_reminders.map((r) => r.toJson()).toList()),
    );
  }

  static int generateNotifBaseId() {
    const base = 20000;
    const slots = 1400;
    return base + Random().nextInt(slots) * 7;
  }
}
