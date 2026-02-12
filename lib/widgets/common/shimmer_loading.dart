import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/constants/app_colors.dart';

class ShimmerLoading extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ShimmerLoading({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.background,
      highlightColor: Colors.white,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

class ShimmerCard extends StatelessWidget {
  const ShimmerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const ShimmerLoading(width: 4, height: 24, borderRadius: 3),
              const SizedBox(width: 12),
              const Expanded(
                child: ShimmerLoading(width: double.infinity, height: 20, borderRadius: 8),
              ),
              const SizedBox(width: 12),
              ShimmerLoading(width: 80, height: 28, borderRadius: 14),
            ],
          ),
          const SizedBox(height: 16),
          const ShimmerLoading(width: double.infinity, height: 100, borderRadius: 16),
        ],
      ),
    );
  }
}

class ShimmerListTile extends StatelessWidget {
  const ShimmerListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          ShimmerLoading(width: 48, height: 48, borderRadius: 24),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerLoading(width: double.infinity, height: 16, borderRadius: 8),
                SizedBox(height: 8),
                ShimmerLoading(width: 150, height: 12, borderRadius: 6),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
