import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/vanban_model.dart';
import '../../providers/vanban_provider.dart';
import '../common/shimmer_loading.dart';
import 'vanban_the.dart';

class VanbanDocumentsList extends StatelessWidget {
  final Function(VanbanModel) onDocumentTap;

  const VanbanDocumentsList({
    super.key,
    required this.onDocumentTap,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<VanbanProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: const ShimmerLoading(
                    width: double.infinity,
                    height: 160,
                    borderRadius: 16,
                  ),
                ),
                childCount: 5,
              ),
            ),
          );
        }

        if (provider.hasError) {
          return SliverFillRemaining(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FaIcon(
                    FontAwesomeIcons.circleExclamation,
                    size: 60,
                    color: AppColors.error.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Đã xảy ra lỗi',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      provider.errorMessage ?? 'Không thể tải dữ liệu',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary.withValues(alpha: 0.8),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => provider.refresh(),
                    icon: const FaIcon(
                        FontAwesomeIcons.arrowRotateRight,
                        size: 18),
                    label: const Text('Thử lại'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        if (provider.documents.isEmpty) {
          return SliverFillRemaining(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FaIcon(
                    FontAwesomeIcons.fileLines,
                    size: 60,
                    color: AppColors.textSecondary.withValues(alpha: 0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    provider.searchQuery.isNotEmpty
                        ? 'Không tìm thấy văn bản'
                        : 'Chưa có văn bản nào',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary.withValues(alpha: 0.5),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    provider.searchQuery.isNotEmpty
                        ? 'Thử tìm kiếm với từ khóa khác'
                        : 'Các văn bản sẽ được hiển thị tại đây',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final document = provider.documents[index];
                return VanbanCard(
                  document: document,
                  onTap: () => onDocumentTap(document),
                );
              },
              childCount: provider.documents.length,
            ),
          ),
        );
      },
    );
  }
}
