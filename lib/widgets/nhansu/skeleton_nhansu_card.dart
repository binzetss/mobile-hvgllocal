import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SkeletonNhansuCard extends StatelessWidget {
  final Color? departmentColor;

  const SkeletonNhansuCard({
    super.key,
    this.departmentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _SkeletonBox(
            width: 44,
            height: 44,
            borderRadius: 12,
            color: Colors.grey[300]!,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SkeletonBox(
                  width: double.infinity,
                  height: 16,
                  borderRadius: 4,
                  color: Colors.grey[300]!,
                ),
                const SizedBox(height: 6),
                _SkeletonBox(
                  width: 120,
                  height: 14,
                  borderRadius: 4,
                  color: Colors.grey[200]!,
                ),
                const SizedBox(height: 6),
                _SkeletonBox(
                  width: 100,
                  height: 12,
                  borderRadius: 4,
                  color: Colors.grey[200]!,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _SkeletonBox(
            width: 20,
            height: 20,
            borderRadius: 4,
            color: Colors.grey[200]!,
          ),
        ],
      ),
    )
        .animate(
          onPlay: (controller) => controller.repeat(),
        )
        .shimmer(
          duration: const Duration(milliseconds: 1500),
          color: Colors.white.withValues(alpha: 0.6),
          angle: 0,
        );
  }
}

class _SkeletonBox extends StatelessWidget {
  final double? width;
  final double height;
  final double borderRadius;
  final Color color;

  const _SkeletonBox({
    this.width,
    required this.height,
    required this.borderRadius,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}
