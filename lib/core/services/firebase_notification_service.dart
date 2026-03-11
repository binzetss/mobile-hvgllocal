import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform, TargetPlatform;
import 'package:flutter/material.dart' show Color;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../constants/api_endpoints.dart';
import '../utils/token_manager.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('🔔 Background message: ${message.messageId}');
}

class FirebaseNotificationService {
  static final FirebaseNotificationService _instance =
      FirebaseNotificationService._internal();
  factory FirebaseNotificationService() => _instance;
  FirebaseNotificationService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;
  String? _fcmToken;

  String? get fcmToken => _fcmToken;
  Future<void> initialize() async {
    if (_initialized) return;
    if (kIsWeb) {
      _initialized = true;
      return;
    }

    try {
      await _initializeLocalNotifications();
      _initialized = true;

      // Cho phép FCM hiển thị banner khi app đang foreground (quan trọng cho iOS)
      await _firebaseMessaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      final settings = await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      if (settings.authorizationStatus != AuthorizationStatus.authorized &&
          settings.authorizationStatus != AuthorizationStatus.provisional) {
        return;
      }
      _fcmToken = await _firebaseMessaging.getToken();

      _firebaseMessaging.onTokenRefresh.listen((newToken) {
        _fcmToken = newToken;
      });

      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
      FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

      final initialMessage = await _firebaseMessaging.getInitialMessage();
      if (initialMessage != null) {
        _handleNotificationTap(initialMessage);
      }
    } catch (e) {
      print('❌ Firebase init error: $e');
    }
  }

  Future<void> _initializeLocalNotifications() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      final androidPlugin = _localNotifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      await androidPlugin?.requestNotificationsPermission();

      const channel = AndroidNotificationChannel(
        'chamcong_channel',
        'Chấm công',
        description: 'Thông báo chấm công và hoạt động nội bộ',
        importance: Importance.max,
        playSound: true,
        enableVibration: true,
      );
      await androidPlugin?.createNotificationChannel(channel);

