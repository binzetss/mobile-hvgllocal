import 'package:flutter/foundation.dart';
import '../../core/constants/api_endpoints.dart';
import '../models/chamcong_model.dart';
import '../services/xacthuc_service.dart';
import 'api_service.dart';

class ChamcongService {
  static final ChamcongService _instance = ChamcongService._internal();
  factory ChamcongService() => _instance;
  ChamcongService._internal();

  final ApiService _apiService = ApiService();
  final XacthucService _xacthucService = XacthucService();

  Future<String> _getMaSo() async {
    final user = await _xacthucService.getSavedUser();
    return user?.maSo ?? '';
  }

  String _pad(int n) => n.toString().padLeft(2, '0');
  static String mapLoaiChamCong(dynamic loaiChamCong) {
    if (loaiChamCong is String && loaiChamCong.isNotEmpty) {
      return loaiChamCong;
    }
    final code = loaiChamCong is int
        ? loaiChamCong
        : int.tryParse('$loaiChamCong') ?? -1;
    switch (code) {
      case 10:
        return 'Chấm cơm';
      case 16:
        return 'Chấm đào tạo';
      case 18:
        return 'Chấm thư viện';
      default:
        return 'Chấm công';
    }
  }

  Future<List<ChamcongModel>> getAttendanceByMonth(int year, int month) async {
    try {
      final maSo = await _getMaSo();
      final tuNgay = '$year-${_pad(month)}-01';
      final lastDay = DateTime(year, month + 1, 0).day;
      final denNgay = '$year-${_pad(month)}-${_pad(lastDay)}';

      debugPrint('ChamCong: maSo=$maSo, tuNgay=$tuNgay, denNgay=$denNgay');

      final response = await _apiService.fetchData(
        ApiEndpoints.chamCong,
        {'tuNgay': tuNgay, 'denNgay': denNgay},
      );

      debugPrint('ChamCong response: $response');

      final List<dynamic> dataList = response['data'] ?? [];
      final Map<String, List<ChamcongPunch>> byDate = {};

      for (final item in dataList) {
        final ngayStr = item['ngay'] as String? ?? '';
        if (ngayStr.isEmpty) continue;
        final dt = DateTime.tryParse(ngayStr);
        if (dt == null) continue;
        final key = '${dt.year}-${_pad(dt.month)}-${_pad(dt.day)}';
        final loaiText = mapLoaiChamCong(item['loaiChamCong']);
        byDate.putIfAbsent(key, () => []).add(ChamcongPunch(time: dt, loaiChamCong: loaiText));
      }
      for (final key in byDate.keys) {
        byDate[key]!.sort((a, b) => a.time.compareTo(b.time));
      }

      final List<ChamcongModel> result = [];
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      for (int day = 1; day <= lastDay; day++) {
        final date = DateTime(year, month, day);
        if (date.isAfter(today)) continue;

        final weekday = date.weekday;
        final key = '$year-${_pad(month)}-${_pad(day)}';

        if (weekday == DateTime.saturday || weekday == DateTime.sunday) {
          // Vẫn kiểm tra có chấm công cuối tuần không
          if (byDate.containsKey(key)) {
            final punches = byDate[key]!;
            result.add(ChamcongModel(
              id: '${maSo}_$key',
              userId: maSo,
              date: date,
              status: ChamcongStatus.present,
              punches: punches,
              checkInMorning: punches.isNotEmpty ? punches[0].time : null,
              checkOutMorning: punches.length >= 2 ? punches[1].time : null,
              checkInAfternoon: punches.length >= 3 ? punches[2].time : null,
              checkOutAfternoon: punches.length >= 4 ? punches[3].time : null,
              notes: punches.map((p) => p.loaiChamCong).toSet().join(' • '),
            ));
          } else {
            result.add(ChamcongModel(
              id: 'absent_${year}_${_pad(month)}_${_pad(day)}',
              userId: maSo,
              date: date,
              status: ChamcongStatus.absent,
            ));
          }
          continue;
        }

        if (byDate.containsKey(key)) {
          final punches = byDate[key]!;
          result.add(ChamcongModel(
            id: '${maSo}_$key',
            userId: maSo,
            date: date,
            status: ChamcongStatus.present,
            punches: punches,
            checkInMorning: punches.isNotEmpty ? punches[0].time : null,
            checkOutMorning: punches.length >= 2 ? punches[1].time : null,
            checkInAfternoon: punches.length >= 3 ? punches[2].time : null,
            checkOutAfternoon: punches.length >= 4 ? punches[3].time : null,
            notes: punches.map((p) => p.loaiChamCong).toSet().join(' • '),
          ));
        } else {
          result.add(ChamcongModel(
            id: 'absent_${year}_${_pad(month)}_${_pad(day)}',
            userId: maSo,
            date: date,
            status: ChamcongStatus.absent,
          ));
        }
      }

      return result;
    } catch (e) {
      debugPrint('ChamCong error: $e');
      throw Exception('Lỗi khi tải dữ liệu chấm công: $e');
    }
  }

  Future<ChamcongModel?> getTodayAttendance() async {
    final now = DateTime.now();
    final list = await getAttendanceByMonth(now.year, now.month);
    try {
      return list.firstWhere(
        (a) =>
            a.date.year == now.year &&
            a.date.month == now.month &&
            a.date.day == now.day,
      );
    } catch (_) {
      return null;
    }
  }

  Future<Map<String, dynamic>> getMonthlyStats(int year, int month) async {
    final attendances = await getAttendanceByMonth(year, month);

    int presentDays = 0;
    int absentDays = 0;

    for (final att in attendances) {
      if (att.status == ChamcongStatus.weekend ||
          att.status == ChamcongStatus.holiday) {
        continue;
      }
      if (att.status == ChamcongStatus.present ||
          att.status == ChamcongStatus.late) {
        presentDays++;
      } else if (att.status == ChamcongStatus.absent) {
        absentDays++;
      }
    }

    return {
      'presentDays': presentDays,
      'lateDays': 0,
      'absentDays': absentDays,
      'earlyLeaveDays': 0,
      'totalWorkingHours': 0.0,
      'totalWorkingDays': presentDays + absentDays,
    };
  }
}
