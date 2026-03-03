import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/extensions/theme_extensions.dart';
import '../../providers/xacthuc_provider.dart';

enum HvglMenuAction {
  salary,
  documents,
  dutySchedule,
  clinicSchedule,
  staff,
  notifications,
  training,
  aboutHospital,
  profile,
  settings,
  help,
  support,
  logout,
}

class HvglMenuSheet extends StatefulWidget {
  final ValueChanged<HvglMenuAction> onAction;

  const HvglMenuSheet({super.key, required this.onAction});

  @override
  State<HvglMenuSheet> createState() => _HvglMenuSheetState();
}

class _HvglMenuSheetState extends State<HvglMenuSheet> {
  bool _isGopyKienExpanded = false;
  bool _isHelpExpanded = false;
  bool _isSettingsExpanded = false;


  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      decoration: BoxDecoration(
        color: context.bgColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF38383A) : Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isDark
                          ? [AppColors.primaryDark, AppColors.primaryLight]
                          : [const Color(0xFF1877F2), const Color(0xFF0D5BC7)],
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: isDark
                            ? AppColors.primaryDark.withValues(alpha: 0.4)
                            : const Color(0xFF1877F2).withValues(alpha: 0.4),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: FaIcon(
                      FontAwesomeIcons.hospital,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'HÙNG VƯƠNG GIA LAI',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: context.textPrimary,
                      letterSpacing: 0.8,
                      height: 1.3,
                      shadows: [
                        Shadow(
                          color: isDark
                              ? Colors.black.withValues(alpha: 0.3)
                              : Colors.black.withValues(alpha: 0.1),
                          blurRadius: 2,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  _buildMenuGrid(),
                  const SizedBox(height: 16),
                  _buildExpandableSections(),
                  const SizedBox(height: 16),
                  _buildLogoutButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuGrid() {
    final menuItems = [
      _MenuItemData(
        icon: FontAwesomeIcons.moneyBillWave,
        label: 'Thông tin lương',
        color: const Color(0xFF4CAF50),
        bgColor: const Color(0xFFE8F5E9),
        darkBgColor: const Color(0xFF1B3A1F),
        action: HvglMenuAction.salary,
      ),
      _MenuItemData(
        icon: FontAwesomeIcons.calendarCheck,
        label: 'Lịch trực',
        color: const Color(0xFF2196F3),
        bgColor: const Color(0xFFE3F2FD),
        darkBgColor: const Color(0xFF0D2A45),
        action: HvglMenuAction.dutySchedule,
      ),
      _MenuItemData(
        icon: FontAwesomeIcons.stethoscope,
        label: 'Lịch khám',
        color: const Color(0xFF9C27B0),
        bgColor: const Color(0xFFF3E5F5),
        darkBgColor: const Color(0xFF2D1040),
        action: HvglMenuAction.clinicSchedule,
      ),
      _MenuItemData(
        icon: FontAwesomeIcons.graduationCap,
        label: 'Đào tạo',
        color: const Color(0xFFE91E63),
        bgColor: const Color(0xFFFCE4EC),
        darkBgColor: const Color(0xFF3D0A1E),
        action: HvglMenuAction.training,
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.55,
      ),
      itemCount: menuItems.length,
      itemBuilder: (context, index) {
        return _buildMenuItem(menuItems[index]);
      },
    );
  }

  Widget _buildMenuItem(_MenuItemData item) {
    final isDark = context.isDark;
    return GestureDetector(
      onTap: () => widget.onAction(item.action),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2C2C2E) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? const Color(0xFF38383A) : Colors.grey[200]!,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.2)
                  : Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    item.color.withValues(alpha: 0.2),
                    item.color.withValues(alpha: 0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: item.color.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Center(
                child: FaIcon(item.icon, color: item.color, size: 22),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              item.label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: context.textPrimary,
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static const List<String> _xemDanhGiaAllowedIds = [
    '00949',
    '00130',
    '00571',
    '00873',
    '00008',
    '00055',
  ];

  Widget _buildExpandableSections() {
    final maSo = context.read<XacthucProvider>().user?.maSo ?? '';
    final canViewDanhGia = _xemDanhGiaAllowedIds.contains(maSo);

    return Column(
      children: [
        _buildExpandableSection(
          icon: FontAwesomeIcons.comment,
          title: 'Góp ý và đánh giá',
          isExpanded: _isGopyKienExpanded,
          onTap: () => setState(() => _isGopyKienExpanded = !_isGopyKienExpanded),
          children: [
            _buildSubMenuItem(
              icon: FontAwesomeIcons.penToSquare,
              title: 'Góp ý và đánh giá',
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/gopykien');
              },
            ),
            if (canViewDanhGia)
              _buildSubMenuItem(
                icon: FontAwesomeIcons.star,
                title: 'Xem Đánh Giá',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/xemdanhgia');
                },
              ),
          ],
        ),
        const SizedBox(height: 12),
        _buildExpandableSection(
          icon: FontAwesomeIcons.circleQuestion,
          title: 'Giới thiệu và hỗ trợ',
          isExpanded: _isHelpExpanded,
          onTap: () => setState(() => _isHelpExpanded = !_isHelpExpanded),
          children: [
            _buildSubMenuItem(
              icon: FontAwesomeIcons.circleInfo,
              title: 'Giới thiệu',
              onTap: () => widget.onAction(HvglMenuAction.help),
            ),
            _buildSubMenuItem(
              icon: FontAwesomeIcons.headset,
              title: 'Liên hệ hỗ trợ',
              onTap: () => widget.onAction(HvglMenuAction.support),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildExpandableSection(
          icon: FontAwesomeIcons.gear,
          title: 'Cài đặt',
          isExpanded: _isSettingsExpanded,
          onTap: () =>
              setState(() => _isSettingsExpanded = !_isSettingsExpanded),
          children: [
            _buildSubMenuItem(
              icon: FontAwesomeIcons.sliders,
              title: 'Cài đặt cá nhân',
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/caidat-ca-nhan');
              },
            ),
            _buildSubMenuItem(
              icon: FontAwesomeIcons.lock,
              title: 'Đổi mật khẩu',
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/change-password');
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildExpandableSection({
    required IconData icon,
    required String title,
    required bool isExpanded,
    required VoidCallback onTap,
    required List<Widget> children,
  }) {
    final isDark = context.isDark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C2C2E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF38383A) : Colors.grey[200]!,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.2)
                : Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF3A3A3C)
                          : Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDark
                            ? const Color(0xFF38383A)
                            : Colors.grey[200]!,
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: FaIcon(
                        icon,
                        color: context.primaryColor,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: context.textPrimary,
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: context.textSecondary,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
              child: Column(children: children),
            ),
            crossFadeState: isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }

  Widget _buildSubMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        child: Row(
          children: [
            FaIcon(icon, color: context.textSecondary, size: 16),
            const SizedBox(width: 14),
            Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: context.textPrimary.withValues(alpha: 0.85),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    final isDark = context.isDark;
    return GestureDetector(
      onTap: () => widget.onAction(HvglMenuAction.logout),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2C2C2E) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.error.withValues(alpha: isDark ? 0.3 : 0.2),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.2)
                  : Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(
              FontAwesomeIcons.rightFromBracket,
              color: AppColors.error,
              size: 18,
            ),
            const SizedBox(width: 12),
            Text(
              'Đăng xuất',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.error,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuItemData {
  final IconData icon;
  final String label;
  final Color color;
  final Color bgColor;
  final Color darkBgColor;
  final HvglMenuAction action;

  _MenuItemData({
    required this.icon,
    required this.label,
    required this.color,
    required this.bgColor,
    required this.darkBgColor,
    required this.action,
  });
}
