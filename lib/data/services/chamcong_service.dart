import '../models/chamcong_model.dart';

class ChamcongService {
  static final ChamcongService _instance = ChamcongService._internal();
  factory ChamcongService() => _instance;
  ChamcongService._internal();


  List<ChamcongModel> _generateMockData() {
    final now = DateTime.now();
    final List<ChamcongModel> attendances = [];
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;

    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(now.year, now.month, day);

      
      if (date.isAfter(now)) continue;

      final weekday = date.weekday;


      if (weekday == DateTime.saturday || weekday == DateTime.sunday) {
        attendances.add(ChamcongModel(
          id: 'att_$day',
          userId: 'user_1',
          date: date,
          status: ChamcongStatus.weekend,
        ));
        continue;
      }

    
      final random = day % 10;

      if (random == 0) {
   
        attendances.add(ChamcongModel(
          id: 'att_$day',
          userId: 'user_1',
          date: date,
          status: ChamcongStatus.absent,
          notes: 'Nghỉ phép',
        ));
      } else if (random == 1 || random == 2) {
   
        attendances.add(ChamcongModel(
          id: 'att_$day',
          userId: 'user_1',
          date: date,
          checkInMorning: DateTime(date.year, date.month, date.day, 7, 15 + random * 5),
          checkOutMorning: DateTime(date.year, date.month, date.day, 11, 30),
          checkInAfternoon: DateTime(date.year, date.month, date.day, 13, 0),
          checkOutAfternoon: DateTime(date.year, date.month, date.day, 16, 30),
          status: ChamcongStatus.late,
          location: 'Bệnh viện Hùng Vương Gia Lai',
          workingHours: 8.0,
        ));
      } else if (random == 3) {
 
        attendances.add(ChamcongModel(
          id: 'att_$day',
          userId: 'user_1',
          date: date,
          checkInMorning: DateTime(date.year, date.month, date.day, 7, 0),
          checkOutMorning: DateTime(date.year, date.month, date.day, 11, 30),
          checkInAfternoon: DateTime(date.year, date.month, date.day, 13, 0),
          checkOutAfternoon: DateTime(date.year, date.month, date.day, 16, 0),
          status: ChamcongStatus.earlyLeave,
          location: 'Bệnh viện Hùng Vương Gia Lai',
          workingHours: 7.5,
          notes: 'Có việc cá nhân',
        ));
      } else {
        attendances.add(ChamcongModel(
          id: 'att_$day',
          userId: 'user_1',
          date: date,
          checkInMorning: DateTime(date.year, date.month, date.day, 7, 0),
          checkOutMorning: DateTime(date.year, date.month, date.day, 11, 30),
          checkInAfternoon: DateTime(date.year, date.month, date.day, 13, 0),
          checkOutAfternoon: DateTime(date.year, date.month, date.day, 16, 30),
          status: ChamcongStatus.present,
          location: 'Bệnh viện Hùng Vương Gia Lai',
          workingHours: 8.0,
        ));
        attendances.add(ChamcongModel(
          id: 'att_$day',
          userId: 'user_1',
          date: date,
          checkInMorning: DateTime(date.year, date.month, date.day, 7, 0),
          checkOutMorning: DateTime(date.year, date.month, date.day, 11, 30),
          checkInAfternoon: DateTime(date.year, date.month, date.day, 13, 0),
          checkOutAfternoon: DateTime(date.year, date.month, date.day, 16, 30),
          status: ChamcongStatus.present,
          location: 'Bệnh viện Hùng Vương Gia Lai',
          workingHours: 8.0,
        ));
      }
    }

    return attendances;
  }

  Future<List<ChamcongModel>> getAttendanceByMonth(
    int year,
    int month,
  ) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final allData = _generateMockData();
    return allData
        .where((a) => a.date.year == year && a.date.month == month)
        .toList();
  }

  Future<List<ChamcongModel>> getAttendanceByDate(DateTime date) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final allData = _generateMockData();
    return allData
        .where((a) =>
            a.date.year == date.year &&
            a.date.month == date.month &&
            a.date.day == date.day)
        .toList();
  }

  Future<ChamcongModel?> getTodayAttendance() async {
    final now = DateTime.now();
    final today = await getAttendanceByDate(now);
    return today.isNotEmpty ? today.first : null;
  }

  Future<Map<String, dynamic>> getMonthlyStats(int year, int month) async {
    final attendances = await getAttendanceByMonth(year, month);

    int presentDays = 0;
    int lateDays = 0;
    int absentDays = 0;
    int earlyLeaveDays = 0;
    double totalWorkingHours = 0;

    for (var att in attendances) {
      if (att.status == ChamcongStatus.weekend ||
          att.status == ChamcongStatus.holiday) {
        continue;
      }

      switch (att.status) {
        case ChamcongStatus.present:
          presentDays++;
          break;
        case ChamcongStatus.late:
          lateDays++;
          break;
        case ChamcongStatus.absent:
          absentDays++;
          break;
        case ChamcongStatus.earlyLeave:
          earlyLeaveDays++;
          break;
        default:
          break;
      }

      if (att.workingHours != null) {
        totalWorkingHours += att.workingHours!;
      }
    }

    return {
      'presentDays': presentDays,
      'lateDays': lateDays,
      'absentDays': absentDays,
      'earlyLeaveDays': earlyLeaveDays,
      'totalWorkingHours': totalWorkingHours,
      'totalWorkingDays': presentDays + lateDays + absentDays + earlyLeaveDays,
    };
  }
}
