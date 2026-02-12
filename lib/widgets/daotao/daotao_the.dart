import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/daotao_model.dart';

class DaotaoThe extends StatelessWidget {
  final DaotaoModel lopDaoTao;
  final VoidCallback? onTap;

  const DaotaoThe({
    super.key,
    required this.lopDaoTao,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: statusColor.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: AppColors.shadowLight,
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
           
              Container(
                width: 4,
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                ),
              ),
       
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
         
                      Row(
                        children: [
                          _buildTrangThaiBadge(statusColor),
                          if (lopDaoTao.isNew) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFFF6B6B),
                                    Color(0xFFEE5A24),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'MỚI',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ],
                          const Spacer(),
       
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              FaIcon(
                                FontAwesomeIcons.bookOpen,
                                size: 11,
                                color: AppColors.textSecondary.withValues(alpha: 0.6),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                '${lopDaoTao.soTiet} tiết',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textSecondary.withValues(alpha: 0.7),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
             
                      Text(
                        lopDaoTao.tenLopDaoTao,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                          height: 1.4,
                          letterSpacing: -0.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 14),
                
                      Container(
                        height: 1,
                        color: AppColors.border.withValues(alpha: 0.1),
                      ),
                      const SizedBox(height: 12),
             
                      Row(
                        children: [
                          Expanded(
                            child: _buildInfoChip(
                              icon: FontAwesomeIcons.graduationCap,
                              text: _formatDate(lopDaoTao.ngayBatDau),
                              label: 'Ngày học',
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 32,
                            margin: const EdgeInsets.symmetric(horizontal: 12),
                            color: AppColors.border.withValues(alpha: 0.15),
                          ),
                          Expanded(
                            child: _buildInfoChip(
                              icon: FontAwesomeIcons.penToSquare,
                              text: _formatDate(lopDaoTao.ngayKetThucDangKy),
                              label: 'Hạn đăng ký',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
           
              Container(
                padding: const EdgeInsets.only(right: 12),
                alignment: Alignment.center,
                child: FaIcon(
                  FontAwesomeIcons.chevronRight,
                  size: 12,
                  color: AppColors.textSecondary.withValues(alpha: 0.3),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String text,
    required String label,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary.withValues(alpha: 0.6),
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            FaIcon(
              icon,
              size: 11,
              color: AppColors.primary.withValues(alpha: 0.7),
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTrangThaiBadge(Color color) {
    String text;
    IconData icon;

    if (lopDaoTao.dangMoDangKy) {
      text = 'Đang mở';
      icon = FontAwesomeIcons.circleCheck;
    } else if (lopDaoTao.chuaMoDangKy) {
      text = 'Sắp mở';
      icon = FontAwesomeIcons.clock;
    } else {
      text = 'Đã đóng';
      icon = FontAwesomeIcons.lock;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(icon, size: 10, color: color),
          const SizedBox(width: 5),
          Text(
            text,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: color,
              letterSpacing: 0.1,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor() {
    if (lopDaoTao.dangMoDangKy) return const Color(0xFF10B981);
    if (lopDaoTao.chuaMoDangKy) return const Color(0xFFF59E0B);
    return const Color(0xFF9CA3AF);
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final compareDate = DateTime(date.year, date.month, date.day);

    if (today == compareDate) {
      return 'Hôm nay';
    }
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
