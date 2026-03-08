import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform, TargetPlatform;
import 'package:flutter/material.dart' show Color;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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
