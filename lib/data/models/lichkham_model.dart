class LichkhamModel {
  final int id;
  final String tenPhongKham;
  final String? tenBS;
  final String? tenDD;
  final DateTime ngay;
  final int buoi; // 0 = sáng, 1 = chiều
  final String? ghiChu;

  const LichkhamModel({
    required this.id,
    required this.tenPhongKham,
    this.tenBS,
    this.tenDD,
    required this.ngay,
    required this.buoi,
    this.ghiChu,
  });

  factory LichkhamModel.fromJson(Map<String, dynamic> json) {
    return LichkhamModel(
      id: json['id'] as int,
      tenPhongKham: json['tenPhongKham'] as String,
      tenBS: json['tenBS'] as String?,
      tenDD: json['tenDD'] as String?,
      ngay: DateTime.parse(json['ngay'] as String),
      buoi: json['buoi'] as int,
      ghiChu: json['ghiChu'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tenPhongKham': tenPhongKham,
      'tenBS': tenBS,
      'tenDD': tenDD,
      'ngay': ngay.toIso8601String(),
      'buoi': buoi,
      'ghiChu': ghiChu,
    };
  }

  // Helper getters
  bool get isMorning => buoi == 0;
  bool get isAfternoon => buoi == 1;

  String get buoiText => isMorning ? 'Buổi sáng' : 'Buổi chiều';

  bool get hasNote => ghiChu != null && ghiChu!.isNotEmpty;

  bool get hasDoctor => tenBS != null && tenBS!.isNotEmpty;

  bool get hasNurse => tenDD != null && tenDD!.isNotEmpty;

  String get doctorName => tenBS ?? 'N/A';

  String get nurseName => tenDD ?? 'N/A';

  bool isOnDate(DateTime date) {
    return ngay.year == date.year &&
           ngay.month == date.month &&
           ngay.day == date.day;
  }

  bool isBetweenDates(DateTime startDate, DateTime endDate) {
    return ngay.isAfter(startDate.subtract(const Duration(days: 1))) &&
           ngay.isBefore(endDate.add(const Duration(days: 1)));
  }
}
