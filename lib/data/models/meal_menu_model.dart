/// loaiMon: 1 = Món chính, 2 = Món kèm, 3 = Canh
/// buoi:    1 = Trưa,      2 = Tối
class MealMenuModel {
  final DateTime date;
  final MealSession lunch;
  final MealSession dinner;

  MealMenuModel({
    required this.date,
    required this.lunch,
    required this.dinner,
  });

  factory MealMenuModel.fromApiList(List<dynamic> items) {
    final date = items.isNotEmpty
        ? DateTime.tryParse(items[0]['ngay']?.toString() ?? '') ?? DateTime.now()
        : DateTime.now();

    final lunchItems = items.where((e) => e['buoi'] == 1).toList();
    final dinnerItems = items.where((e) => e['buoi'] == 2).toList();

    return MealMenuModel(
      date: date,
      lunch: MealSession.fromItems(lunchItems),
      dinner: MealSession.fromItems(dinnerItems),
    );
  }
}

class MealSession {
  final List<String> mainDishes; // loaiMon: 1 — Món chính
  final List<String> sideDishes; // loaiMon: 2 — Món kèm
  final List<String> soups;     // loaiMon: 3 — Canh

  MealSession({
    required this.mainDishes,
    required this.sideDishes,
    required this.soups,
  });

  bool get isEmpty =>
      mainDishes.isEmpty && sideDishes.isEmpty && soups.isEmpty;

  static MealSession fromItems(List<dynamic> items) {
    String name(dynamic e) => e['tenMon']?.toString() ?? '';
    return MealSession(
      mainDishes: items.where((e) => e['loaiMon'] == 1).map<String>(name).toList(),
      sideDishes: items.where((e) => e['loaiMon'] == 2).map<String>(name).toList(),
      soups:      items.where((e) => e['loaiMon'] == 3).map<String>(name).toList(),
    );
  }
}
