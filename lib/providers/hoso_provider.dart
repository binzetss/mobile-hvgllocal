import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../data/models/hoso_model.dart';

class HosoProvider extends ChangeNotifier {
  final HosoData _profile = const HosoData(
    avatarUrl: '',
    fullName: 'Lê Anh Quân',
    birthYear: '1994',
    gender: 'Nam',
    maritalStatus: 'Độc thân',
    relatives: [
      HosoRelative(
        relation: 'Bố',
        fullName: 'Lê Văn Minh',
        birthYear: '1965',
        cccd: '064203001234',
        bhyt: 'GD-001234567890',
      ),
      HosoRelative(
        relation: 'Mẹ',
        fullName: 'Trần Thị Hồng',
        birthYear: '1969',
        cccd: '064203009876',
        bhyt: 'GD-009876543210',
      ),
    ],
    transfer: HosoTransfer(
      content: 'Chính thức / Làm việc',
      date: '01/09/2023',
    ),
    currentAddress: '120 Phan Đình Phùng, P. Tây Sơn, Pleiku, Gia Lai',
    permanentAddress: 'Thôn 4, Ia Kênh, Pleiku, Gia Lai',
    bhytNumber: 'GD-003112345678',
    bhytRegisterPlace: 'Bệnh viện Hùng Vương Gia Lai',
    bhxhNumber: 'HL-9876543210',
    bankNumber: '102789123456',
    bankAccountName: 'Lê Anh Quân',
    bankName: 'Vietcombank - CN Gia Lai',
    taxCode: '0312345678',
    cccdNumber: '064203002710',
    cccdIssueDate: '07/04/2021',
    cccdIssuePlace: 'Gia Lai',
    cchnNumber: '0005664/GL-CCHN',
    cchnIssueDate: '19/09/2025',
    cchnIssuePlace: 'Đà Nẵng',
    cchnDegree: 'Cử nhân Điều dưỡng',
    cchnScope:
        'Thực hiện theo Thông tư số 26/2015/TTLTBYT-BNV ngày 07/10/2015.',
    cchnFile: 'Không có tệp nào được chọn',
    cchnPlannedDate: '01/01/0001',
    titleName: 'Điều dưỡng trưởng',
    titleCouncil: 'Hội đồng Điều dưỡng',
    titleIssueDate: '15/06/2024',
    degrees: [
      HosoDegree(
        major: 'Lập Trình Máy Tính',
        place: 'Đà Nẵng',
        level: 'Giỏi',
        date: '30/12/2024',
        attachmentName: 'khong_co_tep',
      ),
    ],
    certificates: [
      HosoCertificate(
        name: 'Chứng chỉ đào tạo',
        date: '05/03/2024',
        attachmentName: 'khong_co_tep',
      ),
      HosoCertificate(
        name: 'Chứng chỉ CME (đào tạo liên tục)',
        date: '20/11/2024',
        attachmentName: 'khong_co_tep',
      ),
    ],
    continuousTrainingHours: '120 giờ',
  );

  File? _localAvatar;
  bool _isUploadingAvatar = false;

  HosoData get profile => _profile;
  File? get localAvatar => _localAvatar;
  bool get isUploadingAvatar => _isUploadingAvatar;

  Future<void> pickAvatar(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: source,
      imageQuality: 85,
      maxWidth: 800,
    );
    if (picked == null) return;

    _localAvatar = File(picked.path);
    notifyListeners();

    // TODO: Gắn API upload ảnh đại diện ở đây
    // _isUploadingAvatar = true;
    // notifyListeners();
    // try {
    //   final token = TokenManager().getCachedToken();
    //   await ApiService().uploadAvatar(token: token, file: _localAvatar!);
    // } catch (e) {
    //   _localAvatar = null; // rollback nếu upload thất bại
    // } finally {
    //   _isUploadingAvatar = false;
    //   notifyListeners();
    // }
  }

  void removeLocalAvatar() {
    _localAvatar = null;
    notifyListeners();
  }
}
