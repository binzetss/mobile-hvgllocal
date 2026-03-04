import '../models/xemdanhgia_model.dart';

class XemDanhGiaService {
  static final XemDanhGiaService _instance = XemDanhGiaService._internal();
  factory XemDanhGiaService() => _instance;
  XemDanhGiaService._internal();

  Future<List<XemDanhGiaModel>> getDanhGia() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return _sampleData;
  }

  static final List<XemDanhGiaModel> _sampleData = [
    XemDanhGiaModel(
      maSo: '00312',
      hoTen: 'Nguyễn Thị Hương',
      phongBan: 'Phòng Điều dưỡng',
      danhMuc: 'Chức năng app',
      noiDung: 'App rất tiện lợi, tra cứu thông tin lương nhanh chóng. Giao diện đẹp và dễ sử dụng. Mong có thêm tính năng xem lịch họp.',
      ngayGui: DateTime(2025, 2, 20, 8, 30),
    ),
    XemDanhGiaModel(
      maSo: '00415',
      hoTen: 'Trần Minh Tuấn',
      phongBan: 'Khoa Nội',
      danhMuc: 'Giao diện',
      noiDung: 'Giao diện đẹp, tuy nhiên font chữ hơi nhỏ ở một số màn hình. Đề nghị tăng cỡ chữ cho dễ đọc hơn.',
      ngayGui: DateTime(2025, 2, 19, 14, 15),
    ),
    XemDanhGiaModel(
      maSo: '00528',
      hoTen: 'Lê Thị Mai',
      phongBan: 'Khoa Ngoại',
      danhMuc: 'Góp ý chung',
      noiDung: 'Ứng dụng rất hữu ích cho nhân viên bệnh viện. Xem lịch trực, lịch khám đều rất tiện. Cảm ơn đội ngũ phát triển.',
      ngayGui: DateTime(2025, 2, 18, 9, 0),
    ),
    XemDanhGiaModel(
      maSo: '00671',
      hoTen: 'Phạm Văn Đức',
      phongBan: 'Khoa Cấp cứu',
      danhMuc: 'Hiệu suất',
      noiDung: 'App đôi lúc bị lag khi tải danh sách văn bản. Mong cải thiện tốc độ tải hơn.',
      ngayGui: DateTime(2025, 2, 17, 16, 45),
    ),
    XemDanhGiaModel(
      maSo: '00189',
      hoTen: 'Võ Thị Lan',
      phongBan: 'Phòng Tài chính',
      danhMuc: 'Chức năng app',
      noiDung: 'Tính năng xem thông tin lương rất chi tiết và chính xác. Tiết kiệm nhiều thời gian so với trước khi có app.',
      ngayGui: DateTime(2025, 2, 16, 11, 20),
    ),
    XemDanhGiaModel(
      maSo: '00743',
      hoTen: 'Hoàng Anh Khoa',
      phongBan: 'Khoa Xét nghiệm',
      danhMuc: 'Dịch vụ bệnh viện',
      noiDung: 'Mong muốn thêm tính năng đặt lịch họp trực tuyến và thông báo nhắc nhở công việc.',
      ngayGui: DateTime(2025, 2, 15, 7, 50),
    ),
    XemDanhGiaModel(
      maSo: '00856',
      hoTen: 'Nguyễn Văn Bình',
      phongBan: 'Phòng Hành chính',
      danhMuc: 'Khác',
      noiDung: 'Một số thông báo đến muộn so với thực tế. Mong được cải thiện độ trễ của hệ thống thông báo đẩy.',
      ngayGui: DateTime(2025, 2, 14, 13, 30),
    ),
    XemDanhGiaModel(
      maSo: '00934',
      hoTen: 'Trịnh Thị Thu',
      phongBan: 'Khoa Sản',
      danhMuc: 'Góp ý chung',
      noiDung: 'App rất tốt! Giúp tôi cập nhật thông tin nhanh chóng. Chúc đội ngũ IT luôn phát triển được nhiều tính năng hay hơn nữa.',
      ngayGui: DateTime(2025, 2, 13, 10, 10),
    ),
  ];
}
