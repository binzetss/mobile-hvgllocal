import '../../core/constants/api_endpoints.dart';
import 'api_service.dart';

class DangkyComService {
  static final DangkyComService _instance = DangkyComService._internal();
  factory DangkyComService() => _instance;
  DangkyComService._internal();

  final ApiService _apiService = ApiService();

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Future<List<int>> getDangKyTheoNgay(DateTime date) async {
    try {
      final response = await _apiService.fetchData(
        ApiEndpoints.dangKyCom,
        {'ngay': _formatDate(date)},
      );
      if (response['success'] == true) {
        final data = List<dynamic>.from(response['data'] ?? []);
        return data.map<int>((e) {
          if (e is num) return e.toInt();
          if (e is Map) return ((e['buoi'] ?? e['Buoi']) as num).toInt();
          return 0;
        }).where((e) => e > 0).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<void> dangKy(DateTime date, int buoi) async {
    final response = await _apiService.post(
      ApiEndpoints.dangKyCom,
      {'ngay': _formatDate(date), 'buoi': buoi},
    );
    if (response['success'] != true) {
      throw Exception(response['message']?.toString() ?? 'Đăng ký thất bại');
    }
  }

  Future<void> huyDangKy(DateTime date, int buoi) async {
    final response = await _apiService.deleteWithBody(
      ApiEndpoints.huyDangKyCom,
      {'ngay': _formatDate(date), 'buoi': buoi},
    );
    if (response['success'] != true) {
      throw Exception(response['message']?.toString() ?? 'Hủy đăng ký thất bại');
    }
  }
}
