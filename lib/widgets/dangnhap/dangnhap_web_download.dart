import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

/// Section hiển thị QR code để người dùng quét và tải app
/// Đặt URL thực của app store vào các hằng bên dưới
class DangnhapWebDownload extends StatelessWidget {
  const DangnhapWebDownload({super.key});

  // TODO: Thay bằng URL thực khi app được publish
  static const _iosUrl =
      'https://apps.apple.com/app/hvgl';
  static const _androidUrl =
      'https://play.google.com/store/apps/details?id=vn.hvgl.app';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'TẢI ỨNG DỤNG',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.80),
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            _QrCard(
              icon: Icons.apple,
              platform: 'iOS',
              store: 'App Store',
              url: _iosUrl,
            ),
            SizedBox(width: 16),
            _QrCard(
              icon: Icons.android,
              platform: 'Android',
              store: 'Google Play',
              url: _androidUrl,
            ),
          ],
        ),
      ],
    );
  }
}

class _QrCard extends StatelessWidget {
  final IconData icon;
  final String platform;
  final String store;
  final String url;

  const _QrCard({
    required this.icon,
    required this.platform,
    required this.store,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.35),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // QR code
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: QrImageView(
              data: url,
              version: QrVersions.auto,
              size: 120,
              backgroundColor: Colors.white,
              padding: const EdgeInsets.all(6),
            ),
          ),

          const SizedBox(height: 8),

          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: 14),
              const SizedBox(width: 4),
              Text(
                platform,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            store,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.70),
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
