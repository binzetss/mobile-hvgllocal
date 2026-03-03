import '../../core/constants/api_endpoints.dart';
import 'api_service.dart';
import '../models/meal_menu_model.dart';

class MealMenuService {
  static final MealMenuService _instance = MealMenuService._internal();
  factory MealMenuService() => _instance;
  MealMenuService._internal();

  final ApiService _apiService = ApiService();

  Future<MealMenuModel> getMealMenu(DateTime date) async {
    try {
      final response = await _apiService.get(ApiEndpoints.thucDon);
      if (response['success'] == true) {
        final data = List<dynamic>.from(response['data'] ?? []);
        if (data.isEmpty) throw Exception('Không có thực đơn hôm nay');
        return MealMenuModel.fromApiList(data);
      }
      throw Exception(
        response['message']?.toString() ?? 'Không thể tải thực đơn',
      );
    } catch (e) {
      throw Exception('Không thể tải thực đơn: $e');
    }
  }
}
