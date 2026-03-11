import 'package:flutter/foundation.dart';
import '../../core/constants/api_endpoints.dart';
import '../models/lichtruc_model.dart';
import '../services/xacthuc_service.dart';
import 'api_service.dart';

class LichtructService {
  static final LichtructService _instance = LichtructService._internal();
  factory LichtructService() => _instance;
  LichtructService._internal();

  final ApiService _apiService = ApiService();
  final XacthucService _xacthucService = XacthucService();

  String _pad(int n) => n.toString().padLeft(2, '0');

  Future<String> _getMaSo() async {
    final user = await _xacthucService.getSavedUser();
    return user?.maSo ?? '';
  }

  List<ChamTrucModel> _parse(dynamic response) {
    final List<dynamic> data = response['data'] ?? [];
    return data
        .map((e) => ChamTrucModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Lịch trực cá nhân — thêm MaSo vào query
  Future<List<ChamTrucModel>> getMySchedule(int year, int month) async {
    final maSo = await _getMaSo();
    if (maSo.isEmpty) return [];
    final lastDay = DateTime(year, month + 1, 0).day;
    final params = {
      'TuNgay': '$year-${_pad(month)}-01',
      'DenNgay': '$year-${_pad(month)}-${_pad(lastDay)}',
      'MaSo': maSo,
    };
    debugPrint('LichTruc [my]: $params');
    final response = await _apiService.fetchData(ApiEndpoints.chamTruc, params);
    return _parse(response);
  }

  /// Lịch trực toàn viện — không có MaSo
  Future<List<ChamTrucModel>> getAllSchedule(int year, int month) async {
    final lastDay = DateTime(year, month + 1, 0).day;
    final params = {
      'TuNgay': '$year-${_pad(month)}-01',
      'DenNgay': '$year-${_pad(month)}-${_pad(lastDay)}',
    };
    debugPrint('LichTruc [all]: $params');
    final response = await _apiService.fetchData(ApiEndpoints.chamTruc, params);
    return _parse(response);
  }
}
