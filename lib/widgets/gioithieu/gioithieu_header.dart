import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/api_endpoints.dart';
import '../../core/extensions/theme_extensions.dart';

class GioithieuHeader extends StatefulWidget {
  const GioithieuHeader({super.key});

  @override
  State<GioithieuHeader> createState() => _GioithieuHeaderState();
}

class _GioithieuHeaderState extends State<GioithieuHeader> {
  bool _imageReady = false;

  void _markReady() {
    if (!_imageReady) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _imageReady = true);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    return Center(
      child: Column(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF2C2C2E) : Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withValues(alpha: 0.3)
                      : AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: AnimatedOpacity(
                opacity: _imageReady ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeIn,
                child: CachedNetworkImage(
                  imageUrl: ApiEndpoints.logoHeader,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  fadeInDuration: Duration.zero,
                  fadeOutDuration: Duration.zero,
                  imageBuilder: (context, imageProvider) {
                    _markReady();
                    return Image(image: imageProvider, fit: BoxFit.cover);
                  },
                  placeholder: (context, url) => const SizedBox.shrink(),
                  errorWidget: (context, url, error) {
                    _markReady();
                    return Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: AppColors.primaryGradient,
                        ),
                      ),
                      child: const Center(
                        child: FaIcon(
                          FontAwesomeIcons.hospital,
                          size: 46,
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Bệnh viện Hùng Vượng Gia Lai',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
              color: isDark ? Colors.white : const Color(0xFF1A1A1A),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Phiên bản 1.0.0',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
