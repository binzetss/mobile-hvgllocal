import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/vanban_model.dart';

class VanbanCard extends StatelessWidget {
  final VanbanModel document;
  final VoidCallback? onTap;

  const VanbanCard({
    super.key,
    required this.document,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.border.withValues(alpha: 0.1),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 12,
                offset: const Offset(0, 2),
              ),
              BoxShadow(
                color: _getCategoryColor().withValues(alpha: 0.08),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          _getCategoryColor().withValues(alpha: 0.15),
                          _getCategoryColor().withValues(alpha: 0.08),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _getCategoryColor().withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      document.categoryName,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: _getCategoryColor(),
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (document.isNew)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFFFF6B6B),
                            Color(0xFFFF8E53),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFF6B6B)
                                .withValues(alpha: 0.3),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Text(
                        'MỚI',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  const Spacer(),
                  if (document.isPdfFile)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Row(
                        children: [
                          FaIcon(
                            FontAwesomeIcons.filePdf,
                            size: 12,
                            color: AppColors.primary,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'PDF',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                document.fileName,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                  height: 1.4,
                  letterSpacing: -0.2,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              if (document.soKiHieu.isNotEmpty) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    const FaIcon(
                      FontAwesomeIcons.hashtag,
                      size: 11,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        document.soKiHieu,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                          height: 1.4,
                          letterSpacing: -0.1,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 12),
              Row(
                children: [
                  const FaIcon(
                    FontAwesomeIcons.calendar,
                    size: 12,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _formatDate(document.uploadedAt),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary.withValues(alpha: 0.8),
                      letterSpacing: -0.1,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getCategoryColor() {
    // Màu mặc định dựa trên categoryId
    final colors = [
      AppColors.primary,
      const Color(0xFF8E44AD),
      AppColors.warning,
      AppColors.error,
      const Color(0xFF16A085),
      AppColors.success,
      const Color(0xFFE67E22),
      const Color(0xFF3498DB),
    ];

    if (document.categoryId > 0 && document.categoryId <= colors.length) {
      return colors[document.categoryId - 1];
    }

    return AppColors.textSecondary;
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final compareDate = DateTime(date.year, date.month, date.day);

    if (today == compareDate) {
      return 'Hôm nay ${_formatTime(date)}';
    } else {
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    }
  }

  String _formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
