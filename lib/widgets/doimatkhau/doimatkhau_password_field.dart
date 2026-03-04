import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/constants/app_colors.dart';
import '../../core/extensions/theme_extensions.dart';

class DoimatkhauPasswordField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool isVisible;
  final VoidCallback onToggleVisibility;
  final String? Function(String?)? validator;

  const DoimatkhauPasswordField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    required this.isVisible,
    required this.onToggleVisibility,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final textColor = isDark ? Colors.white : const Color(0xFF1A1A1A);
    final fillColor = isDark ? const Color(0xFF2C2C2E) : const Color(0xFFF8F9FA);
    final borderColor = isDark ? const Color(0xFF38383A) : const Color(0xFFE8EAF0);

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
              child: FaIcon(
                icon,
                size: 14,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: textColor,
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: controller,
          obscureText: !isVisible,
          validator: validator,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
          decoration: InputDecoration(
            hintText: 'Nhập $label',
            hintStyle: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: isDark ? Colors.grey[500] : Colors.grey[400],
            ),
            filled: true,
            fillColor: fillColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: borderColor,
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: borderColor,
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFFE53935),
                width: 1.5,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFFE53935),
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            suffixIcon: IconButton(
              icon: FaIcon(
                isVisible ? FontAwesomeIcons.eye : FontAwesomeIcons.eyeSlash,
                size: 18,
                color: Colors.grey[600],
              ),
              onPressed: onToggleVisibility,
            ),
          ),
        ),
      ],
    );
  }
}
