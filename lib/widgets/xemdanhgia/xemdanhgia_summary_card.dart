import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/xemdanhgia_model.dart';

class XemDanhGiaSummaryCard extends StatelessWidget {
  final List<XemDanhGiaModel> list;

  const XemDanhGiaSummaryCard({super.key, required this.list});

  @override
  Widget build(BuildContext context) {
    final categoryCount = <String, int>{};
    for (final e in list) {
      categoryCount[e.danhMuc] = (categoryCount[e.danhMuc] ?? 0) + 1;
    }
    final topCategory = categoryCount.entries.isEmpty
        ? ''
        : (categoryCount.entries.toList()
              ..sort((a, b) => b.value.compareTo(a.value)))
            .first
            .key;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: AppColors.primaryGradient,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGradient.last.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _StatItem(
              icon: FontAwesomeIcons.commentDots,
              value: '${list.length}',
              label: 'Tổng góp ý',
            ),
          ),
          Container(width: 1, height: 48, color: Colors.white24),
          Expanded(
            child: _StatItem(
              icon: FontAwesomeIcons.tag,
              value: topCategory,
              label: 'Nhiều nhất',
              smallValue: true,
            ),
          ),
          Container(width: 1, height: 48, color: Colors.white24),
          Expanded(
            child: _StatItem(
              icon: FontAwesomeIcons.users,
              value: '${list.map((e) => e.maSo).toSet().length}',
              label: 'Nhân viên',
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final bool smallValue;

  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
    this.smallValue = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FaIcon(icon, color: Colors.white70, size: 16),
        const SizedBox(height: 8),
        Text(
          value,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: smallValue ? 13 : 22,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            height: 1,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Colors.white70),
        ),
      ],
    );
  }
}