      const reminderChannel = AndroidNotificationChannel(
        'reminder_channel',
        'Nhắc nhở chấm công',
        description: 'Nhắc nhở chấm công hàng ngày',
        importance: Importance.high,
        playSound: true,
        enableVibration: true,
      );
      await androidPlugin?.createNotificationChannel(reminderChannel);
    }
  }

  void _handleForegroundMessage(RemoteMessage message) {
    print(' Foreground message: ${message.messageId}');

    final notification = message.notification;
    if (notification != null) {
      _showLocalNotification(
        title: notification.title ?? 'Thông báo',
        body: notification.body ?? '',
        payload: message.data.toString(),
      );
    }
  }

  Future<void> _showLocalNotification({
    required String title,
    required String body,
    String? payload,
    String channelId = 'chamcong_channel',
  }) async {
    const largeIcon = DrawableResourceAndroidBitmap('@mipmap/ic_launcher');
    final androidDetails = AndroidNotificationDetails(
      channelId,
      channelId == 'chamcong_channel' ? 'Chấm công' : 'Thông báo quan trọng',
      channelDescription: 'Thông báo chấm công và hoạt động nội bộ',
      importance: Importance.max,
      priority: Priority.max,
      showWhen: true,
      playSound: true,
      enableVibration: true,
      icon: '@drawable/ic_notification',
      largeIcon: largeIcon,
      color: const Color(0xFF1877F2),
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final id = DateTime.now().millisecondsSinceEpoch % 100000;

    await _localNotifications.show(id, title, body, details, payload: payload);
  }

  void _handleNotificationTap(RemoteMessage message) {
    print('👆 Notification tapped: ${message.messageId}');
    print('📦 Data: ${message.data}');

  }

  void _onNotificationTapped(NotificationResponse response) {
    print('👆 Local notification tapped: ${response.payload}');

  }

  Future<void> showChamcongNotification({
    required DateTime time,
    String loai = 'Chấm công',
  }) async {
    if (kIsWeb) return;
    // Tự khởi động lại nếu chưa được initialized (iOS edge case)
    if (!_initialized) {
      await initialize();
    }
    try {
      final timeStr = DateFormat('HH:mm').format(time);
      final dateStr = DateFormat('dd/MM/yyyy').format(time);
      await _showLocalNotification(
        title: '$loai thành công',
        body: 'Bạn đã $loai lúc $timeStr ngày $dateStr',
      );
    } catch (e) {
      print('❌ showChamcongNotification error: $e');
    }
  }

  Future<void> subscribeToTopic(String topic) async {
    try {
      await _firebaseMessaging.subscribeToTopic(topic);
      print('✅ Subscribed to topic: $topic');
    } catch (e) {
      print('❌ Failed to subscribe to topic: $e');
    }
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic(topic);
      print('✅ Unsubscribed from topic: $topic');
    } catch (e) {
      print('❌ Failed to unsubscribe from topic: $e');
    }
  }

  // ─── Nhắc nhở chấm công hàng ngày ───────────────────────────────────────

  static const int _idNhacSangVao   = 2001; // 06:50 - nhắc vào ca sáng
  static const int _idNhacSangRa    = 2002; // 11:32 - nhắc ra ca sáng
  static const int _idNhacChieuVao  = 2003; // 12:55 - nhắc vào ca chiều
  static const int _idNhacChieuRa1  = 2004; // 16:32 - nhắc ra ca chiều (ca 16:30)
  static const int _idNhacChieuRa2  = 2005; // 17:02 - nhắc ra ca chiều (ca 17:00)

  Future<void> scheduleWorkReminders() async {
    if (kIsWeb || !_initialized) return;
    await cancelWorkReminders();

    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'reminder_channel',
        'Nhắc nhở chấm công',
        channelDescription: 'Nhắc nhở chấm công hàng ngày',
        importance: Importance.high,
        priority: Priority.high,
        icon: '@drawable/ic_notification',
        playSound: true,
        enableVibration: true,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: false,
        presentSound: true,
      ),
    );

    await _scheduleDaily(_idNhacSangVao,  'Nhắc chấm công vào ca sáng',  'Ca sáng bắt đầu lúc 07:00 - Đừng quên chấm công!',   6, 50, details);
    await _scheduleDaily(_idNhacSangRa,   'Nhắc chấm công ra ca sáng',   'Ca sáng kết thúc lúc 11:30 - Đừng quên chấm công ra!', 11, 32, details);
    await _scheduleDaily(_idNhacChieuVao, 'Nhắc chấm công vào ca chiều', 'Ca chiều bắt đầu lúc 13:00 - Đừng quên chấm công!',   12, 55, details);
    await _scheduleDaily(_idNhacChieuRa1, 'Nhắc chấm công ra ca chiều',  'Ca chiều kết thúc lúc 16:30 - Đừng quên chấm công ra!', 16, 32, details);
    await _scheduleDaily(_idNhacChieuRa2, 'Nhắc chấm công ra ca chiều',  'Ca chiều kết thúc lúc 17:00 - Đừng quên chấm công ra!', 17,  2, details);

    print('✅ Đã lên lịch 5 thông báo nhắc chấm công hàng ngày');
  }

  Future<void> _scheduleDaily(int id, String title, String body,
      int hour, int minute, NotificationDetails details) async {
    try {
      await _localNotifications.zonedSchedule(
        id,
        title,
        body,
        _nextInstanceOfTime(hour, minute),
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    } catch (e) {
      print('❌ _scheduleDaily($hour:$minute) error: $e');
    }
  }

  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduled =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }

  Future<void> cancelWorkReminders() async {
    await _localNotifications.cancel(_idNhacSangVao);
    await _localNotifications.cancel(_idNhacSangRa);
    await _localNotifications.cancel(_idNhacChieuVao);
    await _localNotifications.cancel(_idNhacChieuRa1);
    await _localNotifications.cancel(_idNhacChieuRa2);
    print('🗑️ Đã hủy thông báo nhắc chấm công');
  }

  // ─────────────────────────────────────────────────────────────────────────

  Future<void> sendTokenToServer({required String maSo}) async {
    if (_fcmToken == null || maSo.isEmpty) return;
    try {
      final tokenManager = TokenManager();
      final authToken = await tokenManager.getToken();
      final response = await http.post(
        Uri.parse(ApiEndpoints.fcmToken),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          if (authToken != null && authToken.isNotEmpty)
            'Authorization': 'Bearer $authToken',
        },
        body: jsonEncode({
          'maSo': maSo,
          'fcmToken': _fcmToken,
          'platform': defaultTargetPlatform == TargetPlatform.iOS ? 'ios' : 'android',
        }),
      );
      if (response.statusCode == 200) {
        print('✅ FCM token registered: $_fcmToken');
      } else {
        print('⚠️ FCM token register failed: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ sendTokenToServer error: $e');
    }
  }
}
