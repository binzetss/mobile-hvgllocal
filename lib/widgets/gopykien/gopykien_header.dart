import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/constants/app_colors.dart';
import '../../core/extensions/theme_extensions.dart';

class GopyKienHeader extends StatelessWidget {
  const GopyKienHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [AppColors.primaryDark, AppColors.primaryLight]
              : AppColors.primaryGradient,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: const [
          FaIcon(
            FontAwesomeIcons.commentDots,
            size: 40,
            color: Colors.white,
          ),
          SizedBox(height: 16),
          Text(
            'Ý kiến của bạn rất quan trọng',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
