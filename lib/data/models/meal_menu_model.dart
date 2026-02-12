class MealMenuModel {
  final DateTime date;
  final MealSession lunch;
  final MealSession dinner;

  MealMenuModel({
    required this.date,
    required this.lunch,
    required this.dinner,
  });

  factory MealMenuModel.fromJson(Map<String, dynamic> json) {
    return MealMenuModel(
      date: DateTime.parse(json['date']),
      lunch: MealSession.fromJson(json['lunch']),
      dinner: MealSession.fromJson(json['dinner']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'lunch': lunch.toJson(),
      'dinner': dinner.toJson(),
    };
  }
}

class MealSession {
  final String rice;
  final List<String> mainDishes;
  final String soup;

  MealSession({
    required this.rice,
    required this.mainDishes,
    required this.soup,
  });

  factory MealSession.fromJson(Map<String, dynamic> json) {
    return MealSession(
      rice: json['rice'] ?? 'Cơm',
      mainDishes: List<String>.from(json['main_dishes'] ?? []),
      soup: json['soup'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rice': rice,
      'main_dishes': mainDishes,
      'soup': soup,
    };
  }
}
