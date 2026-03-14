import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/daotao_provider.dart';
import '../common/shimmer_loading.dart';
import 'daotao_the.dart';

class DaotaoDanhSach extends StatelessWidget {
  const DaotaoDanhSach({super.key});

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
                    const Text(
                      'Chưa có dữ liệu',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Các khóa học sẽ được hiển thị tại đây',
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
                return DaotaoThe(lopDaoTao: lopDaoTao);
              },
              childCount: provider.danhSach.length,
            ),
          ),
        );
      },
    );
  }
}
