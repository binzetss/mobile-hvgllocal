import 'package:flutter/foundation.dart';
import '../data/models/gopykien_model.dart';
import '../data/services/gopykien_service.dart';

class GopyKienProvider extends ChangeNotifier {
  final GopyKienService _gopyKienService = GopyKienService();

  bool _isSubmitting = false;
  String? _errorMessage;
  bool _isSuccess = false;

  bool get isSubmitting => _isSubmitting;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;
  bool get isSuccess => _isSuccess;

  
  Future<bool> submitFeedback(GopyKienModel feedback) async {
    _isSubmitting = true;
    _errorMessage = null;
    _isSuccess = false;
    notifyListeners();

    try {
      final success = await _gopyKienService.submitFeedback(feedback);
      _isSuccess = success;
      _isSubmitting = false;
      notifyListeners();
      return success;
    } catch (e) {
      _errorMessage = e.toString();
      _isSubmitting = false;
      _isSuccess = false;
      notifyListeners();
      return false;
    }
  }


  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void reset() {
    _isSubmitting = false;
    _errorMessage = null;
    _isSuccess = false;
    notifyListeners();
  }
}
