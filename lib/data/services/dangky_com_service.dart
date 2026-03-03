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

  /// Lấy danh sách buổi đã đăng ký theo ngày (trả về list buoi: 1=Trưa, 2=Tối)
  Future<List<int>> getDangKyTheoNgay(DateTime date) async {
    try {
      final response = await _apiService.fetchData(
        ApiEndpoints.dangKyCom,
        {'ngay': _formatDate(date)},
      );
      if (response['success'] == true) {
        final data = List<dynamic>.from(response['data'] ?? []);
        return data.map<int>((e) => (e['buoi'] as num).toInt()).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  /// Đăng ký cơm (buoi: 1=Trưa, 2=Tối)
  Future<void> dangKy(DateTime date, int buoi) async {
    final response = await _apiService.post(
      ApiEndpoints.dangKyCom,
      {'ngay': _formatDate(date), 'buoi': buoi},
    );
    if (response['success'] != true) {
      throw Exception(response['message']?.toString() ?? 'Đăng ký thất bại');
    }
  }

  /// Hủy đăng ký cơm (buoi: 1=Trưa, 2=Tối)
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
