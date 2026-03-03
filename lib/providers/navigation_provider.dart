import 'package:flutter/material.dart';
import '../data/models/vanban_model.dart';

class NavigationProvider extends ChangeNotifier {
  int _currentIndex = 0;
  String? _webCurrentPage; // null = main nav by index
  VanbanModel? _webDetailDoc;

  int get currentIndex => _currentIndex;
  String? get webCurrentPage => _webCurrentPage;
  VanbanModel? get webDetailDoc => _webDetailDoc;

  void setIndex(int index) {
    if (_currentIndex != index || _webCurrentPage != null) {
      _currentIndex = index;
      _webCurrentPage = null;
      _webDetailDoc = null;
      notifyListeners();
    }
  }

  void setWebCurrentPage(String? page) {
    if (_webCurrentPage != page) {
      _webCurrentPage = page;
      if (page != 'vanban_chitiet') _webDetailDoc = null;
      notifyListeners();
    }
  }

  void setWebVanbanDetail(VanbanModel doc) {
    _webDetailDoc = doc;
    _webCurrentPage = 'vanban_chitiet';
    notifyListeners();
  }

  void goToHome() => setIndex(0);
  void goToDocument() => setIndex(1);
  void goToQRScan() => setIndex(2);
  void goToTimeKeeping() => setIndex(3);
  void goToContacts() => setIndex(4);
}
