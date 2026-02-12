import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/qr_scanner_provider.dart';

class QrScannerFrame extends StatefulWidget {
  const QrScannerFrame({super.key});

  @override
  State<QrScannerFrame> createState() => _QrScannerFrameState();
}

class _QrScannerFrameState extends State<QrScannerFrame>
    with SingleTickerProviderStateMixin {
  late AnimationController _scanLineController;

  @override
  void initState() {
    super.initState();
    _scanLineController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _scanLineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<QrScannerProvider>(
      builder: (context, provider, _) {
        return SizedBox(
          width: 280,
          height: 280,
          child: Stack(
            children: [
              // Corner Borders
              ..._buildCorners(),

              // Scanning Line Animation
              if (provider.isScanning)
                AnimatedBuilder(
                  animation: _scanLineController,
                  builder: (context, child) {
                    return Positioned(
                      left: 0,
                      right: 0,
                      top: _scanLineController.value * 260,
                      child: Container(
                        height: 3,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              AppColors.primary,
                              Colors.transparent,
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.6),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

              // Center dot
              Center(
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.5),
                        blurRadius: 10,
                        spreadRadius: 3,
                      ),
                    ],
                  ),
                )
                    .animate(onPlay: (controller) => controller.repeat())
                    .fadeIn(duration: 800.ms)
                    .then()
                    .fadeOut(duration: 800.ms),
              ),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildCorners() {
    const cornerSize = 30.0;
    const borderWidth = 4.0;

    return [
      // Top Left
      Positioned(
        top: 0,
        left: 0,
        child: Container(
          width: cornerSize,
          height: cornerSize,
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: AppColors.primary,
                width: borderWidth,
              ),
              left: BorderSide(
                color: AppColors.primary,
                width: borderWidth,
              ),
            ),
          ),
        )
            .animate(onPlay: (controller) => controller.repeat(reverse: true))
            .fade(begin: 0.7, duration: 1000.ms),
      ),

      // Top Right
      Positioned(
        top: 0,
        right: 0,
        child: Container(
          width: cornerSize,
          height: cornerSize,
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: AppColors.primary,
                width: borderWidth,
              ),
              right: BorderSide(
                color: AppColors.primary,
                width: borderWidth,
              ),
            ),
          ),
        )
            .animate(onPlay: (controller) => controller.repeat(reverse: true))
            .fade(begin: 0.7, duration: 1000.ms, delay: 100.ms),
      ),

      // Bottom Left
      Positioned(
        bottom: 0,
        left: 0,
        child: Container(
          width: cornerSize,
          height: cornerSize,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: AppColors.primary,
                width: borderWidth,
              ),
              left: BorderSide(
                color: AppColors.primary,
                width: borderWidth,
              ),
            ),
          ),
        )
            .animate(onPlay: (controller) => controller.repeat(reverse: true))
            .fade(begin: 0.7, duration: 1000.ms, delay: 200.ms),
      ),

      // Bottom Right
      Positioned(
        bottom: 0,
        right: 0,
        child: Container(
          width: cornerSize,
          height: cornerSize,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: AppColors.primary,
                width: borderWidth,
              ),
              right: BorderSide(
                color: AppColors.primary,
                width: borderWidth,
              ),
            ),
          ),
        )
            .animate(onPlay: (controller) => controller.repeat(reverse: true))
            .fade(begin: 0.7, duration: 1000.ms, delay: 300.ms),
      ),
    ];
  }
}
