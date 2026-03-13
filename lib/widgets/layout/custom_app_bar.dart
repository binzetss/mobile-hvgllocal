import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/extensions/theme_extensions.dart';
import '../../core/routes/app_routes.dart';
import '../../core/utils/token_manager.dart';
import '../../providers/nhansu_provider.dart';
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
  final List<Widget>? extraActions;

  const CustomAppBar({
    super.key,
    this.showBackButton = false,
    this.onMenuPressed,
    this.notificationCount = 0,
    this.extraActions,
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
    final isDark = context.isDark;
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? const [Color(0xFF1C1C1E), Color(0xFF2C2C2E)]
                  : AppColors.primaryGradient,
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
                                right: 4,
                                top: 4,
                                child: Container(
                                  constraints: const BoxConstraints(
                                    minWidth: 17,
                                    minHeight: 17,
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.notificationBadge,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: Colors.white.withValues(alpha: 0.3),
                                      width: 1.5,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.notificationBadge.withValues(alpha: 0.5),
                                        blurRadius: 4,
                                        offset: const Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    notificationCount > 99 ? '99+' : '$notificationCount',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 9,
                                      fontWeight: FontWeight.w700,
                                      height: 1.5,
                                    ),
                                    textAlign: TextAlign.center,
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
                        final maSo = authProvider.user?.maSo ?? '';
                        final localFile = authProvider.localAvatarFile;
                        final hinhAnh = authProvider.user?.hinhAnh;
                        final avatarUrl = hinhAnh?.isNotEmpty == true ? hinhAnh : null;
                        final token = TokenManager().getCachedToken();
                        return Selector<NhansuProvider, String?>(
                          selector: (_, nhansu) {
                            if (maSo.isEmpty) return null;
                            final matches = nhansu.allStaff
                                .where((s) => s.maSo == maSo)
                                .toList();
                            return matches.isNotEmpty
                                ? matches.first.hoVaTen
                                : null;
                          },
                          builder: (context, staffName, _) {
                            final rawName = staffName?.trim() ??
                                authProvider.user?.hoVaTen?.trim() ??
                                '';
                            final userName =
                                rawName.isEmpty ? 'Người dùng' : rawName;
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
                            if (extraActions != null) ...extraActions!,
                            const SizedBox(width: 12),
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  width: 62,
                                  height: 62,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white.withValues(alpha: 0.65),
                                      width: 1.5,
                                    ),
                                  ),
                                )
                                    .animate(onPlay: (c) => c.repeat())
                                    .scale(
                                      begin: const Offset(1.0, 1.0),
                                      end: const Offset(1.3, 1.3),
                                      duration: const Duration(milliseconds: 1800),
                                      curve: Curves.easeOut,
                                    )
                                    .fade(
                                      begin: 0.7,
                                      end: 0.0,
                                      duration: const Duration(milliseconds: 1800),
                                      curve: Curves.easeOut,
                                    ),
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
                                      color: Theme.of(context).cardColor,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.15),
                                          blurRadius: 12,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: ClipOval(
                                      child: localFile != null
                                          ? Image.file(
                                              localFile,
                                              width: 48,
                                              height: 48,
                                              fit: BoxFit.cover,
                                            )
                                          : avatarUrl != null
                                              ? CachedNetworkImage(
                                                  imageUrl: avatarUrl,
                                                  httpHeaders: token != null
                                                      ? {'Authorization': 'Bearer $token'}
                                                      : {},
                                                  width: 48,
                                                  height: 48,
                                                  fit: BoxFit.cover,
                                                  placeholder: (ctx, url) => _buildInitialsWidget(initials, ctx),
                                                  errorWidget: (ctx, url, error) => _buildInitialsWidget(initials, ctx),
                                                )
                                              : _buildInitialsWidget(initials, context),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                            );
                          },
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

  Widget _buildInitialsWidget(String initials, BuildContext context) {
    return Center(
      child: Text(
        initials,
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w700,
          color: context.primaryColor,
          letterSpacing: -0.3,
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
