import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hvgl/core/utils/local.dart';
import '../models/phongban_model.dart';
import '../../core/constants/api_endpoints.dart';

class PhongbanService {
 
  static final PhongbanService _instance = PhongbanService._internal();
  factory PhongbanService() => _instance;
  PhongbanService._internal();


  Future<List<PhongbanModel>> getDepartments() async {
    try {
      final token = await Local.getLocal("token");
      final response = await http.get(
        Uri.parse('${ApiEndpoints.baseUrl}/DmKhoaPhong'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          "Authorization" : "Bearer $token"
        },
      );


      if (response.statusCode == 200) {
      
        final String responseBody = utf8.decode(response.bodyBytes);
        final List<dynamic> jsonList = json.decode(responseBody);

       
        final List<PhongbanModel> departments = jsonList
            .map((json) => PhongbanModel.fromJson(json as Map<String, dynamic>))
            .toList();

        departments.sort((a, b) => a.tenKhoa.compareTo(b.tenKhoa));

        return departments;
      } else {
        throw Exception(
          'Không thể tải danh sách khoa phòng. Mã lỗi: ${response.statusCode}',
        );
      }
    } catch (e) {
   
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Lỗi kết nối: $e');
    }
  }

 

  Future<PhongbanModel?> getDepartmentById(int idKhoa) async {
    try {
      final departments = await getDepartments();
      return departments.firstWhere(
        (dept) => dept.idKhoa == idKhoa,
        orElse: () => throw Exception('Không tìm thấy khoa phòng với ID: $idKhoa'),
      );
    } catch (e) {
      return null;
    }
  }


  Future<List<PhongbanModel>> searchDepartments(String keyword) async {
    try {
      final departments = await getDepartments();

      if (keyword.isEmpty) {
        return departments;
      }

      final lowerKeyword = keyword.toLowerCase();
      return departments
          .where((dept) => dept.tenKhoa.toLowerCase().contains(lowerKeyword))
          .toList();
    } catch (e) {
      throw Exception('Lỗi khi tìm kiếm: $e');
    }
  }
}
