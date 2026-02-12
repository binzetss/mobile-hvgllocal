import 'package:flutter/material.dart';
import 'package:hvgl/core/utils/local.dart';
import '../data/models/user_model.dart';
import '../data/services/xacthuc_service.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class XacthucProvider extends ChangeNotifier {
  final XacthucService _authService = XacthucService();

  AuthStatus _status = AuthStatus.initial;
  UserModel? _user;
  String? _errorMessage;
  bool _rememberMe = false;
  String _savedMaSo = '';
  String _savedMatKhau = '';
  String _token = "";
  bool _isInitialized = false;

  // Getters
  AuthStatus get status => _status;
  UserModel? get user => _user;
  String get token => _token;
  String? get errorMessage => _errorMessage;
  bool get rememberMe => _rememberMe;
  String get savedMaSo => _savedMaSo;
  String get savedMatKhau => _savedMatKhau;
  String get savedUsername => _savedMaSo;
  String get savedPassword => _savedMatKhau;
  bool get isAuthenticated => _status == AuthStatus.authenticated;
  bool get isLoading => _status == AuthStatus.loading;
  bool get isInitialized => _isInitialized;
  Future<void> init() async {
    _rememberMe = await _authService.isRememberMe();

    if (_rememberMe) {
      final credentials = await _authService.getSavedCredentials();

      if (credentials != null) {
        _savedMaSo = credentials['maSo'] ?? '';
        _savedMatKhau = credentials['matKhau'] ?? '';
      }
    }

    _isInitialized = true;
    notifyListeners();
  }
  Future<bool> checkAuthStatus() async {
    final savedUser = await _authService.getSavedUser();
    if (savedUser != null) {
      _user = savedUser;
      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    }
    _status = AuthStatus.unauthenticated;
    notifyListeners();
    return false;
  }
  Future<bool> performLogin(String maSo, String matKhau) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      
      final Map mapUser = await _authService.login(maSo, matKhau);

      if (mapUser["token"] != "") {
        _user = mapUser["user"];
        _status = AuthStatus.authenticated;
        _token = mapUser["token"];
        await Local.saveLocal("token", _token);

        if (_user != null) {
          await _authService.saveUser(_user!);
        }

        // Lưu credentials sau khi login thành công
        if (_rememberMe) {
          _savedMaSo = maSo;
          _savedMatKhau = matKhau;
          await _authService.saveCredentials(maSo, matKhau);
          await _authService.setRememberMe(true);
        } else {
          await _clearCredentialsInternal();
          await _authService.setRememberMe(false);
        }

        notifyListeners();
        return true;
      } else {
        _status = AuthStatus.error;
        _errorMessage = 'Mã số hoặc mật khẩu không đúng';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = 'Đăng nhập thất bại. Vui lòng thử lại.';
      notifyListeners();
      return false;
    }
  }
  Future<void> setRememberMe(bool value) async {
    _rememberMe = value;
    await _authService.setRememberMe(value);

    if (!value) {
      await _clearCredentialsInternal();
    }

    notifyListeners();
  }

  Future<void> logout() async {
    await _authService.logout();
    _user = null;
    _token = "";
    _status = AuthStatus.unauthenticated;

    if (!_rememberMe) {
      await _clearCredentialsInternal();
    }

    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> _clearCredentialsInternal() async {
    _savedMaSo = '';
    _savedMatKhau = '';
    await _authService.clearCredentials();
  }

  @Deprecated('Sử dụng performLogin() thay thế')
  Future<bool> login(String maSo, String matKhau) async {
    return performLogin(maSo, matKhau);
  }

  @Deprecated('Không cần gọi riêng, performLogin() đã xử lý')
  Future<void> loadSavedCredentials() async {
    await init();
  }

  @Deprecated('Không cần gọi riêng, performLogin() đã xử lý')
  Future<void> saveCredentials(String username, String password) async {
    _savedMaSo = username;
    _savedMatKhau = password;
    await _authService.saveCredentials(username, password);
    notifyListeners();
  }

  @Deprecated('Không cần gọi riêng, performLogin() đã xử lý')
  Future<void> clearSavedCredentials() async {
    await _clearCredentialsInternal();
    notifyListeners();
  }
}
