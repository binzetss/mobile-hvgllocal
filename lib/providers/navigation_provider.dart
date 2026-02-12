import 'package:flutter/material.dart';

class NavigationProvider extends ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void setIndex(int index) {
    if (_currentIndex != index) {
      _currentIndex = index;
      notifyListeners();
    }
  }

  void goToHome() => setIndex(0);
  void goToDocument() => setIndex(1);
  void goToQRScan() => setIndex(2);
  void goToTimeKeeping() => setIndex(3);
  void goToContacts() => setIndex(4);
}
