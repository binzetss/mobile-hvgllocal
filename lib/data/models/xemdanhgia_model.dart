class XemDanhGiaModel {
  final String maSo;
  final String hoTen;
  final String phongBan;
  final String danhMuc;
  final String noiDung;
  final DateTime ngayGui;

  XemDanhGiaModel({
    required this.maSo,
    required this.hoTen,
    required this.phongBan,
    required this.danhMuc,
    required this.noiDung,
    required this.ngayGui,
  });

  factory XemDanhGiaModel.fromJson(Map<String, dynamic> json) {
    return XemDanhGiaModel(
      maSo: json['ma_so']?.toString() ?? '',
      hoTen: json['ho_ten']?.toString() ?? '',
      phongBan: json['phong_ban']?.toString() ?? '',
      danhMuc: json['danh_muc']?.toString() ?? '',
      noiDung: json['noi_dung']?.toString() ?? '',
      ngayGui: json['ngay_gui'] != null
          ? DateTime.parse(json['ngay_gui'])
          : DateTime.now(),
    );
  }
}
