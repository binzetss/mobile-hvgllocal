import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/daotao_model.dart';
import '../../providers/daotao_provider.dart';
import '../common/shimmer_loading.dart';
import 'daotao_the.dart';

class DaotaoDanhSach extends StatelessWidget {
  final Function(DaotaoModel) onItemTap;

  const DaotaoDanhSach({
    super.key,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<DaotaoProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: const ShimmerLoading(
                    width: double.infinity,
                    height: 150,
                    borderRadius: 16,
                  ),
                ),
                childCount: 4,
              ),
            ),
          );
        }

        if (provider.hasError) {
          return SliverFillRemaining(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.error.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Center(
                        child: FaIcon(
                          FontAwesomeIcons.triangleExclamation,
                          size: 32,
                          color: AppColors.error.withValues(alpha: 0.6),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Không thể tải dữ liệu',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      provider.errorMessage ?? 'Đã xảy ra lỗi. Vui lòng thử lại.',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary.withValues(alpha: 0.7),
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    GestureDetector(
                      onTap: () => provider.refresh(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            FaIcon(
                              FontAwesomeIcons.arrowRotateRight,
                              size: 14,
                              color: Colors.white,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Thử lại',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        if (provider.danhSach.isEmpty) {
          return SliverFillRemaining(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Center(
                        child: FaIcon(
                          FontAwesomeIcons.graduationCap,
                          size: 32,
                          color: AppColors.primary.withValues(alpha: 0.4),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      provider.tuKhoa.isNotEmpty
                          ? 'Không tìm thấy khóa học'
                          : 'Chưa có khóa học nào',
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      provider.tuKhoa.isNotEmpty
                          ? 'Thử tìm kiếm với từ khóa khác'
                          : 'Các khóa học sẽ được hiển thị tại đây',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final lopDaoTao = provider.danhSach[index];
                return DaotaoThe(
                  lopDaoTao: lopDaoTao,
                  onTap: () => onItemTap(lopDaoTao),
                );
              },
              childCount: provider.danhSach.length,
            ),
          ),
        );
      },
    );
  }
}
