import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class AppCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?>? onChanged;
  final String? label;
  final Color? activeColor;
  final Color? checkColor;

  const AppCheckbox({
    super.key,
    required this.value,
    this.onChanged,
    this.label,
    this.activeColor,
    this.checkColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onChanged != null ? () => onChanged!(!value) : null,
      borderRadius: BorderRadius.circular(4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: Checkbox(
              value: value,
              onChanged: onChanged,
              activeColor: activeColor ?? AppColors.primary,
              checkColor: checkColor ?? AppColors.textWhite,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              side: const BorderSide(
                color: AppColors.border,
                width: 1.5,
              ),
            ),
          ),
          if (label != null) ...[
            const SizedBox(width: 8),
            Text(
              label!,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
