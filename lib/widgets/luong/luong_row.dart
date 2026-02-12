import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class LuongRow extends StatelessWidget {
  final String label;
  final String formattedValue;
  final String? subtitle;
  final bool isHighlight;
  final bool isPositive;
  final bool isNegative;
  final double value;

  const LuongRow({
    super.key,
    required this.label,
    required this.formattedValue,
    this.subtitle,
    this.isHighlight = false,
    this.isPositive = false,
    this.isNegative = false,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    Color valueColor = AppColors.textPrimary;
    if (isPositive && value > 0) {
      valueColor = AppColors.success;
    } else if (isNegative && value < 0) {
      valueColor = AppColors.error;
    } else if (isHighlight) {
      valueColor = AppColors.primary;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isHighlight ? FontWeight.w600 : FontWeight.w400,
                    color: isHighlight
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary.withValues(alpha: 0.7),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              formattedValue,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isHighlight ? FontWeight.w700 : FontWeight.w600,
                color: valueColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
