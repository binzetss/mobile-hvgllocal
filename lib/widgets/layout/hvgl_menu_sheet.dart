import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
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
  bool _isHelpExpanded = false;
  bool _isSettingsExpanded = false;

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
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFFF0F2F5),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF007AFF), Color(0xFF00BFA5)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF007AFF).withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: FaIcon(
                      FontAwesomeIcons.hospital,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'HÙNG VƯƠNG GIA LAI',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.5,
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
        action: HvglMenuAction.salary,
      ),
      _MenuItemData(
        icon: FontAwesomeIcons.calendarCheck,
        label: 'Lịch trực',
        color: const Color(0xFF2196F3),
        bgColor: const Color(0xFFE3F2FD),
        action: HvglMenuAction.dutySchedule,
      ),
      _MenuItemData(
        icon: FontAwesomeIcons.stethoscope,
        label: 'Lịch khám',
        color: const Color(0xFF9C27B0),
        bgColor: const Color(0xFFF3E5F5),
        action: HvglMenuAction.clinicSchedule,
      ),
      _MenuItemData(
        icon: FontAwesomeIcons.graduationCap,
        label: 'Đào tạo',
        color: const Color(0xFFE91E63),
        bgColor: const Color(0xFFFCE4EC),
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
    return GestureDetector(
      onTap: () => widget.onAction(item.action),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
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
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: item.bgColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: FaIcon(item.icon, color: item.color, size: 20),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              item.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandableSections() {
    return Column(
      children: [
        _buildNavigationItem(
          icon: FontAwesomeIcons.comment,
          title: 'Góp ý và đánh giá',
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/gopykien');
          },
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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
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
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F2F5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: FaIcon(
                        icon,
                        color: AppColors.textPrimary,
                        size: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: AppColors.textSecondary,
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

  Widget _buildNavigationItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F2F5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: FaIcon(
                    icon,
                    color: AppColors.textPrimary,
                    size: 18,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textSecondary,
                size: 24,
              ),
            ],
          ),
        ),
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
            FaIcon(icon, color: AppColors.textSecondary, size: 16),
            const SizedBox(width: 14),
            Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary.withValues(alpha: 0.85),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return GestureDetector(
      onTap: () => widget.onAction(HvglMenuAction.logout),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(
              FontAwesomeIcons.rightFromBracket,
              color: AppColors.error,
              size: 18,
            ),
            SizedBox(width: 12),
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
  final HvglMenuAction action;

  _MenuItemData({
    required this.icon,
    required this.label,
    required this.color,
    required this.bgColor,
    required this.action,
  });
}
