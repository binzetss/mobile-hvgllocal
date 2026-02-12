import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/support_member_model.dart';

class HotroService {
  static final HotroService _instance = HotroService._internal();
  factory HotroService() => _instance;
  HotroService._internal();

  List<SupportMember> getSupportMembers() {
    return [
      SupportMember(
        name: 'Nguyễn Viết Phú',
        role: 'IT Support',
        avatar: 'NP',
        phone: '0905027776',
        color: const Color(0xFF7C4DFF),
      ),
      SupportMember(
        name: 'Lê Anh Quân',
        role: 'IT Support',
        avatar: 'LQ',
        phone: '0376299300',
        color: const Color(0xFF00ACC1),
      ),
      SupportMember(
        name: 'Bùi Vạn Đạt',
        role: 'IT Support',
        avatar: 'VD',
        phone: '0339448674',
        color: const Color(0xFF43A047),
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
