import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/firebase_notification_service.dart';
import '../../providers/chamcong_provider.dart';
import '../../providers/qr_scanner_provider.dart';
import '../../providers/navigation_provider.dart';
import '../../providers/thongbao_provider.dart';
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
  final MobileScannerController _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
  );

  late final QrScannerProvider _scannerProvider;
  bool _notificationFired = false;

  @override
  void initState() {
    super.initState();
    _scannerProvider = QrScannerProvider()..resumeScanning();
    _scannerProvider.addListener(_onScannerStateChanged);
  }

  @override
  void dispose() {
    _scannerProvider.removeListener(_onScannerStateChanged);
    _scannerProvider.dispose();
    _controller.dispose();
    super.dispose();
  }

  /// Lắng nghe thay đổi state — bắn notification ngay khi scan thành công
  void _onScannerStateChanged() {
    if (!mounted) return;

    if (_scannerProvider.state == ScannerState.success && !_notificationFired) {
      _notificationFired = true;
      final time = DateTime.now();
      // Dùng postFrameCallback để tránh setState/notifyListeners trong build cycle
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        // Bắn local push notification
        FirebaseNotificationService().showChamcongNotification(time: time);
        // Ghi vào mục thông báo trong app
        context.read<ThongBaoProvider>().addChamcongNotification(time: time);
      });
    }

    // Reset flag khi scanner quay về scanning (cho lần scan tiếp theo)
    if (_scannerProvider.state == ScannerState.scanning) {
      _notificationFired = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _scannerProvider,
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
                MobileScanner(
                  controller: _controller,
                  onDetect: (BarcodeCapture capture) {
                    for (final barcode in capture.barcodes) {
                      final code = barcode.rawValue;
                      if (code != null && provider.isScanning) {
                        provider.onQRCodeScanned(code);
                        break;
                      }
                    }
                  },
                ),

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
                      final wasSuccess = provider.state == ScannerState.success;
                      provider.resetScanner();
                      if (wasSuccess) {
                        context.read<ChamcongProvider>().refresh();
                      }
                    },
                  ),
              ],
            );
          },
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
              onTap: () {
                _controller.toggleTorch();
                provider.toggleFlash();
              },
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
