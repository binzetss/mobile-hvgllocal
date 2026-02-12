class DaotaoModel {
  final int idLopDaoTao;
  final String tenLopDaoTao;
  final double soTiet;
  final DateTime ngayBatDau;
  final DateTime ngayBatDauDangKy;
  final DateTime ngayKetThucDangKy;

  DaotaoModel({
    required this.idLopDaoTao,
    required this.tenLopDaoTao,
    required this.soTiet,
    required this.ngayBatDau,
    required this.ngayBatDauDangKy,
    required this.ngayKetThucDangKy,
  });

  String get id => idLopDaoTao.toString();

  bool get isNew {
    final now = DateTime.now();
    return ngayBatDau.year == now.year &&
        ngayBatDau.month == now.month &&
        ngayBatDau.day == now.day;
  }

  /// Kiểm tra đang trong thời gian đăng ký
  bool get dangMoDangKy {
    final now = DateTime.now();
    return now.isAfter(ngayBatDauDangKy) &&
        now.isBefore(ngayKetThucDangKy);
  }

  /// Kiểm tra đã hết hạn đăng ký
  bool get hetHanDangKy {
    final now = DateTime.now();
    return now.isAfter(ngayKetThucDangKy);
  }

  /// Kiểm tra chưa mở đăng ký
  bool get chuaMoDangKy {
    final now = DateTime.now();
    return now.isBefore(ngayBatDauDangKy);
  }

  /// Trạng thái đăng ký dạng text
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
    };
  }

  DaotaoModel copyWith({
    int? idLopDaoTao,
    String? tenLopDaoTao,
    double? soTiet,
    DateTime? ngayBatDau,
    DateTime? ngayBatDauDangKy,
    DateTime? ngayKetThucDangKy,
  }) {
    return DaotaoModel(
      idLopDaoTao: idLopDaoTao ?? this.idLopDaoTao,
      tenLopDaoTao: tenLopDaoTao ?? this.tenLopDaoTao,
      soTiet: soTiet ?? this.soTiet,
      ngayBatDau: ngayBatDau ?? this.ngayBatDau,
      ngayBatDauDangKy: ngayBatDauDangKy ?? this.ngayBatDauDangKy,
      ngayKetThucDangKy: ngayKetThucDangKy ?? this.ngayKetThucDangKy,
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
