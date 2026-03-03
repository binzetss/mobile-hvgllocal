import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/extensions/theme_extensions.dart';
import '../../widgets/caidat_canhan/theme_selector_card.dart';
import '../../widgets/caidat_canhan/notification_switch_card.dart';
import '../../widgets/common/common_app_bar.dart';

class CaidatCanhanPage extends StatelessWidget {
  const CaidatCanhanPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = kIsWeb && MediaQuery.of(context).size.width >= 768;
    if (isDesktop) return const _WebCaidatPage();

    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? _DarkPage() : _LightPage();
  }
}

// ── Web layout (bỏ thông báo, chỉ giữ chủ đề) ───────────────────────────────

class _WebCaidatPage extends StatelessWidget {
  const _WebCaidatPage();

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final subTextColor =
        isDark ? const Color(0xFF8E8E93) : const Color(0xFF757575);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          // Top bar
          Container(
            height: 64,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              color: context.cardColor,
              border:
                  Border(bottom: BorderSide(color: context.borderColor)),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFF6366F1).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: FaIcon(
                      FontAwesomeIcons.sliders,
                      size: 16,
                      color: Color(0xFF6366F1),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Cài Đặt Cá Nhân',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: context.textPrimary,
                  ),
                ),
              ],
            ),
          ),

          // Centered content
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'HIỂN THỊ',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: subTextColor,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const ThemeSelectorCard(),
                      const SizedBox(height: 32),
                      // Ghi chú thông báo
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: context.surfaceColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: context.borderColor),
                        ),
                        child: Row(
                          children: [
                            FaIcon(
                              FontAwesomeIcons.circleInfo,
                              size: 14,
                              color: subTextColor,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Cài đặt thông báo chỉ khả dụng trên ứng dụng di động.',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: subTextColor,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Light mode: giữ nguyên thiết kế cũ ──────────────────────────────────────

class _LightPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: const CommonAppBar(title: 'Cài Đặt Cá Nhân'),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionLabel('HIỂN THỊ', const Color(0xFF757575)),
            const SizedBox(height: 10),
            const ThemeSelectorCard(),
            const SizedBox(height: 24),
            _buildSectionLabel('THÔNG BÁO', const Color(0xFF757575)),
            const SizedBox(height: 10),
            const NotificationSwitchCard(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String label, Color color) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: color,
        letterSpacing: 0.8,
      ),
    );
  }
}

// ── Dark mode: thiết kế mới nền đen ─────────────────────────────────────────

class _DarkPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: _buildDarkAppBar(context),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              _label('HIỂN THỊ'),
              const SizedBox(height: 8),
              const ThemeSelectorCard(),
              const SizedBox(height: 24),
              _label('THÔNG BÁO'),
              const SizedBox(height: 8),
              const NotificationSwitchCard(),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildDarkAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF1C1C1E),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Center(
            child: FaIcon(
              FontAwesomeIcons.chevronLeft,
              size: 13,
              color: Colors.white,
            ),
          ),
        ),
      ),
      title: const Text(
        'Cài Đặt Cá Nhân',
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
        ),
      ),
      centerTitle: true,
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(0.5),
        child: Divider(
          height: 0.5,
          thickness: 0.5,
          color: Color(0xFF38383A),
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Color(0xFF8E8E93),
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}
