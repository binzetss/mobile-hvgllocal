import '../models/meal_menu_model.dart';

class MealMenuService {
  /// Get meal menu for a specific date
  /// TODO: Replace with actual API endpoint
  Future<MealMenuModel> getMealMenu(DateTime date) async {
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 800));

      // TODO: Replace with actual HTTP GET request
      // Example:
      // final response = await http.get(
      //   Uri.parse('https://api.bvhvgl.com/meal-menu?date=${date.toIso8601String()}'),
      //   headers: {'Content-Type': 'application/json'},
      // );
      //
      // if (response.statusCode == 200) {
      //   return MealMenuModel.fromJson(json.decode(response.body));
      // }
      //
      // throw Exception('Failed to load meal menu: ${response.statusCode}');

      // For now, return mock data
      return _getMockMenu(date);
    } catch (e) {
      throw Exception('Không thể tải thực đơn: $e');
    }
  }

  MealMenuModel _getMockMenu(DateTime date) {
    // Mock data for different days
    final dayOfWeek = date.weekday;

    switch (dayOfWeek) {
      case DateTime.monday:
        return MealMenuModel(
          date: date,
          lunch: MealSession(
            rice: 'Cơm',
            mainDishes: [
              'Thịt luộc',
              'Gà chiên mầm',
              'Cá mực kho dưa',
              'Chả chiên',
            ],
            soup: 'Canh bí đỏ',
          ),
          dinner: MealSession(
            rice: 'Cơm',
            mainDishes: [
              'Thịt kho cà cải',
              'Chả ram',
              'Rau dền luộc',
            ],
            soup: 'Canh tập tàng',
          ),
        );
      case DateTime.tuesday:
        return MealMenuModel(
          date: date,
          lunch: MealSession(
            rice: 'Cơm',
            mainDishes: [
              'Cá cam sốt cà chua',
              'Miến trộn',
              'Su su luộc',
            ],
            soup: 'Canh cải thảo',
          ),
          dinner: MealSession(
            rice: 'Cơm',
            mainDishes: [
              'Gói gà',
              'Thịt bầm xào dưa chua',
              'Trứng cuộn',
            ],
            soup: 'Canh bí đỏ',
          ),
        );
      case DateTime.wednesday:
        return MealMenuModel(
          date: date,
          lunch: MealSession(
            rice: 'Cơm',
            mainDishes: [
              'Thịt xào cà mỡ',
              'Vịt rim mầm',
              'Cá điêu hồng chiên xù',
            ],
            soup: 'Canh chua',
          ),
          dinner: MealSession(
            rice: 'Cơm',
            mainDishes: [
              'Tôm rang muối',
              'Lòng gà xào giá',
              'Dưa leo',
            ],
            soup: 'Canh bí đỏ',
          ),
        );
      case DateTime.thursday:
        return MealMenuModel(
          date: date,
          lunch: MealSession(
            rice: 'Cơm',
            mainDishes: [
              'BÚN THÁI CHAY',
            ],
            soup: '',
          ),
          dinner: MealSession(
            rice: 'Cơm',
            mainDishes: [
              'Cái thia luộc',
              'Rau dền luộc',
            ],
            soup: 'Canh bí đỏ',
          ),
        );
      case DateTime.friday:
        return MealMenuModel(
          date: date,
          lunch: MealSession(
            rice: 'Cơm',
            mainDishes: [
              'Cá lóc bó tỏ',
              'Cá ngừ kho thơm',
              'Su su xào cà rốt',
            ],
            soup: 'Canh bò ngót',
          ),
          dinner: MealSession(
            rice: 'Cơm',
            mainDishes: [
              'Bò xào đậu',
              'Chả chiên',
              'Xìm chi',
            ],
            soup: 'Canh cải ngọt',
          ),
        );
      case DateTime.saturday:
        return MealMenuModel(
          date: date,
          lunch: MealSession(
            rice: 'Cơm',
            mainDishes: [
              'Thịt xíu mai',
              'Bò kho',
              'Cá ngừ kho thơm',
            ],
            soup: 'Canh bò ngót',
          ),
          dinner: MealSession(
            rice: 'Cơm',
            mainDishes: [
              'BÁNH CANH RIÊU',
            ],
            soup: '',
          ),
        );
      default: // Sunday
        return MealMenuModel(
          date: date,
          lunch: MealSession(
            rice: 'Cơm',
            mainDishes: [
              'Đậu nhồi thịt',
              'Dùi gà roti',
              'Trứng ốp la',
            ],
            soup: 'Canh bí đao nấu xương',
          ),
          dinner: MealSession(
            rice: 'Cơm',
            mainDishes: [
              'Bò xào đậu',
              'Đậu chiên mắm hành',
              'Bắp sú luộc',
            ],
            soup: 'Canh chua',
          ),
        );
    }
  }
}
