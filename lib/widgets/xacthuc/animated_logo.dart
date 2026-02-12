import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/api_endpoints.dart';
import '../../core/constants/app_colors.dart';

class AnimatedLogo extends StatelessWidget {
  final double size;
  final bool showBackground;

  const AnimatedLogo({
    super.key,
    this.size = 100,
    this.showBackground = false,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'app_logo',
      child: Container(
        width: size,
        height: size,
        decoration: showBackground
            ? BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              )
            : null,
        child: ClipOval(
          child: CachedNetworkImage(
            imageUrl: ApiEndpoints.logoHeader,
            fit: BoxFit.cover,
            placeholder: (context, url) => const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.primary,
              ),
            ),
            errorWidget: (context, url, error) => Icon(
              Icons.local_hospital,
              color: showBackground ? AppColors.primary : Colors.white,
              size: size * 0.5,
            ),
          ),
        ),
      )
          .animate()
          .scale(duration: 600.ms, curve: Curves.easeOutBack)
          .fade(duration: 1200.ms),
    );
  }
}
