import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/support_member_model.dart';

class HotroService {
  static final HotroService _instance = HotroService._internal();
  factory HotroService() => _instance;
  HotroService._internal();

  List<SupportMember> getSupportMembers() {
    return [...getLeaderMembers(), ...getSoftwareMembers(), ...getHardwareMembers()];
  }

  static const Color _leaderColor = Color(0xFF6A1B9A);
  static const Color _softwareColor = Color(0xFF1565C0);
  static const Color _hardwareColor = Color(0xFFE65100);

  List<SupportMember> getLeaderMembers() {
    return [
      SupportMember(
        name: 'Trần Nam Giang',
        role: 'Trưởng Phòng',
        avatar: 'TG',
        phone: '0919440115',
        color: _leaderColor,
        avatarPath: 'assets/avata/Giang.png',
      ),
    ];
  }

  List<SupportMember> getSoftwareMembers() {
    return [
      SupportMember(
        name: 'Nguyễn Viết Phú',
        role: 'Phần mềm',
        avatar: 'NP',
        phone: '0905027776',
        color: _softwareColor,
        avatarPath: 'assets/avata/Phu.png',
      ),
      SupportMember(
        name: 'Lê Anh Quân',
        role: 'Phần mềm',
        avatar: 'LQ',
        phone: '0376299300',
        color: _softwareColor,
        avatarPath: 'assets/avata/Quan.png',
      ),
      SupportMember(
        name: 'Bùi Vạn Đạt',
        role: 'Phần mềm',
        avatar: 'VD',
        phone: '0339448674',
        color: _softwareColor,
        avatarPath: 'assets/avata/Dat.png',
      ),
    ];
  }

  List<SupportMember> getHardwareMembers() {
    return [
      SupportMember(
        name: 'Nguyễn Trọng Khải',
        role: 'Phần cứng',
        avatar: 'TK',
        phone: '0919023816',
        color: _hardwareColor,
        avatarPath: 'assets/avata/Khai.png',
      ),
      SupportMember(
        name: 'Phạm Ngọc Vương',
        role: 'Phần cứng',
        avatar: 'NV',
        phone: '0919459115',
        color: _hardwareColor,
        avatarPath: 'assets/avata/Vuong.png',
      ),
    ];
  }

  Future<void> makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }

  Future<void> openZalo(String phoneNumber) async {
    final Uri zaloUri = Uri.parse('https://zalo.me/$phoneNumber');
    if (await canLaunchUrl(zaloUri)) {
      await launchUrl(zaloUri, mode: LaunchMode.externalApplication);
    }
  }
}
