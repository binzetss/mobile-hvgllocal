import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/constants/app_colors.dart';

class DocumentMetaRow extends StatelessWidget {
  final String date;
  final String fileId;

  const DocumentMetaRow({
    super.key,
    required this.date,
    required this.fileId,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const FaIcon(
          FontAwesomeIcons.clock,
          size: 14,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: 6),
        Text(
          date,
          style: TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary.withValues(alpha: 0.8),
          ),
        ),
        const SizedBox(width: 16),
        const FaIcon(
          FontAwesomeIcons.hashtag,
          size: 14,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: 6),
        Text(
          'ID: $fileId',
          style: TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }
}
