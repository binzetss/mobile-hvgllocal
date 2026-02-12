import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/daotao_provider.dart';

class DaotaoKetQuaBoLoc extends StatelessWidget {
  final DaotaoProvider provider;
  final TextEditingController searchController;

  const DaotaoKetQuaBoLoc({
    super.key,
    required this.provider,
    required this.searchController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        children: [
          Text(
            '${provider.danhSach.length} khóa học',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary.withValues(alpha: 0.7),
              letterSpacing: 0.1,
            ),
          ),
          const Spacer(),
          if (provider.locTrangThai != 'all' || provider.tuKhoa.isNotEmpty)
            GestureDetector(
              onTap: () {
                searchController.clear();
                provider.resetFilters();
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FaIcon(
                    FontAwesomeIcons.filterCircleXmark,
                    size: 12,
                    color: AppColors.primary.withValues(alpha: 0.7),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Xóa bộ lọc',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primary.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
