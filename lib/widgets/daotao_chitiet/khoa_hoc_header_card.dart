import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/daotao_model.dart';

class KhoaHocHeaderCard extends StatelessWidget {
  final DaotaoModel lopDaoTao;

  const KhoaHocHeaderCard({
    super.key,
    required this.lopDaoTao,
  });

  Color _getStatusColor() {
    if (lopDaoTao.dangMoDangKy) {
      return const Color.fromARGB(255, 149, 245, 93);
    }
    if (lopDaoTao.chuaMoDangKy) return const Color.fromARGB(255, 247, 209, 143);
    return const Color.fromARGB(255, 61, 61, 61);
  }

  String _getStatusText() {
    if (lopDaoTao.dangMoDangKy) return 'Đang mở đăng ký';
    if (lopDaoTao.chuaMoDangKy) return 'Chưa mở đăng ký';
    return 'Đã đóng đăng ký';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withValues(alpha: 0.95),
            AppColors.primary,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 12,
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
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: _getStatusColor().withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _getStatusColor().withValues(alpha: 0.3),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      lopDaoTao.dangMoDangKy
                          ? Icons.check_circle_rounded
                          : lopDaoTao.chuaMoDangKy
                              ? Icons.schedule_rounded
                              : Icons.lock_rounded,
                      size: 13,
                      color: _getStatusColor(),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      _getStatusText(),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: _getStatusColor(),
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ),
              if (lopDaoTao.isNew) ...[
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFFFF6B6B),
                        Color(0xFFFF8E53),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFF6B6B)
                            .withValues(alpha: 0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
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
            ],
          ),
          const SizedBox(height: 12),
          Text(
            lopDaoTao.tenLopDaoTao,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              height: 1.3,
              letterSpacing: -0.3,
              shadows: [
                Shadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: Offset(0, 1),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
