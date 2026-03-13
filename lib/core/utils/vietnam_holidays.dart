
class HolidayInfo {
  final String name;
  final bool isOfficial;
  const HolidayInfo({required this.name, this.isOfficial = false});
}

class VietnamHolidays {
  static Map<DateTime, HolidayInfo> getAllHolidays(int year) {
    final h = <DateTime, HolidayInfo>{};
    h[DateTime(year, 1, 1)] = const HolidayInfo(name: 'Tết Dương lịch', isOfficial: true);
    h[DateTime(year, 4, 30)] = const HolidayInfo(name: 'Giải phóng miền Nam', isOfficial: true);
    h[DateTime(year, 5, 1)] = const HolidayInfo(name: 'Quốc tế Lao động', isOfficial: true);
    h[DateTime(year, 9, 2)] = const HolidayInfo(name: 'Quốc khánh Việt Nam', isOfficial: true);

    final tet = _tetDate(year);
    if (tet != null) {
      h[tet.subtract(const Duration(days: 1))] = const HolidayInfo(name: 'Giao thừa', isOfficial: true);
      h[tet] = const HolidayInfo(name: 'Mùng 1 Tết', isOfficial: true);
      h[tet.add(const Duration(days: 1))] = const HolidayInfo(name: 'Mùng 2 Tết', isOfficial: true);
      h[tet.add(const Duration(days: 2))] = const HolidayInfo(name: 'Mùng 3 Tết', isOfficial: true);
      h[tet.add(const Duration(days: 3))] = const HolidayInfo(name: 'Mùng 4 Tết', isOfficial: true);
      h[tet.add(const Duration(days: 4))] = const HolidayInfo(name: 'Mùng 5 Tết', isOfficial: true);
    }

    final gioTo = _gioToDate(year);
    if (gioTo != null) {
      h[gioTo] = const HolidayInfo(name: 'Giỗ Tổ Hùng Vương', isOfficial: true);
    }

    h[DateTime(year, 2, 14)] = const HolidayInfo(name: 'Lễ Tình nhân (Valentine)');
    h[DateTime(year, 10, 31)] = const HolidayInfo(name: 'Lễ Halloween');
    h[DateTime(year, 12, 24)] = const HolidayInfo(name: 'Đêm Giáng sinh (Christmas Eve)');
    h[DateTime(year, 12, 25)] = const HolidayInfo(name: 'Lễ Giáng sinh (Noel)');
    h[DateTime(year, 12, 31)] = const HolidayInfo(name: 'Đêm Giao thừa Dương lịch');
    h[DateTime(year, 2, 3)] = const HolidayInfo(name: 'Ngày thành lập Đảng CSVN');
    h[DateTime(year, 3, 8)] = const HolidayInfo(name: 'Ngày Quốc tế Phụ nữ');
    h[DateTime(year, 3, 26)] = const HolidayInfo(name: 'Ngày thành lập Đoàn TNCS HCM');
    h[DateTime(year, 5, 7)] = const HolidayInfo(name: 'Chiến thắng Điện Biên Phủ');
    h[DateTime(year, 5, 19)] = const HolidayInfo(name: 'Sinh nhật Bác Hồ');
    h[DateTime(year, 6, 1)] = const HolidayInfo(name: 'Ngày Quốc tế Thiếu nhi');
    h[DateTime(year, 6, 28)] = const HolidayInfo(name: 'Ngày Gia đình Việt Nam');
    h[DateTime(year, 7, 27)] = const HolidayInfo(name: 'Ngày Thương binh Liệt sĩ');
    h[DateTime(year, 8, 19)] = const HolidayInfo(name: 'Cách mạng Tháng Tám');
    h[DateTime(year, 10, 20)] = const HolidayInfo(name: 'Ngày Phụ nữ Việt Nam');
    h[DateTime(year, 11, 20)] = const HolidayInfo(name: 'Ngày Nhà giáo Việt Nam');
    h[DateTime(year, 12, 22)] = const HolidayInfo(name: 'Ngày thành lập QĐNDVN');
    _addLunarHolidays(h, year);

    return h;
  }
  static String? getHolidayName(DateTime date) {
    return getHolidayInfo(date)?.name;
  }
  static HolidayInfo? getHolidayInfo(DateTime date) {
    final key = DateTime(date.year, date.month, date.day);
    return getAllHolidays(date.year)[key];
  }
  static Map<DateTime, String> getHolidays(int year) {
    return getAllHolidays(year).map((k, v) => MapEntry(k, v.name));
  }
  static String getHolidayEmoji(String name) {
    if (name.contains('Dương lịch')) return '🎆';
    if (name.contains('Giao thừa')) return '🎊';
    if (name.contains('Tết') || name.contains('Mùng')) return '🧧';
    if (name.contains('Hùng Vương')) return '🏛️';
    if (name.contains('Giải phóng')) return '🎉';
    if (name.contains('Lao động')) return '⚒️';
    if (name.contains('Quốc khánh')) return '🇻🇳';
    if (name.contains('Phụ nữ')) return '🌸';
    if (name.contains('Đảng')) return '⭐';
    if (name.contains('Đoàn')) return '👥';
    if (name.contains('Điện Biên')) return '🏆';
    if (name.contains('Hồ Chí Minh') || name.contains('Bác Hồ')) return '🌹';
    if (name.contains('Thiếu nhi')) return '🎈';
    if (name.contains('Gia đình')) return '🏠';
    if (name.contains('Thương binh')) return '❤️';
    if (name.contains('Tháng Tám') || name.contains('Cách mạng')) return '⚡';
    if (name.contains('Nhà giáo')) return '📚';
    if (name.contains('QĐNDVN') || name.contains('Quân đội')) return '🛡️';
    if (name.contains('Nguyên Tiêu') || name.contains('Rằm')) return '🌕';
    if (name.contains('Hàn Thực')) return '🍡';
    if (name.contains('Phật Đản')) return '☸️';
    if (name.contains('Đoan Ngọ')) return '☀️';
    if (name.contains('Vu Lan')) return '🪷';
    if (name.contains('Trung Thu')) return '🏮';
    if (name.contains('Ông Táo') || name.contains('Ông Công')) return '🔥';
    if (name.contains('Tình nhân') || name.contains('Valentine')) return '💝';
    if (name.contains('Halloween')) return '🎃';
    if (name.contains('Giáng sinh') || name.contains('Noel')) return '🎄';
    if (name.contains('Christmas Eve')) return '🌟';
    if (name.contains('Giao thừa Dương') || name.contains('Năm mới Dương')) return '🎇';
    return '⭐';
  }
  static List<int> getHolidayColors(String name) {
    if (name.contains('Dương lịch')) return [0xFF1565C0, 0xFF42A5F5];
    if (name.contains('Giao thừa') ||
        name.contains('Tết') ||
        name.contains('Mùng')) {
      return [0xFFC62828, 0xFFFFB300];
    }
    if (name.contains('Hùng Vương')) return [0xFF4E342E, 0xFFBF8650];
    if (name.contains('Giải phóng')) return [0xFFB71C1C, 0xFFE57373];
    if (name.contains('Lao động')) return [0xFF1B5E20, 0xFF66BB6A];
    if (name.contains('Quốc khánh')) return [0xFFB71C1C, 0xFFFFD600];
    if (name.contains('Phụ nữ')) return [0xFFAD1457, 0xFFF06292];
    if (name.contains('Thiếu nhi')) return [0xFFE65100, 0xFFFFCC02];
    if (name.contains('Nhà giáo')) return [0xFF1565C0, 0xFF64B5F6];
    if (name.contains('Trung Thu')) return [0xFFE65100, 0xFFFFB74D];
    if (name.contains('Vu Lan') || name.contains('Phật Đản')) {
      return [0xFF4A148C, 0xFF9C27B0];
    }
    if (name.contains('Nguyên Tiêu') || name.contains('Rằm')) {
      return [0xFF1A237E, 0xFF7986CB];
    }
    if (name.contains('Đoan Ngọ')) return [0xFFE65100, 0xFFFF8F00];
    if (name.contains('Ông Táo') || name.contains('Ông Công')) {
      return [0xFFC62828, 0xFFFF6B35];
    }
    if (name.contains('Tình nhân') || name.contains('Valentine')) {
      return [0xFFAD1457, 0xFFE91E63];
    }
    if (name.contains('Halloween')) return [0xFF4A148C, 0xFFE65100];
    if (name.contains('Giáng sinh') || name.contains('Noel') || name.contains('Christmas')) {
      return [0xFF1B5E20, 0xFFC62828];
    }
    if (name.contains('Giao thừa Dương') || name.contains('Năm mới Dương')) {
      return [0xFF1A237E, 0xFF7986CB];
    }
    return [0xFF455A64, 0xFF78909C];
  }
  static DateTime? _tetDate(int year) {
    switch (year) {
      case 2024: return DateTime(2024, 2, 10);
      case 2025: return DateTime(2025, 1, 29);
      case 2026: return DateTime(2026, 2, 17);
      case 2027: return DateTime(2027, 2, 7);
      case 2028: return DateTime(2028, 1, 26);
      default: return null;
    }
  }

