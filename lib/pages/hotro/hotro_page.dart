import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/extensions/theme_extensions.dart';
import '../../widgets/common/common_app_bar.dart';
import '../../widgets/hotro/hotro_header.dart';
import '../../widgets/hotro/hotro_quick_actions.dart';
import '../../widgets/hotro/hotro_section_title.dart';
import '../../widgets/hotro/hotro_member_card.dart';
import '../../widgets/hotro/hotro_info_card.dart';
import '../../widgets/hotro/hotro_tip_card.dart';
import '../../data/models/support_member_model.dart';
import '../../data/services/hotro_service.dart';

class HotroPage extends StatelessWidget {
  const HotroPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = kIsWeb && MediaQuery.of(context).size.width >= 768;
    final service = HotroService();
    final leaderMembers = service.getLeaderMembers();
    final softwareMembers = service.getSoftwareMembers();
    final hardwareMembers = service.getHardwareMembers();

    if (isDesktop) {
      return _buildWeb(context, leaderMembers, softwareMembers, hardwareMembers);
    }
    return _buildMobile(context, leaderMembers, softwareMembers, hardwareMembers);
  }

  Widget _buildMobile(
    BuildContext context,
    List<SupportMember> leaderMembers,
    List<SupportMember> softwareMembers,
    List<SupportMember> hardwareMembers,
  ) {
    return Scaffold(
      appBar: const CommonAppBar(title: 'Liên hệ hỗ trợ'),
      backgroundColor: context.bgColor,
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
                    title: 'Lãnh đạo',
                    icon: FontAwesomeIcons.userTie,
                  ),
                  const SizedBox(height: 16),
                  Column(
                    children: leaderMembers
                        .map((m) => HotroMemberCard(member: m))
                        .toList(),
                  ),
                  const SizedBox(height: 24),
                  const HotroSectionTitle(
                    title: 'Hỗ trợ phần mềm',
                    icon: FontAwesomeIcons.laptop,
                  ),
                  const SizedBox(height: 16),
                  Column(
                    children: softwareMembers
                        .map((m) => HotroMemberCard(member: m))
                        .toList(),
                  ),
                  const SizedBox(height: 24),
                  const HotroSectionTitle(
                    title: 'Hỗ trợ phần cứng',
                    icon: FontAwesomeIcons.screwdriverWrench,
                  ),
                  const SizedBox(height: 16),
                  Column(
                    children: hardwareMembers
                        .map((m) => HotroMemberCard(member: m))
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
                    content:
                        'A1003 Phòng Công Nghệ Thông Tin\nTầng 10 - Bệnh viện Hùng Vương Gia Lai',
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

  Widget _buildWeb(
    BuildContext context,
    List<SupportMember> leaderMembers,
    List<SupportMember> softwareMembers,
    List<SupportMember> hardwareMembers,
  ) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Hero banner ──────────────────────────────────────────
                _WebHeroBanner(),
                const SizedBox(height: 28),

                // ── Lãnh đạo (centered, half-width) ─────────────────────
                _buildSectionTitle(
                  context,
                  'Lãnh đạo',
                  FontAwesomeIcons.userTie,
                  const Color(0xFF6A1B9A),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: HotroMemberCard(member: leaderMembers[0])),
                    const SizedBox(width: 16),
                    const Expanded(child: SizedBox()),
                  ],
                ),
                const SizedBox(height: 28),

                // ── Phần mềm & Phần cứng side by side ───────────────────
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle(
                            context,
                            'Hỗ trợ phần mềm',
                            FontAwesomeIcons.laptop,
                            const Color(0xFF1565C0),
                          ),
                          const SizedBox(height: 16),
                          ...softwareMembers
                              .map((m) => HotroMemberCard(member: m)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle(
                            context,
                            'Hỗ trợ phần cứng',
                            FontAwesomeIcons.screwdriverWrench,
                            const Color(0xFFE65100),
                          ),
                          const SizedBox(height: 16),
                          ...hardwareMembers
                              .map((m) => HotroMemberCard(member: m)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                // ── Info row ─────────────────────────────────────────────
                const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: HotroInfoCard(
                        icon: FontAwesomeIcons.locationDot,
                        iconColor: Color(0xFFE91E63),
                        iconBgColor: Color(0xFFFCE4EC),
                        title: 'Địa chỉ văn phòng',
                        content:
                            'A1003 Phòng Công Nghệ Thông Tin\nTầng 10 - Bệnh viện Hùng Vương Gia Lai',
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(child: HotroTipCard()),
                  ],
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
  ) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(child: FaIcon(icon, size: 16, color: color)),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: context.textPrimary,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Container(height: 1, color: context.borderColor),
        ),
      ],
    );
  }
}

// ── Web Hero Banner ───────────────────────────────────────────────────────────

class _WebHeroBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [const Color(0xFF0D1F55), const Color(0xFF162850),
                 const Color(0xFF1A1A3E)]
              : [const Color(0xFF1565C0), const Color(0xFF1976D2),
                 const Color(0xFF2196F3)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1565C0)
                .withValues(alpha: isDark ? 0.5 : 0.30),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon circle
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              shape: BoxShape.circle,
              border: Border.all(
                  color: Colors.white.withValues(alpha: 0.25), width: 2),
            ),
            child: const Center(
              child: FaIcon(FontAwesomeIcons.headset,
                  size: 34, color: Colors.white),
            ),
          ),
          const SizedBox(width: 24),

          // Text info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Trung tâm hỗ trợ IT',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Phòng Công Nghệ Thông Tin — Bệnh viện Hùng Vương Gia Lai',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withValues(alpha: 0.80),
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: Colors.white.withValues(alpha: 0.30)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: const Color(0xFF4CAF50),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF4CAF50)
                                  .withValues(alpha: 0.5),
                              blurRadius: 6,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Thứ 2 - Chủ nhật  •  7:00 - 21:00',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 28),

          // Quick action buttons
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _HeroBtn(
                icon: FontAwesomeIcons.phone,
                label: 'Gọi tổng đài',
                onTap: () => HotroService().makePhoneCall('21101'),
              ),
              const SizedBox(height: 10),
              _HeroBtn(
                icon: FontAwesomeIcons.comments,
                label: 'Chat Zalo',
                onTap: () => HotroService().openZalo('0905027776'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Hero action button ────────────────────────────────────────────────────────

class _HeroBtn extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _HeroBtn(
      {required this.icon, required this.label, required this.onTap});

  @override
  State<_HeroBtn> createState() => _HeroBtnState();
}

class _HeroBtnState extends State<_HeroBtn> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          padding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white
                .withValues(alpha: _hovered ? 0.30 : 0.18),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: Colors.white.withValues(alpha: 0.35)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FaIcon(widget.icon, size: 14, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                widget.label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
