import '../models/gopykien_model.dart';

class GopyKienService {

  Future<bool> submitFeedback(GopyKienModel feedback) async {
    try {
      await Future.delayed(const Duration(seconds: 2));
      print('Feedback submitted: ${feedback.toJson()}');
      return true;
    } catch (e) {
      throw Exception('Không thể gửi góp ý: $e');
    }
  }
  Future<List<GopyKienModel>> getFeedbackHistory() async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      return [];
    } catch (e) {
      throw Exception('Không thể tải lịch sử góp ý: $e');
    }
  }
}
