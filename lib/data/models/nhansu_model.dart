class NhansuModel {
  final String id;
  final String maSo;
  final String hoVaTen;
  final String? soDienThoai;
  final String chucVu;
  final String khoaPhongId;
  final String khoaPhongTen;
  final String? hinhAnh;
  final String? gioiTinh;
  final String? namSinh;
  final String? diaChi;
  final bool isHead;

  NhansuModel({
    required this.id,
    required this.maSo,
    required this.hoVaTen,
    this.soDienThoai,
    required this.chucVu,
    required this.khoaPhongId,
    required this.khoaPhongTen,
    this.hinhAnh,
    this.gioiTinh,
    this.namSinh,
    this.diaChi,
    this.isHead = false,
  });

  factory NhansuModel.fromJson(Map<String, dynamic> json) {
    final chucVu = json['chucVu']?.toString() ?? '';

    return NhansuModel(
      id: json['maSo']?.toString() ?? '',
      maSo: json['maSo']?.toString() ?? '',
      hoVaTen: json['hoVaTen']?.toString() ?? '',
      soDienThoai: json['sdt']?.toString(),
      chucVu: chucVu,
      khoaPhongId: '',
      khoaPhongTen: json['khoaPhong']?.toString() ?? '',
      hinhAnh: json['imageData']?.toString(),
      gioiTinh: json['gioiTinh']?.toString(),
      namSinh: json['namSinh']?.toString(),
    
      isHead: chucVu.toLowerCase().contains('trưởng'),
    );
  }

  Map<String, dynamic> toJson({bool excludeImage = false}) {
    return {
      'id': id,
      'maSo': maSo,
      'hoVaTen': hoVaTen,
      'soDienThoai': soDienThoai,
      'chucVu': chucVu,
      'khoaPhongId': khoaPhongId,
      'khoaPhongTen': khoaPhongTen,
      if (!excludeImage) 'hinhAnh': hinhAnh,
      'gioiTinh': gioiTinh,
      'namSinh': namSinh,
      'isHead': isHead,
    };
  }
}


class KhoaPhongModel {
  final String id;
  final String tenKhoa;
  final String? moTa;
  final String? icon;
  final int soNhanVien;
  final String? truongKhoaId;

  KhoaPhongModel({
    required this.id,
    required this.tenKhoa,
    this.moTa,
    this.icon,
    this.soNhanVien = 0,
    this.truongKhoaId,
  });

  factory KhoaPhongModel.fromJson(Map<String, dynamic> json) {
    return KhoaPhongModel(
      id: json['id']?.toString() ?? '',
      tenKhoa: json['tenKhoa']?.toString() ?? '',
      moTa: json['moTa']?.toString(),
      icon: json['icon']?.toString(),
      soNhanVien: json['soNhanVien'] ?? 0,
      truongKhoaId: json['truongKhoaId']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tenKhoa': tenKhoa,
      'moTa': moTa,
      'icon': icon,
      'soNhanVien': soNhanVien,
      'truongKhoaId': truongKhoaId,
    };
  }
}
