import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/api_endpoints.dart';

class GioithieuLogo extends StatefulWidget {
  const GioithieuLogo({super.key});

  @override
  State<GioithieuLogo> createState() => _GioithieuLogoState();
}

class _GioithieuLogoState extends State<GioithieuLogo> {
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
    return Center(
      child: Column(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
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
          const Text(
            'Bệnh viện Hùng Vương Gia Lai',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
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
