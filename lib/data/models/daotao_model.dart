class DaotaoModel {
  final int idLopDaoTao;
  final String tenLopDaoTao;
  final double soTiet;
  final DateTime ngayBatDau;
  final DateTime ngayBatDauDangKy;
  final DateTime ngayKetThucDangKy;
  final bool isTrangThai;

  DaotaoModel({
    required this.idLopDaoTao,
    required this.tenLopDaoTao,
    required this.soTiet,
    required this.ngayBatDau,
    required this.ngayBatDauDangKy,
    required this.ngayKetThucDangKy,
    this.isTrangThai = false,
  });

  String get id => idLopDaoTao.toString();

  bool get isNew {
    final now = DateTime.now();
    return ngayBatDau.year == now.year &&
        ngayBatDau.month == now.month &&
        ngayBatDau.day == now.day;
  }

  bool get dangMoDangKy {
    final now = DateTime.now();
    return now.isAfter(ngayBatDauDangKy) &&
        now.isBefore(ngayKetThucDangKy);
  }

  bool get hetHanDangKy {
    final now = DateTime.now();
    return now.isAfter(ngayKetThucDangKy);
  }

  bool get chuaMoDangKy {
    final now = DateTime.now();
    return now.isBefore(ngayBatDauDangKy);
  }

  String get trangThaiDangKy {
    if (dangMoDangKy) return 'Đang mở đăng ký';
    if (hetHanDangKy) return 'Đã hết hạn';
    return 'Chưa mở đăng ký';
  }

  factory DaotaoModel.fromJson(Map<String, dynamic> json) {
    return DaotaoModel(
      idLopDaoTao: json['idLopDaoTao'] ?? 0,
      tenLopDaoTao: json['tenLopDaoTao']?.toString() ?? '',
      soTiet: (json['soTiet'] ?? 0).toDouble(),
      ngayBatDau: json['ngayBatDau'] != null
          ? DateTime.parse(json['ngayBatDau'])
          : DateTime.now(),
      ngayBatDauDangKy: json['ngayBatDauDangKy'] != null
          ? DateTime.parse(json['ngayBatDauDangKy'])
          : DateTime.now(),
      ngayKetThucDangKy: json['ngayKetThucDangKy'] != null
          ? DateTime.parse(json['ngayKetThucDangKy'])
          : DateTime.now(),
      isTrangThai: json['isTrangThai'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idLopDaoTao': idLopDaoTao,
      'tenLopDaoTao': tenLopDaoTao,
      'soTiet': soTiet,
      'ngayBatDau': ngayBatDau.toIso8601String(),
      'ngayBatDauDangKy': ngayBatDauDangKy.toIso8601String(),
      'ngayKetThucDangKy': ngayKetThucDangKy.toIso8601String(),
      'isTrangThai': isTrangThai,
    };
  }

  DaotaoModel copyWith({
    int? idLopDaoTao,
    String? tenLopDaoTao,
    double? soTiet,
    DateTime? ngayBatDau,
    DateTime? ngayBatDauDangKy,
    DateTime? ngayKetThucDangKy,
    bool? isTrangThai,
  }) {
    return DaotaoModel(
      idLopDaoTao: idLopDaoTao ?? this.idLopDaoTao,
      tenLopDaoTao: tenLopDaoTao ?? this.tenLopDaoTao,
      soTiet: soTiet ?? this.soTiet,
      ngayBatDau: ngayBatDau ?? this.ngayBatDau,
      ngayBatDauDangKy: ngayBatDauDangKy ?? this.ngayBatDauDangKy,
      ngayKetThucDangKy: ngayKetThucDangKy ?? this.ngayKetThucDangKy,
      isTrangThai: isTrangThai ?? this.isTrangThai,
    );
  }
}

class DaotaoApiResponse {
  final bool success;
  final List<DaotaoModel> data;

  DaotaoApiResponse({
    required this.success,
    required this.data,
  });

  factory DaotaoApiResponse.fromJson(Map<String, dynamic> json) {
    return DaotaoApiResponse(
      success: json['success'] ?? false,
      data: json['data'] != null
          ? (json['data'] as List)
              .map((item) => DaotaoModel.fromJson(item))
              .toList()
          : [],
    );
  }
}
