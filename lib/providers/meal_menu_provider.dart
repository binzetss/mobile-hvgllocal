import 'package:flutter/foundation.dart';
import '../data/models/meal_menu_model.dart';
import '../data/services/meal_menu_service.dart';

class MealMenuProvider extends ChangeNotifier {
  final MealMenuService _mealMenuService = MealMenuService();

  MealMenuModel? _currentMenu;
  bool _isLoading = false;
  String? _errorMessage;

  MealMenuModel? get currentMenu => _currentMenu;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;

  Future<void> fetchMealMenu(DateTime date) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentMenu = await _mealMenuService.getMealMenu(date);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchTodayMenu() async {
    await fetchMealMenu(DateTime.now());
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void reset() {
    _currentMenu = null;
    _isLoading = false;
    _errorMessage = null;
    notifyListeners();
  }
}
