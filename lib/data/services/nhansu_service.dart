import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/nhansu_model.dart';
import '../../core/constants/api_endpoints.dart';

class NhansuService {

  static final NhansuService _instance = NhansuService._internal();
  factory NhansuService() => _instance;
  NhansuService._internal();

  Future<List<NhansuModel>> getStaff({
    String value = '',
    String khoaPhong = '',
  }) async {
    try {
      final requestBody = {
        'value': value,
        'khoaPhong': khoaPhong,
      };

      debugPrint(' API Request - Nhân viên:');
      debugPrint('   URL: ${ApiEndpoints.baseUrl}/ThongTinHanhChinh/NhanVien');
      debugPrint('   Body: ${json.encode(requestBody)}');

      final response = await http.post(
        Uri.parse('${ApiEndpoints.baseUrl}/ThongTinHanhChinh/NhanVien'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(requestBody),
      );

      debugPrint(' API Response: Status ${response.statusCode}');

      if (response.statusCode == 200) {
        final String responseBody = utf8.decode(response.bodyBytes);
        final List<dynamic> jsonList = json.decode(responseBody);

        debugPrint('   Nhận được ${jsonList.length} nhân viên');

        if (jsonList.isNotEmpty) {
          debugPrint('    Mẫu JSON đầu tiên:');
          debugPrint('   ${jsonList.first.toString()}');

          final firstItem = jsonList.first;
          if (firstItem['imageData'] != null) {
            final imageData = firstItem['imageData'].toString();
            debugPrint('    ImageData có: ${imageData.length} ký tự');
            debugPrint('    ImageData bắt đầu bằng: ${imageData.substring(0, imageData.length > 50 ? 50 : imageData.length)}...');
          } else {
            debugPrint('   ImageData = null');
          }
        }


        final List<NhansuModel> staff = jsonList
            .map((json) => NhansuModel.fromJson(json as Map<String, dynamic>))
            .toList();

        return staff;
      } else {
        throw Exception(
          'Không thể tải danh sách nhân viên. Mã lỗi: ${response.statusCode}',
        );
      }
    } catch (e) {
      debugPrint(' Lỗi: $e');
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Lỗi kết nối khi lấy nhân viên: $e');
    }
  }


  Future<List<NhansuModel>> getAllStaff() async {
    return await getStaff(value: '', khoaPhong: '');
  }


  Future<List<NhansuModel>> getStaffByDepartment(String khoaPhongId) async {
    return await getStaff(value: '', khoaPhong: khoaPhongId);
  }


  Future<List<NhansuModel>> searchStaff(String keyword) async {
    return await getStaff(value: keyword, khoaPhong: '');
  }
}
