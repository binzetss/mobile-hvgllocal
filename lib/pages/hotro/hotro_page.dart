import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../widgets/common/common_app_bar.dart';
import '../../widgets/hotro/hotro_header.dart';
import '../../widgets/hotro/hotro_quick_actions.dart';
import '../../widgets/hotro/hotro_section_title.dart';
import '../../widgets/hotro/hotro_member_card.dart';
import '../../widgets/hotro/hotro_info_card.dart';
import '../../widgets/hotro/hotro_tip_card.dart';
import '../../data/services/hotro_service.dart';

class HotroPage extends StatelessWidget {
  const HotroPage({super.key});

  @override
  Widget build(BuildContext context) {
    final service = HotroService();
    final members = service.getSupportMembers();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: const CommonAppBar(title: 'Liên hệ hỗ trợ'),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HotroHeader(),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const HotroQuickActions(),
                  const SizedBox(height: 32),
                  const HotroSectionTitle(
                    title: 'Đội ngũ hỗ trợ kỹ thuật',
                    icon: FontAwesomeIcons.userGroup,
                  ),
                  const SizedBox(height: 16),
                  Column(
                    children: members
                        .map((member) => HotroMemberCard(member: member))
                        .toList(),
                  ),
                  const SizedBox(height: 32),
                  const HotroSectionTitle(
                    title: 'Thông tin liên hệ',
                    icon: FontAwesomeIcons.circleInfo,
                  ),
                  const SizedBox(height: 16),
                  const HotroInfoCard(
                    icon: FontAwesomeIcons.locationDot,
                    iconColor: Color(0xFFE91E63),
                    iconBgColor: Color(0xFFFCE4EC),
                    title: 'Địa chỉ văn phòng',
                    content: 'Phòng CNTT - Tầng 10\nBệnh viện Hùng Vương Gia Lai',
                  ),
                  const SizedBox(height: 12),
                  const HotroTipCard(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
