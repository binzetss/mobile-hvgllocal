import 'package:flutter/material.dart';
import '../data/models/bosung_chamcong_model.dart';

class BosungChamcongProvider extends ChangeNotifier {
  List<BosungChamcongModel> _supplementaryList = [];
  bool _isLoading = false;
  String? _error;

  List<BosungChamcongModel> get supplementaryList =>
      _supplementaryList;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> init() async {
    await loadSupplementaryList();
  }

  Future<void> loadSupplementaryList() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await Future.delayed(const Duration(milliseconds: 500));

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addSupplementaryAttendance({
    required String hoVaTen,
    required String loai,
    required SessionType buoi,
    required DateTime ngayBoSung,
    required String lyDo,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final newItem = BosungChamcongModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        hoVaTen: hoVaTen,
        loai: loai,
        buoi: buoi,
        ngayBoSung: ngayBoSung,
        lyDo: lyDo,
        ngayLamPhieu: DateTime.now(),
        trangThai: BosungStatus.pending,
        soLuong: 0.5,
      );

      await Future.delayed(const Duration(milliseconds: 500));

      _supplementaryList.insert(0, newItem);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> refresh() async {
    await loadSupplementaryList();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
