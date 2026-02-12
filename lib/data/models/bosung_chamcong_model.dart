enum BosungStatus {
  pending,
  approved,
  rejected,
}

enum SessionType {
  morning,
  afternoon,
}

class BosungChamcongModel {
  final String id;
  final String hoVaTen;
  final String loai;
  final SessionType buoi;
  final DateTime ngayBoSung;
  final String lyDo;
  final DateTime ngayLamPhieu;
  final BosungStatus trangThai;
  final double soLuong;

  const BosungChamcongModel({
    required this.id,
    required this.hoVaTen,
    required this.loai,
    required this.buoi,
    required this.ngayBoSung,
    required this.lyDo,
    required this.ngayLamPhieu,
    required this.trangThai,
    this.soLuong = 0.5,
  });

  factory BosungChamcongModel.fromJson(Map<String, dynamic> json) {
    return BosungChamcongModel(
      id: json['id'] as String,
      hoVaTen: json['hoVaTen'] as String,
      loai: json['loai'] as String,
      buoi: SessionType.values.firstWhere(
        (e) => e.name == json['buoi'],
        orElse: () => SessionType.morning,
      ),
      ngayBoSung: DateTime.parse(json['ngayBoSung'] as String),
      lyDo: json['lyDo'] as String,
      ngayLamPhieu: DateTime.parse(json['ngayLamPhieu'] as String),
      trangThai: BosungStatus.values.firstWhere(
        (e) => e.name == json['trangThai'],
        orElse: () => BosungStatus.pending,
      ),
      soLuong: (json['soLuong'] as num?)?.toDouble() ?? 0.5,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hoVaTen': hoVaTen,
      'loai': loai,
      'buoi': buoi.name,
      'ngayBoSung': ngayBoSung.toIso8601String(),
      'lyDo': lyDo,
      'ngayLamPhieu': ngayLamPhieu.toIso8601String(),
      'trangThai': trangThai.name,
      'soLuong': soLuong,
    };
  }

  String get buoiText {
    switch (buoi) {
      case SessionType.morning:
        return 'Sáng';
      case SessionType.afternoon:
        return 'Chiều';
    }
  }

  String get trangThaiText {
    switch (trangThai) {
      case BosungStatus.pending:
        return 'Chờ duyệt';
      case BosungStatus.approved:
        return 'Đã duyệt';
      case BosungStatus.rejected:
        return 'Từ chối';
    }
  }

  BosungChamcongModel copyWith({
    String? id,
    String? hoVaTen,
    String? loai,
    SessionType? buoi,
    DateTime? ngayBoSung,
    String? lyDo,
    DateTime? ngayLamPhieu,
    BosungStatus? trangThai,
    double? soLuong,
  }) {
    return BosungChamcongModel(
      id: id ?? this.id,
      hoVaTen: hoVaTen ?? this.hoVaTen,
      loai: loai ?? this.loai,
      buoi: buoi ?? this.buoi,
      ngayBoSung: ngayBoSung ?? this.ngayBoSung,
      lyDo: lyDo ?? this.lyDo,
      ngayLamPhieu: ngayLamPhieu ?? this.ngayLamPhieu,
      trangThai: trangThai ?? this.trangThai,
      soLuong: soLuong ?? this.soLuong,
    );
  }
}

class BosungReasons {
  static const List<String> reasons = [
    'Chấm muộn',
    'Chấm sớm',
    'Quên chấm công',
    'Trực quên chấm',
    'NV mới chưa có vân tay',
    'Máy lỗi',
  ];
}

class BosungTypes {
  static const List<String> types = [
    'Công thường',
  ];
}
