enum ChamcongStatus {
  present,
  late,
  absent,
  earlyLeave,
  holiday,
  weekend,
}

class ChamcongModel {
  final String id;
  final String userId;
  final DateTime date;
  final DateTime? checkInMorning;
  final DateTime? checkOutMorning;
  final DateTime? checkInAfternoon;
  final DateTime? checkOutAfternoon;
  final ChamcongStatus status;
  final String? location;
  final String? notes;
  final double? workingHours;

  const ChamcongModel({
    required this.id,
    required this.userId,
    required this.date,
    this.checkInMorning,
    this.checkOutMorning,
    this.checkInAfternoon,
    this.checkOutAfternoon,
    required this.status,
    this.location,
    this.notes,
    this.workingHours,
  });

  factory ChamcongModel.fromJson(Map<String, dynamic> json) {
    return ChamcongModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      date: DateTime.parse(json['date'] as String),
      checkInMorning: json['checkInMorning'] != null
          ? DateTime.parse(json['checkInMorning'] as String)
          : null,
      checkOutMorning: json['checkOutMorning'] != null
          ? DateTime.parse(json['checkOutMorning'] as String)
          : null,
      checkInAfternoon: json['checkInAfternoon'] != null
          ? DateTime.parse(json['checkInAfternoon'] as String)
          : null,
      checkOutAfternoon: json['checkOutAfternoon'] != null
          ? DateTime.parse(json['checkOutAfternoon'] as String)
          : null,
      status: ChamcongStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => ChamcongStatus.absent,
      ),
      location: json['location'] as String?,
      notes: json['notes'] as String?,
      workingHours: json['workingHours'] as double?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'date': date.toIso8601String(),
      'checkInMorning': checkInMorning?.toIso8601String(),
      'checkOutMorning': checkOutMorning?.toIso8601String(),
      'checkInAfternoon': checkInAfternoon?.toIso8601String(),
      'checkOutAfternoon': checkOutAfternoon?.toIso8601String(),
      'status': status.name,
      'location': location,
      'notes': notes,
      'workingHours': workingHours,
    };
  }

  bool get isPresent =>
      status == ChamcongStatus.present || status == ChamcongStatus.late;

  bool get hasAllChecks =>
      checkInMorning != null &&
      checkOutMorning != null &&
      checkInAfternoon != null &&
      checkOutAfternoon != null;

  String get statusText {
    switch (status) {
      case ChamcongStatus.present:
        return 'Có mặt';
      case ChamcongStatus.late:
        return 'Đi muộn';
      case ChamcongStatus.absent:
        return 'Vắng mặt';
      case ChamcongStatus.earlyLeave:
        return 'Về sớm';
      case ChamcongStatus.holiday:
        return 'Nghỉ lễ';
      case ChamcongStatus.weekend:
        return 'Cuối tuần';
    }
  }
}
