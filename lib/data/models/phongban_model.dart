
class PhongbanModel {
  final int idKhoa;
  final String tenKhoa;

  const PhongbanModel({
    required this.idKhoa,
    required this.tenKhoa,
  });

  factory PhongbanModel.fromJson(Map<String, dynamic> json) {
    return PhongbanModel(
      idKhoa: json['id_khoa'] as int,
      tenKhoa: json['tenKhoa'] as String,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id_khoa': idKhoa,
      'tenKhoa': tenKhoa,
    };
  }

  @override
  String toString() => 'PhongbanModel(idKhoa: $idKhoa, tenKhoa: $tenKhoa)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PhongbanModel && other.idKhoa == idKhoa;
  }

  @override
  int get hashCode => idKhoa.hashCode;
}
