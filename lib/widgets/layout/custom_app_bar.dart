import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/routes/app_routes.dart';
import '../../providers/xacthuc_provider.dart';
import '../../pages/hoso/hoso_page.dart';
import '../../pages/luong/luong_page.dart';
import '../../pages/lichtruc/lichtruc_page.dart';
import '../../pages/thongbao/thongbao_page.dart';
import '../../pages/daotao/daotao_page.dart';
import '../../data/services/data_preload_service.dart';
import 'hvgl_menu_sheet.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showBackButton;
  final VoidCallback? onMenuPressed;
  final int notificationCount;

  const CustomAppBar({
    super.key,
    this.showBackButton = false,
    this.onMenuPressed,
    this.notificationCount = 0,
  });

  @override
  Size get preferredSize => const Size.fromHeight(100);

  String _buildInitials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    final first = parts.first.substring(0, 1);
    final last = parts.last.substring(0, 1);
    return (first + last).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: AppColors.primaryGradient,
            ),
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(24),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowMedium,
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.3),
                        width: 0.5,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildIconButton(
                          icon: Icons.menu_sharp,
                          onPressed: () => _showHvglMenu(context),
                        ),
                        Stack(
                          children: [
                            _buildIconButton(
                              icon: Icons.notifications_none_rounded,
                              onPressed: () => _moThongBao(context),
                            ),
                            if (notificationCount > 0)
                              Positioned(
                                right: 8,
                                top: 8,
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: AppColors.notificationBadge,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 1.5,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Consumer<XacthucProvider>(
                      builder: (context, authProvider, child) {
                        final rawName =
                            authProvider.user?.hoVaTen?.trim() ?? '';
                        final userName = rawName.isEmpty
                            ? 'Người dùng'
                            : rawName;
                        final initials = _buildInitials(userName);
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Xin chào',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white.withValues(
                                        alpha: 0.9,
                                      ),
                                      letterSpacing: -0.1,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    userName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.end,
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                      letterSpacing: -0.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HosoPage(),
                                ),
                              ),
                              child: Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.15,
                                      ),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    initials,
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primary,
                                      letterSpacing: -0.3,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          child: Icon(icon, color: Colors.white, size: 24),
        ),
      ),
    );
  }

  void _showHvglMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => HvglMenuSheet(
        onAction: (action) {
          Navigator.pop(context);
          switch (action) {
            case HvglMenuAction.salary:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LuongPage()),
              );
              break;
            case HvglMenuAction.documents:
              Navigator.pushNamed(context, AppRoutes.documents);
              break;
            case HvglMenuAction.dutySchedule:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LichtructPage()),
              );
              break;
            case HvglMenuAction.clinicSchedule:
              Navigator.pushNamed(context, AppRoutes.clinicSchedule);
              break;
            case HvglMenuAction.staff:
              Navigator.pushNamed(context, AppRoutes.staff);
              break;
            case HvglMenuAction.notifications:
              _moThongBao(context);
              break;
            case HvglMenuAction.training:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DaotaoPage()),
              );
              break;
            case HvglMenuAction.aboutHospital:
              Navigator.pushNamed(context, AppRoutes.about);
              break;
            case HvglMenuAction.profile:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HosoPage()),
              );
              break;
            case HvglMenuAction.settings:
              break;
            case HvglMenuAction.help:
              Navigator.pushNamed(context, AppRoutes.about);
              break;
            case HvglMenuAction.support:
              Navigator.pushNamed(context, AppRoutes.support);
              break;
            case HvglMenuAction.logout:
              DataPreloadService().clearAllCache(context);
              context.read<XacthucProvider>().logout();
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
              break;
          }
        },
      ),
    );
  }

  void _moThongBao(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ThongBaoPage()),
    );
  }
}
