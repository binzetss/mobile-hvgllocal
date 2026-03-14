class ThanNhanModel {
  final String tenThanNhan;
  final String moiQuanHe;
  final String soCCCD;

  const ThanNhanModel({
    required this.tenThanNhan,
    required this.moiQuanHe,
    required this.soCCCD,
  });

  factory ThanNhanModel.fromJson(Map<String, dynamic> json) => ThanNhanModel(
        tenThanNhan: json['tenThanNhan']?.toString() ?? '',
        moiQuanHe: json['moiQuanHe']?.toString() ?? '',
        soCCCD: json['soCCCD']?.toString() ?? '',
      );
}