  static DateTime? _gioToDate(int year) {
    switch (year) {
      case 2024: return DateTime(2024, 4, 18);
      case 2025: return DateTime(2025, 4, 7);
      case 2026: return DateTime(2026, 4, 26);
      case 2027: return DateTime(2027, 4, 16);
      case 2028: return DateTime(2028, 4, 5);
      default: return null;
    }
  }

  static void _addLunarHolidays(Map<DateTime, HolidayInfo> h, int year) {
    final tet = _tetDate(year);
    if (tet != null) {
      h[tet.add(const Duration(days: 14))] =
          const HolidayInfo(name: 'Rằm tháng Giêng (Tết Nguyên Tiêu)');
    }
    switch (year) {
      case 2024: h[DateTime(2024, 2, 2)] = const HolidayInfo(name: 'Ngày Ông Công Ông Táo'); break;
      case 2025: h[DateTime(2025, 1, 22)] = const HolidayInfo(name: 'Ngày Ông Công Ông Táo'); break;
      case 2026: h[DateTime(2026, 2, 9)] = const HolidayInfo(name: 'Ngày Ông Công Ông Táo'); break;
      case 2027: h[DateTime(2027, 1, 30)] = const HolidayInfo(name: 'Ngày Ông Công Ông Táo'); break;
      case 2028: h[DateTime(2028, 1, 18)] = const HolidayInfo(name: 'Ngày Ông Công Ông Táo'); break;
      default: break;
    }
    switch (year) {
      case 2024: h[DateTime(2024, 4, 11)] = const HolidayInfo(name: 'Tết Hàn Thực'); break;
      case 2025: h[DateTime(2025, 4, 1)] = const HolidayInfo(name: 'Tết Hàn Thực'); break;
      case 2026: h[DateTime(2026, 4, 19)] = const HolidayInfo(name: 'Tết Hàn Thực'); break;
      case 2027: h[DateTime(2027, 4, 9)] = const HolidayInfo(name: 'Tết Hàn Thực'); break;
      case 2028: h[DateTime(2028, 3, 27)] = const HolidayInfo(name: 'Tết Hàn Thực'); break;
      default: break;
    }
    switch (year) {
      case 2024: h[DateTime(2024, 5, 22)] = const HolidayInfo(name: 'Lễ Phật Đản'); break;
      case 2025: h[DateTime(2025, 5, 11)] = const HolidayInfo(name: 'Lễ Phật Đản'); break;
      case 2026: h[DateTime(2026, 6, 1)] = const HolidayInfo(name: 'Lễ Phật Đản'); break;
      case 2027: h[DateTime(2027, 5, 20)] = const HolidayInfo(name: 'Lễ Phật Đản'); break;
      case 2028: h[DateTime(2028, 5, 8)] = const HolidayInfo(name: 'Lễ Phật Đản'); break;
      default: break;
    }
    switch (year) {
      case 2024: h[DateTime(2024, 6, 10)] = const HolidayInfo(name: 'Tết Đoan Ngọ'); break;
      case 2025: h[DateTime(2025, 5, 31)] = const HolidayInfo(name: 'Tết Đoan Ngọ'); break;
      case 2026: h[DateTime(2026, 6, 19)] = const HolidayInfo(name: 'Tết Đoan Ngọ'); break;
      case 2027: h[DateTime(2027, 6, 8)] = const HolidayInfo(name: 'Tết Đoan Ngọ'); break;
      case 2028: h[DateTime(2028, 5, 27)] = const HolidayInfo(name: 'Tết Đoan Ngọ'); break;
      default: break;
    }
    switch (year) {
      case 2024: h[DateTime(2024, 8, 18)] = const HolidayInfo(name: 'Lễ Vu Lan'); break;
      case 2025: h[DateTime(2025, 9, 7)] = const HolidayInfo(name: 'Lễ Vu Lan'); break;
      case 2026: h[DateTime(2026, 8, 28)] = const HolidayInfo(name: 'Lễ Vu Lan'); break;
      case 2027: h[DateTime(2027, 8, 17)] = const HolidayInfo(name: 'Lễ Vu Lan'); break;
      case 2028: h[DateTime(2028, 8, 6)] = const HolidayInfo(name: 'Lễ Vu Lan'); break;
      default: break;
    }
    switch (year) {
      case 2024: h[DateTime(2024, 9, 17)] = const HolidayInfo(name: 'Tết Trung Thu'); break;
      case 2025: h[DateTime(2025, 10, 7)] = const HolidayInfo(name: 'Tết Trung Thu'); break;
      case 2026: h[DateTime(2026, 9, 26)] = const HolidayInfo(name: 'Tết Trung Thu'); break;
      case 2027: h[DateTime(2027, 9, 15)] = const HolidayInfo(name: 'Tết Trung Thu'); break;
      case 2028: h[DateTime(2028, 9, 3)] = const HolidayInfo(name: 'Tết Trung Thu'); break;
      default: break;
    }
  }
}
