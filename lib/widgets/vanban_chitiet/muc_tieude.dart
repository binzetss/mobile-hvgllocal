import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class TitleSection extends StatelessWidget {
  final String title;

  const TitleSection({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        letterSpacing: -0.5,
        height: 1.3,
      ),
    );
  }
}
