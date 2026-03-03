import 'package:flutter/material.dart';
import '../data/services/xacthuc_service.dart';

class DoimatkhauLandauProvider extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  final matKhauCuController = TextEditingController();
  final matKhauMoiController = TextEditingController();
  final xacNhanMatKhauController = TextEditingController();

  final XacthucService _xacthucService = XacthucService();

  bool _isMatKhauCuVisible = false;
  bool _isMatKhauMoiVisible = false;
  bool _isXacNhanVisible = false;
  bool _isLoading = false;
  String? _errorMessage;

  bool get isMatKhauCuVisible => _isMatKhauCuVisible;
  bool get isMatKhauMoiVisible => _isMatKhauMoiVisible;
  bool get isXacNhanVisible => _isXacNhanVisible;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void toggleMatKhauCuVisibility() {
    _isMatKhauCuVisible = !_isMatKhauCuVisible;
    notifyListeners();
  }

  void toggleMatKhauMoiVisibility() {
    _isMatKhauMoiVisible = !_isMatKhauMoiVisible;
    notifyListeners();
  }

  void toggleXacNhanVisibility() {
    _isXacNhanVisible = !_isXacNhanVisible;
    notifyListeners();
  }

  String? validateMatKhauCu(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập mật khẩu hiện tại';
    }
    return null;
  }

  String? validateMatKhauMoi(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập mật khẩu mới';
    }
    if (value == matKhauCuController.text) {
      return 'Mật khẩu mới phải khác mật khẩu cũ';
    }
    return null;
  }

  String? validateXacNhan(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng xác nhận mật khẩu mới';
    }
    if (value != matKhauMoiController.text) {
      return 'Mật khẩu xác nhận không khớp';
    }
    return null;
  }

  Future<bool> doiMatKhau(String maSo) async {
    if (!formKey.currentState!.validate()) return false;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _xacthucService.doiMatKhau(
        maSo: maSo,
        matKhauCu: matKhauCuController.text.trim(),
        matKhauMoi: matKhauMoiController.text.trim(),
        xacNhanMatKhauMoi: xacNhanMatKhauController.text.trim(),
      );

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  @override
  void dispose() {
    matKhauCuController.dispose();
    matKhauMoiController.dispose();
    xacNhanMatKhauController.dispose();
    super.dispose();
  }
}
