import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/qr_scanner_provider.dart';
import '../../providers/navigation_provider.dart';
import '../../widgets/chamcong/qr_scanner_overlay.dart';
import '../../widgets/chamcong/qr_scanner_frame.dart';
import '../../widgets/chamcong/qr_scanner_instructions.dart';
import '../../widgets/chamcong/qr_result_dialog.dart';

class QrScannerPage extends StatefulWidget {
  const QrScannerPage({super.key});

  @override
  State<QrScannerPage> createState() => _QrScannerPageState();
}

class _QrScannerPageState extends State<QrScannerPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => QrScannerProvider()..resumeScanning(),
      child: Scaffold(
        backgroundColor: Colors.black,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          toolbarHeight: 0,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
          ),
        ),
        body: Consumer<QrScannerProvider>(
          builder: (context, provider, _) {
            return Stack(
              children: [
                _buildCameraBackground(),

                const QrScannerOverlay(),

                _buildTopBar(context, provider),

                const Center(child: QrScannerFrame()),

                const QrScannerInstructions(),

                if (provider.state == ScannerState.success ||
                    provider.state == ScannerState.error)
                  QrResultDialog(
                    isSuccess: provider.state == ScannerState.success,
                    message: provider.state == ScannerState.success
                        ? 'Chấm công thành công!'
                        : provider.errorMessage ?? 'Quét QR thất bại',
                    onClose: () {
                      provider.resetScanner();
                    },
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildCameraBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1a1a2e), Color(0xFF0f0f1e), Color(0xFF16213e)],
        ),
      ),
      child: CustomPaint(
        painter: GridPatternPainter(),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.05),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.1),
                width: 2,
              ),
            ),
            child: FaIcon(
              FontAwesomeIcons.qrcode,
              size: 80,
              color: Colors.white.withValues(alpha: 0.15),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, QrScannerProvider provider) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                context.read<NavigationProvider>().setIndex(0);
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: const Icon(
                  Icons.arrow_back_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),

            GestureDetector(
              onTap: provider.toggleFlash,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: provider.isFlashOn
                      ? AppColors.primary.withValues(alpha: 0.9)
                      : Colors.black.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: provider.isFlashOn
                        ? AppColors.primary
                        : Colors.white.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: FaIcon(
                  provider.isFlashOn
                      ? FontAwesomeIcons.solidLightbulb
                      : FontAwesomeIcons.lightbulb,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GridPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.03)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const gridSize = 40.0;

    for (double i = 0; i < size.width; i += gridSize) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }

    for (double i = 0; i < size.height; i += gridSize) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
