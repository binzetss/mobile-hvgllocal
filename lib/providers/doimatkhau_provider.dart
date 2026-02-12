import 'package:flutter/material.dart';

class DoimatkhauProvider extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool _isOldPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;

  bool get isOldPasswordVisible => _isOldPasswordVisible;
  bool get isNewPasswordVisible => _isNewPasswordVisible;
  bool get isConfirmPasswordVisible => _isConfirmPasswordVisible;
  bool get isLoading => _isLoading;

  void toggleOldPasswordVisibility() {
    _isOldPasswordVisible = !_isOldPasswordVisible;
    notifyListeners();
  }

  void toggleNewPasswordVisibility() {
    _isNewPasswordVisible = !_isNewPasswordVisible;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
    notifyListeners();
  }

  String? validateOldPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập mật khẩu hiện tại';
    }
    return null;
  }

  String? validateNewPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập mật khẩu mới';
    }
    if (value.length < 6) {
      return 'Mật khẩu phải có ít nhất 6 ký tự';
    }
    if (value == oldPasswordController.text) {
      return 'Mật khẩu mới phải khác mật khẩu cũ';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng xác nhận mật khẩu mới';
    }
    if (value != newPasswordController.text) {
      return 'Mật khẩu xác nhận không khớp';
    }
    return null;
  }

  Future<bool> changePassword() async {
    if (!formKey.currentState!.validate()) {
      return false;
    }

    _isLoading = true;
    notifyListeners();

    // TODO: Implement actual password change logic here
    await Future.delayed(const Duration(seconds: 2));

    _isLoading = false;
    notifyListeners();

    return true;
  }

  @override
  void dispose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
