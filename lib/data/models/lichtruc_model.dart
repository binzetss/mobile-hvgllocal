class LichtructModel {
  final DateTime date;
  final String shift;
  final String location;
  final String? note;
  final LoaiCaTruct shiftType;

  LichtructModel({
    required this.date,
    required this.shift,
    required this.location,
    this.note,
    required this.shiftType,
  });

  static List<LichtructModel> getSampleData() {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));

    return [
      LichtructModel(
        date: startOfWeek.add(const Duration(days: 0)),
        shift: 'Ca sang (7:00 - 12:00)',
        location: 'Khoa Noi',
        shiftType: LoaiCaTruct.morning,
        note: 'Truc chinh',
      ),
      LichtructModel(
        date: startOfWeek.add(const Duration(days: 0)),
        shift: 'Ca chieu (13:00 - 17:00)',
        location: 'Phong kham',
        shiftType: LoaiCaTruct.afternoon,
      ),
      LichtructModel(
        date: startOfWeek.add(const Duration(days: 2)),
        shift: 'Ca toi (18:00 - 22:00)',
        location: 'Cap cuu',
        shiftType: LoaiCaTruct.evening,
        note: 'Ho tro ca toi',
      ),
      LichtructModel(
        date: startOfWeek.add(const Duration(days: 4)),
        shift: 'Ca sang (7:00 - 12:00)',
        location: 'Khoa Ngoai',
        shiftType: LoaiCaTruct.morning,
      ),
      LichtructModel(
        date: startOfWeek.add(const Duration(days: 5)),
        shift: 'Ca dem (22:00 - 7:00)',
        location: 'Cap cuu',
        shiftType: LoaiCaTruct.night,
        note: 'Truc dem',
      ),
    ];
  }

  static List<LichtructModel> getSchedulesForDate(DateTime date, List<LichtructModel> schedules) {
    return schedules.where((schedule) {
      return schedule.date.year == date.year &&
          schedule.date.month == date.month &&
          schedule.date.day == date.day;
    }).toList();
  }
}

enum LoaiCaTruct {
  morning,
  afternoon,
  evening,
  night,
}
