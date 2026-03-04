import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../core/extensions/theme_extensions.dart';
import '../../core/routes/app_routes.dart';
import '../../data/services/data_preload_service.dart';
import '../../providers/navigation_provider.dart';
import '../../providers/xacthuc_provider.dart';

class WebSidebar extends StatelessWidget {
  const WebSidebar({super.key});

  static const double width = 240;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: context.cardColor,
        border: Border(
          right: BorderSide(color: context.borderColor, width: 1),
        ),
      ),
      child: Column(
        children: [
          _SidebarHeader(),
          const SizedBox(height: 4),
          _UserCard(),
          Divider(height: 1, color: context.borderColor),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionLabel('CHÍNH'),
                  _MainNavItem(index: 0, icon: FontAwesomeIcons.house, label: 'Trang chủ'),
                  _MainNavItem(index: 1, icon: FontAwesomeIcons.fileLines, label: 'Văn bản'),
                  _MainNavItem(index: 3, icon: FontAwesomeIcons.clock, label: 'Chấm công'),
                  _MainNavItem(index: 4, icon: FontAwesomeIcons.userGroup, label: 'Nhân sự'),
                  const SizedBox(height: 8),
                  Divider(height: 1, color: context.borderColor),
                  const SizedBox(height: 8),
                  _SectionLabel('TIỆN ÍCH'),
                  _PushNavItem(
                    icon: FontAwesomeIcons.moneyBillWave,
                    label: 'Thông tin lương',
                    color: const Color(0xFF10B981),
                    pageKey: 'luong',
                  ),
                  _PushNavItem(
                    icon: FontAwesomeIcons.calendarCheck,
                    label: 'Lịch trực',
                    color: const Color(0xFF3B82F6),
                    pageKey: 'lichtruc',
                  ),
                  _PushNavItem(
                    icon: FontAwesomeIcons.stethoscope,
                    label: 'Lịch khám',
                    color: const Color(0xFF8B5CF6),
                    pageKey: 'lichkham',
                  ),
                  _PushNavItem(
                    icon: FontAwesomeIcons.circleCheck,
                    label: 'Bổ sung công',
                    color: const Color(0xFF10B981),
                    pageKey: 'bosungcong',
                  ),
                  _PushNavItem(
                    icon: FontAwesomeIcons.listCheck,
                    label: 'Danh sách bổ sung',
                    color: const Color(0xFF0EA5E9),
                    pageKey: 'danhsach_bosungcong',
                  ),
                  _PushNavItem(
                    icon: FontAwesomeIcons.graduationCap,
                    label: 'Đào tạo',
                    color: const Color(0xFFEC4899),
                    pageKey: 'daotao',
                  ),
                  const SizedBox(height: 8),
                  Divider(height: 1, color: context.borderColor),
                  const SizedBox(height: 8),
                  _SectionLabel('KHÁC'),
                  _PushNavItem(
                    icon: FontAwesomeIcons.bell,
                    label: 'Thông báo',
                    color: const Color(0xFFF59E0B),
                    pageKey: 'thongbao',
                  ),
                  _PushNavItem(
                    icon: FontAwesomeIcons.commentDots,
                    label: 'Góp ý & đánh giá',
                    color: const Color(0xFF06B6D4),
                    pageKey: 'gopykien',
                  ),
                  _PushNavItem(
                    icon: FontAwesomeIcons.headset,
                    label: 'Liên hệ hỗ trợ',
                    color: const Color(0xFF10B981),
                    pageKey: 'hotro',
                  ),
                  _PushNavItem(
                    icon: FontAwesomeIcons.circleInfo,
                    label: 'Giới thiệu & Hỗ trợ',
                    color: const Color(0xFF64748B),
                    pageKey: 'gioithieu',
                  ),
                  _PushNavItem(
                    icon: FontAwesomeIcons.sliders,
                    label: 'Cài đặt cá nhân',
                    color: const Color(0xFF6366F1),
                    pageKey: 'caidatcanhan',
                  ),
                  _PushNavItem(
                    icon: FontAwesomeIcons.key,
                    label: 'Đổi mật khẩu',
                    color: const Color(0xFF94A3B8),
                    pageKey: 'doimatkhau',
                  ),
                ],
              ),
            ),
          ),
          Divider(height: 1, color: context.borderColor),
          _LogoutButton(),
        ],
      ),
    );
  }
}

class _SidebarHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              'assets/images/logo.jpg',
              width: 36,
              height: 36,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'HVGL',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: context.textPrimary,
                    letterSpacing: -0.3,
                  ),
                ),
                Text(
                  'Hùng Vương Gia Lai',
                  style: TextStyle(
                    fontSize: 11,
                    color: context.textSecondary,
                    fontWeight: FontWeight.w400,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _UserCard extends StatelessWidget {
  String _buildInitials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<XacthucProvider>(
      builder: (context, auth, _) {
        final name = auth.user?.hoVaTen?.trim() ?? 'Người dùng';
        final maSo = auth.user?.maSo ?? '';
        final avatarUrl = auth.user?.hinhAnh;
        final initials = _buildInitials(name);
        return InkWell(
          onTap: () => context.read<NavigationProvider>().setWebCurrentPage('profile'),
          child: Container(
            margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: context.surfaceColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: context.primaryColor.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: ClipOval(
                    child: avatarUrl != null && avatarUrl.isNotEmpty
                        ? Image.network(
                            avatarUrl,
                            width: 38,
                            height: 38,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, e) => Center(
                              child: Text(
                                initials,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: context.primaryColor,
                                ),
                              ),
                            ),
                          )
                        : Center(
                            child: Text(
                              initials,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: context.primaryColor,
                              ),
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: context.textPrimary,
                        ),
                      ),
                      if (maSo.isNotEmpty)
                        Text(
                          maSo,
                          style: TextStyle(
                            fontSize: 11,
                            color: context.textSecondary,
                          ),
                        ),
                    ],
                  ),
                ),
                FaIcon(
                  FontAwesomeIcons.chevronRight,
                  size: 10,
                  color: context.textSecondary,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 6),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: context.textSecondary.withValues(alpha: 0.7),
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class _MainNavItem extends StatelessWidget {
  final int index;
  final IconData icon;
  final String label;
  const _MainNavItem({required this.index, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationProvider>(
      builder: (context, nav, _) {
        final isSelected = nav.webCurrentPage == null && nav.currentIndex == index;
        return InkWell(
          onTap: () => nav.setIndex(index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected
                  ? context.primaryColor.withValues(alpha: 0.12)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                FaIcon(
                  icon,
                  size: 15,
                  color: isSelected ? context.primaryColor : context.textSecondary,
                ),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected ? context.primaryColor : context.textPrimary,
                  ),
                ),
                if (isSelected) ...[
                  const Spacer(),
                  Container(
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                      color: context.primaryColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class _PushNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final String pageKey;
  const _PushNavItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.pageKey,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationProvider>(
      builder: (context, nav, _) {
        final isSelected = nav.webCurrentPage == pageKey;
        return InkWell(
          onTap: () => nav.setWebCurrentPage(pageKey),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? color.withValues(alpha: 0.10) : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: isSelected ? 0.20 : 0.12),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Center(
                    child: FaIcon(icon, size: 13, color: color),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected ? color : context.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _LogoutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        DataPreloadService().clearAllCache(context);
        context.read<XacthucProvider>().logout();
        Navigator.of(context)
            .pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            const FaIcon(
              FontAwesomeIcons.rightFromBracket,
              size: 15,
              color: Color(0xFFEF4444),
            ),
            const SizedBox(width: 12),
            const Text(
              'Đăng xuất',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFFEF4444),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
