import '../models/lichkham_model.dart';
import '../../core/constants/api_endpoints.dart';
import 'api_service.dart';

class LichkhamService {
  static final LichkhamService _instance = LichkhamService._internal();
  factory LichkhamService() => _instance;
  LichkhamService._internal();

  final ApiService _apiService = ApiService();

  Future<List<LichkhamModel>> fetchSchedules() async {
    try {
      // Dùng ApiService.getList() để tự động thêm Bearer token
      final response = await _apiService.getList(ApiEndpoints.lichLamViec);

      return response
          .map((json) => LichkhamModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Lỗi khi tải dữ liệu: $e');
    }
  }

  Future<List<LichkhamModel>> getSchedulesByDateRange({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final allSchedules = await fetchSchedules();
    return allSchedules
        .where((schedule) => schedule.isBetweenDates(startDate, endDate))
        .toList();
  }

  Future<List<LichkhamModel>> getSchedulesByRoom({
    required String roomName,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final allSchedules = await fetchSchedules();
    var filtered = allSchedules.where((s) => s.tenPhongKham == roomName);

    if (startDate != null && endDate != null) {
      filtered = filtered.where((s) => s.isBetweenDates(startDate, endDate));
    }

    return filtered.toList();
  }
  Future<List<String>> getRoomNames() async {
    try {
      final schedules = await fetchSchedules();
      final roomSet = <String>{};

      for (var schedule in schedules) {
        roomSet.add(schedule.tenPhongKham);
      }

      final rooms = roomSet.toList()..sort();
      return rooms;
    } catch (e) {
      throw Exception('Lỗi khi tải danh sách phòng khám: $e');
    }
  }
  Map<String, List<LichkhamModel>> groupSchedulesByRoom(List<LichkhamModel> schedules) {
    final Map<String, List<LichkhamModel>> grouped = {};

    for (var schedule in schedules) {
      if (!grouped.containsKey(schedule.tenPhongKham)) {
        grouped[schedule.tenPhongKham] = [];
      }
      grouped[schedule.tenPhongKham]!.add(schedule);
    }
    for (var room in grouped.keys) {
      grouped[room]!.sort((a, b) {
        final dateCompare = a.ngay.compareTo(b.ngay);
        if (dateCompare != 0) return dateCompare;
        return a.buoi.compareTo(b.buoi);
      });
    }

    return grouped;
  }
  Future<List<LichkhamModel>> getTodaySchedules() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));

    return await getSchedulesByDateRange(
      startDate: today,
      endDate: today,
    );
  }
  Future<List<LichkhamModel>> getWeekSchedules() async {
    final now = DateTime.now();
    final startDate = DateTime(now.year, now.month, now.day);
    final endDate = startDate.add(const Duration(days: 6));

    return await getSchedulesByDateRange(
      startDate: startDate,
      endDate: endDate,
    );
  }
}
