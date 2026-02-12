import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/thongbao_model.dart';
import '../../providers/thongbao_provider.dart';
import '../../providers/vanban_provider.dart';
import '../../pages/vanban/vanban_chitiet_page.dart';

class ThongBaoDetailModal extends StatelessWidget {
  final ThongBao thongBao;
  final ThongBaoProvider provider;

  const ThongBaoDetailModal({
    super.key,
    required this.thongBao,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            thongBao.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            thongBao.content,
            style: TextStyle(
              fontSize: 15,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(
                Icons.access_time,
                size: 16,
                color: AppColors.textSecondary.withValues(alpha: 0.6),
              ),
              const SizedBox(width: 6),
              Text(
                _formatFullDate(thongBao.time),
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              if (thongBao.type == 'vanban') ...[
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _handleViewDocument(context),
                    icon: const FaIcon(
                      FontAwesomeIcons.eye,
                      size: 16,
                    ),
                    label: const Text(
                      'Xem ngay',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: BorderSide(
                      color: AppColors.textSecondary.withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Đóng',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _handleViewDocument(BuildContext context) async {
    try {
      final vanbanProvider = context.read<VanbanProvider>();
      final document = await provider.navigateToDocument(
        thongBao.id,
        vanbanProvider,
      );

      if (!context.mounted) return;

      if (document != null) {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VanbanChitietPage(document: document),
          ),
        );

        if (!context.mounted) return;
        Navigator.pop(context);
      }
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  String _formatFullDate(DateTime date) {
    final hours = date.hour.toString().padLeft(2, '0');
    final minutes = date.minute.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$hours:$minutes - $day/$month/${date.year}';
  }
}
