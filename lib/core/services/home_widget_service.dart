import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class HomeWidgetService {
  static const _channel = MethodChannel('vn.hvgl.noibo/widget');

  static Future<void> init() async {}

  static Future<void> saveUserName(String name) async {
    if (kIsWeb) return;
    try {
      await _channel.invokeMethod<void>('updateWidget', {'user_name': name});
    } catch (e) {
      debugPrint('HomeWidget saveUserName error: $e');
    }
  }

  static Future<void> updateAttendance({
    required String? checkin,
    required String? checkout,
  }) async {
    if (kIsWeb) return;
    try {
      await _channel.invokeMethod<void>('updateWidget', {
        'checkin': checkin ?? '--',
        'checkout': checkout ?? '--',
      });
    } catch (e) {
      debugPrint('HomeWidget updateAttendance error: $e');
    }
  }
}
