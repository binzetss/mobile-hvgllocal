import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform, TargetPlatform;
import 'package:flutter/material.dart' show Color;
import 'package:flutter/widgets.dart' show WidgetsBinding;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../constants/api_endpoints.dart';
import '../navigation/navigator_key.dart';
import '../routes/app_routes.dart';
import '../utils/token_manager.dart';
import '../../data/models/reminder_model.dart';
import '../../firebase_options.dart';

/// Chạy trong isolate riêng khi app bị tắt/background.
/// Phải tự khởi tạo và hiển thị notification vì không có UI context.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Lấy title/body từ notification payload hoặc data payload
  final title = message.notification?.title
      ?? message.data['title'] as String?
      ?? 'Thông báo HVGL';
  final body  = message.notification?.body
      ?? message.data['body'] as String?
      ?? '';

  if (title.isEmpty && body.isEmpty) return;

  // Khởi tạo local notifications trong isolate
  final plugin = FlutterLocalNotificationsPlugin();
  const androidInit = AndroidInitializationSettings('@drawable/ic_notification');
  const iosInit = DarwinInitializationSettings();
  await plugin.initialize(const InitializationSettings(android: androidInit, iOS: iosInit));

  // Tạo channel (bắt buộc Android 8+)
  final androidPlugin = plugin.resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>();
  await androidPlugin?.createNotificationChannel(const AndroidNotificationChannel(
    'chamcong_channel',
    'Chấm công',
    description: 'Thông báo chấm công và hoạt động nội bộ',
    importance: Importance.max,
  ));

  const details = NotificationDetails(
    android: AndroidNotificationDetails(
      'chamcong_channel',
      'Chấm công',
      channelDescription: 'Thông báo chấm công và hoạt động nội bộ',
      importance: Importance.max,
      priority: Priority.max,
      icon: '@drawable/ic_notification',
      color: Color(0xFF1877F2),
      playSound: true,
      enableVibration: true,
    ),
    iOS: DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    ),
  );

  final id = DateTime.now().millisecondsSinceEpoch % 100000;
  await plugin.show(id, title, body, details,
      payload: message.data['screen'] as String?);
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

      await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      // Lấy FCM token bất kể user có cấp quyền hay không
      // (token dùng để server push, không liên quan quyền hiện thông báo)
      _fcmToken = await _firebaseMessaging.getToken();

      _firebaseMessaging.onTokenRefresh.listen((newToken) {
        _fcmToken = newToken;
        _registerTokenToServer(newToken);
      });

      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
      FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

      final initialMessage = await _firebaseMessaging.getInitialMessage();
      if (initialMessage != null) {
        // App vừa mở từ notification — delay để Navigator kịp mount
        Future.delayed(const Duration(milliseconds: 1200), () {
          _handleNotificationTap(initialMessage);
        });
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

      // Kênh báo thức — dùng âm thanh alarm hệ thống
      final alarmChannel = AndroidNotificationChannel(
        'alarm_channel',
        'Báo thức nhắc nhở',
        description: 'Báo thức nhắc nhở do người dùng đặt',
        importance: Importance.max,
        playSound: true,
        sound: const UriAndroidNotificationSound(
            'content://settings/system/alarm_alert'),
        enableVibration: true,
        enableLights: true,
      );
      await androidPlugin?.createNotificationChannel(alarmChannel);

      // Kênh thông báo thường (giữ lại cho tương thích)
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
    final screen = message.data['screen'] as String?;
    if (screen == null) return;
    // Dùng addPostFrameCallback để đảm bảo navigator đã sẵn sàng
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _navigateToScreen(screen);
    });
  }

  void _onNotificationTapped(NotificationResponse response) {
    final payload = response.payload;
    if (payload == null || payload.isEmpty) return;
    // Payload là screen name (ví dụ: '/chamcong', '/reminder')
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _navigateToScreen(payload);
    });
  }

  void _navigateToScreen(String screen) {
    final nav = appNavigatorKey.currentState;
    if (nav == null) return;
    switch (screen) {
      case 'chamcong':
      case 'chamtruc':
        nav.pushNamedAndRemoveUntil(AppRoutes.home, (r) => false);
      case 'reminder':
        nav.pushNamed(AppRoutes.reminder);
      case 'documents':
        nav.pushNamed(AppRoutes.documents);
      case 'profile':
        nav.pushNamed(AppRoutes.profile);
      case 'daotao':
        nav.pushNamed(AppRoutes.daotao);
      case 'clinicSchedule':
        nav.pushNamed(AppRoutes.clinicSchedule);
      default:
        nav.pushNamedAndRemoveUntil(AppRoutes.home, (r) => false);
    }
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

    final details = _alarmDetails;

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
        androidScheduleMode: AndroidScheduleMode.alarmClock,
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

  // ─── Custom reminders ────────────────────────────────────────────────────

  // Dùng getter thay vì const vì UriAndroidNotificationSound không const
  static NotificationDetails get _alarmDetails => NotificationDetails(
    android: AndroidNotificationDetails(
      'alarm_channel',
      'Báo thức nhắc nhở',
      channelDescription: 'Báo thức nhắc nhở do người dùng đặt',
      importance: Importance.max,
      priority: Priority.max,
      icon: '@drawable/ic_notification',
      playSound: true,
      sound: const UriAndroidNotificationSound(
          'content://settings/system/alarm_alert'),
      enableVibration: true,
      enableLights: true,
      fullScreenIntent: true,                    // Hiện khi màn hình khóa
      category: AndroidNotificationCategory.alarm, // Hành xử như báo thức
      audioAttributesUsage: AudioAttributesUsage.alarm, // Dùng luồng âm alarm
    ),
    iOS: const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: false,
      presentSound: true,
      interruptionLevel: InterruptionLevel.timeSensitive, // Xuyên qua chế độ tập trung
    ),
  );

  /// Schedule (or reschedule) all notifications for [reminder].
  Future<void> scheduleCustomReminder(ReminderModel reminder) async {
    if (kIsWeb || !_initialized) return;
    await cancelCustomReminder(reminder);
    if (!reminder.isEnabled) return;

    final days = reminder.repeatDays.isEmpty
        ? [1, 2, 3, 4, 5, 6, 7]
        : reminder.repeatDays;

    for (final day in days) {
      final id = reminder.notifBaseId + day;
      try {
        await _localNotifications.zonedSchedule(
          id,
          reminder.title,
          reminder.note?.isNotEmpty == true
              ? reminder.note!
              : 'Nhắc nhở lúc ${reminder.timeLabel}',
          _nextInstanceOfWeekdayAndTime(day, reminder.hour, reminder.minute),
          _alarmDetails,
          androidScheduleMode: AndroidScheduleMode.alarmClock, // Chế độ báo thức thật sự
          matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
        );
      } catch (e) {
        print('❌ scheduleCustomReminder($day) error: $e');
      }
    }
  }

  /// Cancel all notifications belonging to [reminder].
  Future<void> cancelCustomReminder(ReminderModel reminder) async {
    if (kIsWeb) return;
    for (int day = 1; day <= 7; day++) {
      await _localNotifications.cancel(reminder.notifBaseId + day);
    }
  }

  tz.TZDateTime _nextInstanceOfWeekdayAndTime(int weekday, int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime dt =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    // Advance until we land on the correct weekday, and the time is in the future.
    for (int i = 0; i < 8; i++) {
      if (dt.weekday == weekday && dt.isAfter(now)) break;
      dt = dt.add(const Duration(days: 1));
    }
    return dt;
  }

  // ─── Debug / Test ────────────────────────────────────────────────────────

  /// Test báo thức sau [seconds] giây — tắt app rồi chờ
  Future<void> scheduleTestAlarm({int seconds = 10}) async {
    if (kIsWeb || !_initialized) return;
    final triggerTime =
        tz.TZDateTime.now(tz.local).add(Duration(seconds: seconds));
    await _localNotifications.zonedSchedule(
      9999,
      '🔔 Test báo thức',
      'Báo thức kêu sau $seconds giây — hoạt động khi tắt app!',
      triggerTime,
      _alarmDetails,
      androidScheduleMode: AndroidScheduleMode.alarmClock,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  // ─────────────────────────────────────────────────────────────────────────

  /// Gọi sau khi đăng nhập thành công — token đã có trong _fcmToken
  Future<void> sendTokenToServer() async {
    if (_fcmToken == null) return;
    await _registerTokenToServer(_fcmToken!);
  }

  Future<void> _registerTokenToServer(String token) async {
    try {
      final authToken = await TokenManager().getToken();
      if (authToken == null || authToken.isEmpty) return;
      final response = await http.post(
        Uri.parse(ApiEndpoints.fcmToken),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: jsonEncode({
          'fcmToken': token,
          'platform': defaultTargetPlatform == TargetPlatform.iOS ? 'ios' : 'android',
        }),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ FCM token registered');
      } else {
        print('⚠️ FCM register failed: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ _registerTokenToServer error: $e');
    }
  }

  /// Gửi thông báo đến một nhân viên cụ thể qua server
  Future<bool> sendNotification({
    required String maSo,
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    try {
      final authToken = await TokenManager().getToken();
      if (authToken == null || authToken.isEmpty) return false;
      final response = await http.post(
        Uri.parse(ApiEndpoints.sendNotification),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: jsonEncode({
          'maSo': maSo,
          'title': title,
          'body': body,
          'data': data,
        }),
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('❌ sendNotification error: $e');
      return false;
    }
  }

  /// Gọi khi đăng xuất — xóa token khỏi server
  Future<void> deleteFcmToken() async {
    try {
      final authToken = await TokenManager().getToken();
      if (authToken == null || authToken.isEmpty) return;
      await http.delete(
        Uri.parse(ApiEndpoints.fcmToken),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );
      print('✅ FCM token deleted');
    } catch (e) {
      print('❌ deleteFcmToken error: $e');
    }
  }
}
