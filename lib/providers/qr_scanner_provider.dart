import 'package:flutter/material.dart';

enum ScannerState {
  idle,
  scanning,
  success,
  error,
}

class QrScannerProvider extends ChangeNotifier {
  ScannerState _state = ScannerState.scanning;
  bool _isFlashOn = false;
  String? _scannedCode;
  String? _errorMessage;

  ScannerState get state => _state;
  bool get isFlashOn => _isFlashOn;
  String? get scannedCode => _scannedCode;
  String? get errorMessage => _errorMessage;
  bool get isScanning => _state == ScannerState.scanning;

  void toggleFlash() {
    _isFlashOn = !_isFlashOn;
    notifyListeners();

  }

  Future<void> onQRCodeScanned(String code) async {
    if (_state != ScannerState.scanning) return;

    _state = ScannerState.idle;
    _scannedCode = code;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));

    if (_validateQRCode(code)) {
      _state = ScannerState.success;
      notifyListeners();

      await _recordAttendance(code);
    } else {
      _state = ScannerState.error;
      _errorMessage = 'Mã QR không hợp lệ';
      notifyListeners();
    }
  }

  bool _validateQRCode(String code) {

    return code.isNotEmpty && code.length > 5;
  }

  Future<void> _recordAttendance(String code) async {

    await Future.delayed(const Duration(seconds: 1));
  }

  void resetScanner() {
    _state = ScannerState.scanning;
    _scannedCode = null;
    _errorMessage = null;
    notifyListeners();
  }

  void pauseScanning() {
    _state = ScannerState.idle;
    notifyListeners();
  }

  void resumeScanning() {
    _state = ScannerState.scanning;
    _scannedCode = null;
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {

    super.dispose();
  }
}
