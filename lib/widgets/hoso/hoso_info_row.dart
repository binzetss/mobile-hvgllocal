import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class HosoInfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isLast;

  const HosoInfoRow({
    super.key,
    required this.label,
    required this.value,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 130,
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary.withValues(alpha: 0.85),
                    letterSpacing: -0.1,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  value.isEmpty ? '-' : value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: value.isEmpty
                        ? AppColors.textSecondary.withValues(alpha: 0.4)
                        : AppColors.textPrimary,
                    letterSpacing: -0.2,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (!isLast)
          Divider(
            height: 1,
            color: AppColors.border.withValues(alpha: 0.15),
          ),
      ],
    );
  }
}
