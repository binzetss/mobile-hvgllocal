import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../core/constants/api_endpoints.dart';
import '../core/utils/token_manager.dart';
import '../data/models/hoso_model.dart';
import '../data/models/nhansu_model.dart';
import '../data/services/nhansu_service.dart';

class HosoProvider extends ChangeNotifier {
  File? _localAvatar;
  NhansuModel? _nhanVien;
  List<ThanNhanModel> _thanNhans = [];

  bool _isLoadingNhanVien = false;
  bool _isLoadingThanNhan = false;
  bool _nhanVienLoaded = false;
  bool _thanNhanLoaded = false;

  File? get localAvatar => _localAvatar;

  // Stub - các section BHYT/BHXH/CCCD/CCHN sẽ thay thế bằng API riêng sau
  HosoData get profile => const HosoData(
    avatarUrl: '', fullName: '', birthYear: '', gender: '', maritalStatus: '',
    relatives: [],
    transfer: HosoTransfer(content: '', date: ''),
    currentAddress: '', permanentAddress: '',
    bhytNumber: '', bhytRegisterPlace: '', bhxhNumber: '',
    bankNumber: '', bankAccountName: '', bankName: '', taxCode: '',
    cccdNumber: '', cccdIssueDate: '', cccdIssuePlace: '',
    cchnNumber: '', cchnIssueDate: '', cchnIssuePlace: '',
    cchnDegree: '', cchnScope: '', cchnFile: '', cchnPlannedDate: '',
    titleName: '', titleCouncil: '', titleIssueDate: '',
    degrees: [], certificates: [], continuousTrainingHours: '',
  );
  NhansuModel? get nhanVien => _nhanVien;
  List<ThanNhanModel> get thanNhans => _thanNhans;
  bool get isLoadingNhanVien => _isLoadingNhanVien;
  bool get isLoadingThanNhan => _isLoadingThanNhan;

  Future<void> fetchNhanVien(String maSo) async {
    if (_nhanVienLoaded || maSo.isEmpty) return;
    _isLoadingNhanVien = true;
    notifyListeners();
    try {
      final list = await NhansuService().getStaff(maSo: maSo);
      if (list.isNotEmpty) {
        _nhanVien = list.first;
        _nhanVienLoaded = true;
      }
    } catch (_) {
    } finally {
      _isLoadingNhanVien = false;
      notifyListeners();
    }
  }

  Future<void> fetchThanNhan() async {
    if (_thanNhanLoaded) return;
    _isLoadingThanNhan = true;
    notifyListeners();
    try {
      final token = await TokenManager().getToken();
      final response = await http.get(
        Uri.parse(ApiEndpoints.thanNhan),
        headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['success'] == true && body['data'] is List) {
          _thanNhans = (body['data'] as List)
              .map((e) => ThanNhanModel.fromJson(e as Map<String, dynamic>))
              .toList();
          _thanNhanLoaded = true;
        }
      }
    } catch (_) {
    } finally {
      _isLoadingThanNhan = false;
      notifyListeners();
    }
  }

  void reset() {
    _nhanVien = null;
    _thanNhans = [];
    _nhanVienLoaded = false;
    _thanNhanLoaded = false;
  }

  Future<void> pickAvatar(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source, imageQuality: 85, maxWidth: 800);
    if (picked == null) return;
    _localAvatar = File(picked.path);
    notifyListeners();
  }

  void removeLocalAvatar() {
    _localAvatar = null;
    notifyListeners();
  }
}
