import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/bosung_chamcong_model.dart';

class BosungcongSessionSelector extends StatelessWidget {
  final SessionType selectedSession;
  final ValueChanged<SessionType> onSessionChanged;

  const BosungcongSessionSelector({
    super.key,
    required this.selectedSession,
    required this.onSessionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const FaIcon(
                FontAwesomeIcons.clock,
                size: 12,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'Buổi',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _SessionOption(
                label: 'Sáng',
                icon: FontAwesomeIcons.sun,
                isSelected: selectedSession == SessionType.morning,
                onTap: () => onSessionChanged(SessionType.morning),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _SessionOption(
                label: 'Chiều',
                icon: FontAwesomeIcons.cloudSun,
                isSelected: selectedSession == SessionType.afternoon,
                onTap: () => onSessionChanged(SessionType.afternoon),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SessionOption extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _SessionOption({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            gradient: isSelected
                ? const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: AppColors.primaryGradient,
                  )
                : null,
            color: isSelected ? null : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected
                  ? AppColors.primary.withValues(alpha: 0.3)
                  : AppColors.border.withValues(alpha: 0.2),
              width: isSelected ? 1.5 : 0.5,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: AppColors.shadowLight,
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FaIcon(
                icon,
                size: 18,
                color: isSelected ? Colors.white : AppColors.primary,
              ),
              const SizedBox(width: 10),
              Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? Colors.white : AppColors.textPrimary,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
