import '../../core/constants/api_endpoints.dart';
import '../models/daotao_model.dart';
import 'api_service.dart';

class DaotaoService {
  final ApiService _apiService = ApiService();

  Future<List<DaotaoModel>> getDanhSach() async {
    try {
      final response = await _apiService.post(
        ApiEndpoints.dangKyDaoTao,
        {}, 
      );
      if (response['data'] != null) {
        final List<dynamic> dataList = response['data'];
        return dataList.map((json) => DaotaoModel.fromJson(json)).toList();
      }

      return [];
    } catch (e) {
      throw Exception('Lỗi khi tải danh sách đào tạo: $e');
    }
  }

  Future<DaotaoModel?> getChiTiet(int id) async {
    final danhSach = await getDanhSach();
    try {
      return danhSach.firstWhere((item) => item.idLopDaoTao == id);
    } catch (_) {
      return null;
    }
  }

  Future<bool> dangKy(int idLopDaoTao) async {
    try {
      final response = await _apiService.post(
        ApiEndpoints.dangKyDaoTao,
        {'idLopDaoTao': idLopDaoTao},
        requiresAuth: true,
      );

      return response['success'] == true;
    } catch (e) {
      throw Exception('Lỗi khi đăng ký đào tạo: $e');
    }
  }
}
