import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hvgl/core/utils/local.dart';
import '../core/services/firebase_notification_service.dart';
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
  bool _isFirstLogin = false;
  File? _localAvatarFile;
  bool _isUploadingAvatar = false;
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
  bool get isFirstLogin => _isFirstLogin;
  File? get localAvatarFile => _localAvatarFile;
  bool get isUploadingAvatar => _isUploadingAvatar;
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

        // Nếu API login không trả về hinhAnh → luôn dùng URL server lấy từ database
        final maSoStr = _user?.maSo ?? '';
        if ((_user?.hinhAnh == null || _user!.hinhAnh!.isEmpty) &&
            maSoStr.isNotEmpty) {
          _user = _user!.copyWith(
            hinhAnh: _authService.buildAvatarUrl(maSoStr),
          );
        }

        _status = AuthStatus.authenticated;
        _token = mapUser["token"];
        await Local.saveLocal("token", _token);

        if (_user != null) {
          await _authService.saveUser(_user!);
        }
        if (_rememberMe) {
          _savedMaSo = maSo;
          _savedMatKhau = matKhau;
          await _authService.saveCredentials(maSo, matKhau);
          await _authService.setRememberMe(true);
        } else {
          await _clearCredentialsInternal();
          await _authService.setRememberMe(false);
        }
        _isFirstLogin = await _authService.checkDoiMatKhau(maSo);

        // Nếu login API không trả về tên, lấy từ DanhSachNhanVien
        await refreshUserNameIfNeeded();

        // Đăng ký FCM token với server để nhận notification khi tắt app
        FirebaseNotificationService().sendTokenToServer(maSo: maSo);

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
  /// Nếu hoVaTen rỗng, lấy từ DanhSachNhanVien và cập nhật
  Future<void> refreshUserNameIfNeeded() async {
    final maSo = _user?.maSo ?? '';
    if (maSo.isEmpty) return;
    if (_user?.hoVaTen != null && _user!.hoVaTen!.isNotEmpty) return;
    final hoVaTen = await _authService.fetchHoVaTen(maSo);
    if (hoVaTen != null && hoVaTen.isNotEmpty) {
      _user = _user!.copyWith(hoVaTen: hoVaTen);
      await _authService.saveUser(_user!);
      notifyListeners();
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

  /// Upload ảnh đại diện — trả về null nếu thành công, error message nếu thất bại
  Future<String?> uploadAnhDaiDien(File file) async {
    final maSo = _user?.maSo ?? '';
    if (maSo.isEmpty) return 'Không tìm thấy thông tin người dùng';

    _isUploadingAvatar = true;
    _localAvatarFile = file; // optimistic preview
    notifyListeners();

    try {
      final anhDaiDienUrl = await _authService.uploadAnhDaiDien(maSo: maSo, file: file);
      final newUrl = (anhDaiDienUrl != null && anhDaiDienUrl.isNotEmpty)
          ? anhDaiDienUrl
          : '${_authService.buildAvatarUrl(maSo)}?t=${DateTime.now().millisecondsSinceEpoch}';
      _user = _user!.copyWith(hinhAnh: newUrl);
      await _authService.saveUser(_user!);
      _isUploadingAvatar = false;
      notifyListeners();
      return null;
    } catch (e) {
      _localAvatarFile = null;
      _isUploadingAvatar = false;
      notifyListeners();
      return e.toString().replaceFirst('Exception: ', '');
    }
  }
  Future<void> markFirstLoginDone() async {
    final maSo = _user?.maSo ?? '';
    await _authService.markFirstLoginDone(maSo);
    _isFirstLogin = false;
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
