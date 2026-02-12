class UserModel {
  final String? maSo;
  final String? hoVaTen;
  final String? email;
  final String? soDienThoai;
  final String? chucVu;
  final String? phongBan;
  final String? hinhAnh;

  UserModel({
    this.maSo,
    this.hoVaTen,
    this.email,
    this.soDienThoai,
    this.chucVu,
    this.phongBan,
    this.hinhAnh,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      maSo: json['maSo']?.toString(),
      hoVaTen: json['hoVaTen']?.toString(),
      email: json['email']?.toString(),
      soDienThoai: json['soDienThoai']?.toString(),
      chucVu: json['chucVu']?.toString(),
      phongBan: json['phongBan']?.toString(),
      hinhAnh: json['hinhAnh']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'maSo': maSo,
      'hoVaTen': hoVaTen,
      'email': email,
      'soDienThoai': soDienThoai,
      'chucVu': chucVu,
      'phongBan': phongBan,
      'hinhAnh': hinhAnh,
    };
  }

  UserModel copyWith({
    String? maSo,
    String? hoVaTen,
    String? email,
    String? soDienThoai,
    String? chucVu,
    String? phongBan,
    String? hinhAnh,
  }) {
    return UserModel(
      maSo: maSo ?? this.maSo,
      hoVaTen: hoVaTen ?? this.hoVaTen,
      email: email ?? this.email,
      soDienThoai: soDienThoai ?? this.soDienThoai,
      chucVu: chucVu ?? this.chucVu,
      phongBan: phongBan ?? this.phongBan,
      hinhAnh: hinhAnh ?? this.hinhAnh,
    );
  }
}
