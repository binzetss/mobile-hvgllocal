class NhansuModel {
  final String id;
  final String maSo;
  final String hoVaTen;
  final String? soDienThoai;
  final String chucVu;
  final String tenChucVu;
  final String khoaPhongId;
  final String khoaPhongTen;
  final String? anhDaiDienUrl;
  final String? gioiTinh;
  final String? namSinh;
  final String? diaChi;
  final bool isHead;
  final bool doiMatKhau;

  NhansuModel({
    required this.id,
    required this.maSo,
    required this.hoVaTen,
    this.soDienThoai,
    required this.chucVu,
    required this.tenChucVu,
    required this.khoaPhongId,
    required this.khoaPhongTen,
    this.anhDaiDienUrl,
    this.gioiTinh,
    this.namSinh,
    this.diaChi,
    this.isHead = false,
    this.doiMatKhau = false,
  });

  factory NhansuModel.fromJson(Map<String, dynamic> json) {
    final tenChucVu = json['tenChucVu']?.toString() ?? '';
    final tenChucDanh = json['tenChucDanh']?.toString() ?? '';
    // Hiển thị chức danh chuyên môn (Bác sĩ, Điều dưỡng...) ưu tiên hơn chức vụ hành chính
    final chucVu = tenChucDanh.isNotEmpty ? tenChucDanh : tenChucVu;

    return NhansuModel(
      id: json['maSo']?.toString() ?? '',
      maSo: json['maSo']?.toString() ?? '',
      hoVaTen: json['hoVaTen']?.toString() ?? '',
      soDienThoai: json['soDienThoai']?.toString(),
      chucVu: chucVu,
      tenChucVu: tenChucVu,
      khoaPhongId: '',
      khoaPhongTen: json['tenKhoaPhong']?.toString() ?? '',
      anhDaiDienUrl: json['anhDaiDienUrl']?.toString(),
      gioiTinh: json['gioiTinh']?.toString(),
      namSinh: json['namSinh']?.toString() ?? json['ngaySinh']?.toString(),
      diaChi: json['noiOHienTai']?.toString(),
      isHead: tenChucVu.toLowerCase().contains('trưởng'),
      doiMatKhau: json['doiMatKhau'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'maSo': maSo,
      'hoVaTen': hoVaTen,
      'soDienThoai': soDienThoai,
      'tenChucDanh': chucVu,
      'tenChucVu': tenChucVu,
      'tenKhoaPhong': khoaPhongTen,
      'anhDaiDienUrl': anhDaiDienUrl,
      'gioiTinh': gioiTinh,
      'namSinh': namSinh,
      'noiOHienTai': diaChi,
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
