import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class CacheService {
  static final CacheService _instance = CacheService._internal();
  factory CacheService() => _instance;
  CacheService._internal();

  static const String _staffCacheKey = 'staff_cache';
  static const String _departmentsCacheKey = 'departments_cache';
  static const String _timestampKey = 'cache_timestamp';
  static const Duration _cacheExpiry = Duration(hours: 24);

  Future<void> cacheStaff(List<Map<String, dynamic>> staffList) async {
    try {
      debugPrint('💾 CacheService: Đang lưu ${staffList.length} nhân viên (không bao gồm hình ảnh)...');
      final prefs = await SharedPreferences.getInstance();
      final jsonString = json.encode(staffList);
      final sizeInKB = (jsonString.length / 1024).toStringAsFixed(2);
      final success = await prefs.setString(_staffCacheKey, jsonString);
      await prefs.setInt(_timestampKey, DateTime.now().millisecondsSinceEpoch);
      debugPrint('💾 CacheService: Cache staff = $success (~$sizeInKB KB)');
    } catch (e) {
      debugPrint('❌ CacheService: Lỗi khi cache staff: $e');
    }
  }

  Future<List<Map<String, dynamic>>?> getCachedStaff() async {
    try {
      debugPrint('📦 CacheService: Đang đọc staff cache...');
      final prefs = await SharedPreferences.getInstance();

      final timestamp = prefs.getInt(_timestampKey);
      if (timestamp != null) {
        final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
        final now = DateTime.now();
        if (now.difference(cacheTime) > _cacheExpiry) {
          debugPrint('⏰ CacheService: Cache đã hết hạn (${now.difference(cacheTime).inHours}h)');
          return null;
        }
        debugPrint('📦 CacheService: Cache còn hạn (${now.difference(cacheTime).inMinutes} phút)');
      } else {
        debugPrint('📦 CacheService: Không có timestamp');
      }

      final jsonString = prefs.getString(_staffCacheKey);
      if (jsonString != null) {
        final sizeInKB = (jsonString.length / 1024).toStringAsFixed(2);
        debugPrint('📦 CacheService: Tìm thấy staff cache (~$sizeInKB KB)');
        final List<dynamic> jsonList = json.decode(jsonString);
        final staffList = jsonList.cast<Map<String, dynamic>>();
        debugPrint('📦 CacheService: Đã load ${staffList.length} nhân viên từ cache (hình ảnh sẽ load từ API)');
        return staffList;
      } else {
        debugPrint('📦 CacheService: Không có staff cache');
      }
    } catch (e) {
      debugPrint('❌ CacheService: Lỗi khi đọc cache staff: $e');
    }
    return null;
  }

  Future<void> cacheDepartments(List<Map<String, dynamic>> departments) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = json.encode(departments);
      await prefs.setString(_departmentsCacheKey, jsonString);
      debugPrint('💾 Đã cache ${departments.length} khoa phòng');
    } catch (e) {
      debugPrint('❌ Lỗi khi cache departments: $e');
    }
  }

  Future<List<Map<String, dynamic>>?> getCachedDepartments() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_departmentsCacheKey);
      if (jsonString != null) {
        final List<dynamic> jsonList = json.decode(jsonString);
        final deptList = jsonList.cast<Map<String, dynamic>>();
        debugPrint('📦 Đã load ${deptList.length} khoa phòng từ cache');
        return deptList;
      }
    } catch (e) {
      debugPrint('❌ Lỗi khi đọc cache departments: $e');
    }
    return null;
  }

  Future<void> clearCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_staffCacheKey);
      await prefs.remove(_departmentsCacheKey);
      await prefs.remove(_timestampKey);
      debugPrint('🗑️ Đã xóa cache');
    } catch (e) {
      debugPrint('❌ Lỗi khi xóa cache: $e');
    }
  }
}
