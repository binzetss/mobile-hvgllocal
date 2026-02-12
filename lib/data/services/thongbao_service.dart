import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/thongbao_model.dart';

class ThongBaoService {
  static final ThongBaoService _instance = ThongBaoService._internal();
  factory ThongBaoService() => _instance;
  ThongBaoService._internal();

  static const String _storageKey = 'notifications';
  static const String _notifiedVanbanKey = 'notified_vanban_ids';
  static const int _maxNotifications = 100;
  Future<void> _saveNotifications(List<ThongBao> notifications) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = notifications.map((tb) => tb.toJson()).toList();
      await prefs.setString(_storageKey, jsonEncode(jsonList));
    } catch (e) {
      debugPrint('Error saving notifications: $e');
    }
  }
  Future<List<ThongBao>> _loadNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_storageKey);

      if (jsonString == null) {
        return [];
      }

      final jsonList = jsonDecode(jsonString) as List;
      return jsonList
          .map((json) => ThongBao.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('Error loading notifications: $e');
      return [];
    }
  }
  Future<List<ThongBao>> getAll() async {
    final notifications = await _loadNotifications();

    // Lọc chỉ lấy thông báo trong 7 ngày gần nhất
    final now = DateTime.now();
    final sevenDaysAgo = now.subtract(const Duration(days: 7));
    final recentNotifications = notifications.where((notification) {
      return notification.time.isAfter(sevenDaysAgo);
    }).toList();

    // Lưu lại danh sách đã lọc (xóa thông báo cũ)
    if (recentNotifications.length != notifications.length) {
      await _saveNotifications(recentNotifications);
    }

    // Sắp xếp: MỚI NHẤT lên đầu (descending by time)
    recentNotifications.sort((a, b) {
      // b sau a (b > a) => trả về dương => b lên trước a
      return b.time.compareTo(a.time);
    });

    return recentNotifications;
  }
  Future<void> addNotification(ThongBao notification) async {
    var notifications = await _loadNotifications();
    notifications.insert(0, notification);
    if (notifications.length > _maxNotifications) {
      notifications = notifications.take(_maxNotifications).toList();
    }

    await _saveNotifications(notifications);
  }
  Future<Set<String>> getNotifiedVanbanIds() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_notifiedVanbanKey);
      if (jsonString == null) return {};
      final list = jsonDecode(jsonString) as List;
      return list.map((e) => e.toString()).toSet();
    } catch (e) {
      debugPrint('Error loading notified vanban IDs: $e');
      return {};
    }
  }

  Future<void> saveNotifiedVanbanIds(Set<String> ids) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_notifiedVanbanKey, jsonEncode(ids.toList()));
    } catch (e) {
      debugPrint('Error saving notified vanban IDs: $e');
    }
  }

  Future<void> addNotifiedVanbanId(String id) async {
    final ids = await getNotifiedVanbanIds();
    ids.add(id);
    if (ids.length > 500) {
      final limitedIds = ids.toList().sublist(ids.length - 500).toSet();
      await saveNotifiedVanbanIds(limitedIds);
    } else {
      await saveNotifiedVanbanIds(ids);
    }
  }

  Future<bool> isVanbanNotified(String documentId) async {
    final ids = await getNotifiedVanbanIds();
    return ids.contains(documentId);
  }

  Future<bool> createVanbanNotification({
    required String documentId,
    required String documentName,
    required String category,
    required DateTime publishedDate,
  }) async {
    // Kiểm tra đã thông báo chưa
    if (await isVanbanNotified(documentId)) {
      return false;
    }

    // TEMP: Kiểm tra trong vòng 10 ngày gần nhất (để test)
    // TODO: Đổi lại thành kiểm tra HÔM NAY sau khi test xong
    final now = DateTime.now();
    final difference = now.difference(publishedDate);

    if (difference.inDays > 10) {
      debugPrint('Skipping notification for old document: $documentName (date: $publishedDate)');
      // Đánh dấu đã xem để không tạo thông báo lần sau
      await addNotifiedVanbanId(documentId);
      return false;
    }

    final notification = ThongBao(
      id: 'vb_${documentId}_${publishedDate.millisecondsSinceEpoch}',
      title: 'Văn bản mới: $category',
      content: documentName,
      type: 'vanban',
      time: publishedDate,
      isRead: false,
      extraData: {
        'documentId': documentId,
        'category': category,
      },
    );

    await addNotification(notification);
    await addNotifiedVanbanId(documentId);
    return true;
  }
  Future<List<ThongBao>> getUnread() async {
    final all = await getAll();
    return all.where((tb) => !tb.isRead).toList();
  }

  Future<int> getUnreadCount() async {
    final unread = await getUnread();
    return unread.length;
  }
  Future<bool> markAsRead(String id) async {
    try {
      final notifications = await _loadNotifications();
      final index = notifications.indexWhere((tb) => tb.id == id);

      if (index != -1) {
        notifications[index] = notifications[index].copyWith(isRead: true);
        await _saveNotifications(notifications);
        return true;
      }

      return false;
    } catch (e) {
      debugPrint('Error marking notification as read: $e');
      return false;
    }
  }
  Future<bool> markAllAsRead() async {
    try {
      final notifications = await _loadNotifications();
      final updatedNotifications =
          notifications.map((tb) => tb.copyWith(isRead: true)).toList();
      await _saveNotifications(updatedNotifications);
      return true;
    } catch (e) {
      debugPrint('Error marking all as read: $e');
      return false;
    }
  }
  Future<bool> delete(String id) async {
    try {
      final notifications = await _loadNotifications();
      notifications.removeWhere((tb) => tb.id == id);
      await _saveNotifications(notifications);
      return true;
    } catch (e) {
      debugPrint('Error deleting notification: $e');
      return false;
    }
  }
  Future<void> clearAll() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_storageKey);
      await prefs.remove(_notifiedVanbanKey); // Xóa cả danh sách đã thông báo
    } catch (e) {
      debugPrint('Error clearing notifications: $e');
    }
  }
}
