import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: SizedBox(
            height: 68,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                    child: Container(
                      height: 68,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.5),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.shadowMedium,
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildNavItem(
                            index: 0,
                            icon: FontAwesomeIcons.house,
                            activeIcon: FontAwesomeIcons.house,
                            label: AppStrings.navHome,
                          ),
                          _buildNavItem(
                            index: 1,
                            icon: FontAwesomeIcons.fileLines,
                            activeIcon: FontAwesomeIcons.fileLines,
                            label: AppStrings.navDocument,
                          ),
                          const SizedBox(width: 56),
                          _buildNavItem(
                            index: 3,
                            icon: FontAwesomeIcons.clock,
                            activeIcon: FontAwesomeIcons.clock,
                            label: AppStrings.navTimeKeeping,
                          ),
                          _buildNavItem(
                            index: 4,
                            icon: FontAwesomeIcons.userGroup,
                            activeIcon: FontAwesomeIcons.userGroup,
                            label: AppStrings.navContacts,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: -6,
                  child: _buildCenterButton(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
  }) {
    final isSelected = currentIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: FaIcon(
                  isSelected ? activeIcon : icon,
                  color: isSelected ? AppColors.primary : AppColors.iconGrey,
                  size: 20,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10.5,
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.textSecondary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  height: 1.2,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCenterButton() {
    return GestureDetector(
      onTap: () => onTap(2),
      child: Container(
        width: 58,
        height: 58,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: AppColors.primaryGradient,
          ),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 4),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.35),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: FaIcon(
            FontAwesomeIcons.qrcode,
            color: Colors.white,
            size: 26,
          ),
        ),
      ),
    );
  }
}
