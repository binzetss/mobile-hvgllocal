class ChamTrucModel {
  final String maSo;
  final String hoVaTen;
  final String tenKhoaPhong;
  final String tenChucDanh;
  final DateTime ngay;
  final String kyHieu;
  final String moTa;

  ChamTrucModel({
    required this.maSo,
    required this.hoVaTen,
    required this.tenKhoaPhong,
    required this.tenChucDanh,
    required this.ngay,
    required this.kyHieu,
    required this.moTa,
  });

  factory ChamTrucModel.fromJson(Map<String, dynamic> json) {
    return ChamTrucModel(
      maSo: json['maSo']?.toString() ?? '',
      hoVaTen: json['hoVaTen']?.toString() ?? '',
      tenKhoaPhong: json['tenKhoaPhong']?.toString() ?? '',
      tenChucDanh: json['tenChucDanh']?.toString() ?? '',
      ngay: json['ngay'] != null
          ? DateTime.tryParse(json['ngay'].toString()) ?? DateTime.now()
          : DateTime.now(),
      kyHieu: json['kyHieu']?.toString() ?? '',
      moTa: json['moTa']?.toString() ?? '',
    );
  }
}
