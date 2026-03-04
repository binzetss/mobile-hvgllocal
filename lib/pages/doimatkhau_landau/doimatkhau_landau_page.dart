import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/extensions/theme_extensions.dart';
import '../../core/routes/app_routes.dart';
import '../../providers/xacthuc_provider.dart';
import '../../providers/doimatkhau_landau_provider.dart';
import '../../data/services/data_preload_service.dart';
import '../../widgets/doimatkhau_landau/doimatkhau_landau_header.dart';
import '../../widgets/doimatkhau_landau/doimatkhau_landau_form.dart';

class DoimatkhauLandauPage extends StatelessWidget {
  const DoimatkhauLandauPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = kIsWeb && MediaQuery.of(context).size.width >= 768;
    final hoVaTen =
        context.read<XacthucProvider>().user?.hoVaTen?.trim() ?? 'Bạn';

    return ChangeNotifierProvider(
      create: (_) => DoimatkhauLandauProvider(),
      child: PopScope(
        canPop: false,
        child: isDesktop
            ? _WebLandauPage(
                hoVaTen: hoVaTen,
                onSuccess: () => _handleSuccess(context),
              )
            : _MobileLandauPage(
                hoVaTen: hoVaTen,
                onSuccess: () => _handleSuccess(context),
              ),
      ),
    );
  }

  Future<void> _handleSuccess(BuildContext context) async {
    await context.read<XacthucProvider>().markFirstLoginDone();
    if (!context.mounted) return;
    DataPreloadService().preloadAllData(context);
    Navigator.of(context)
        .pushNamedAndRemoveUntil(AppRoutes.home, (route) => false);
  }
}

class _MobileLandauPage extends StatelessWidget {
  final String hoVaTen;
  final VoidCallback onSuccess;

  const _MobileLandauPage(
      {required this.hoVaTen, required this.onSuccess});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.bgColor,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            DoimatkhauLandauHeader(hoVaTen: hoVaTen),
            DoimatkhauLandauForm(onSuccess: onSuccess),
          ],
        ),
      ),
    );
  }
}

class _WebLandauPage extends StatelessWidget {
  final String hoVaTen;
  final VoidCallback onSuccess;

  const _WebLandauPage(
      {required this.hoVaTen, required this.onSuccess});

  static const List<(IconData, String)> _tips = [
    (FontAwesomeIcons.lock, 'Không chia sẻ mật khẩu với bất kỳ ai'),
    (FontAwesomeIcons.rotate, 'Thay đổi mật khẩu định kỳ mỗi 3 tháng'),
    (FontAwesomeIcons.shieldHalved, 'Dùng ký tự đặc biệt để tăng bảo mật'),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Scaffold(
      backgroundColor: context.bgColor,
      body: Row(
        children: [

          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? [
                          AppColors.primaryDark.withValues(alpha: 0.7),
                          const Color(0xFF1C1C1E),
                        ]
                      : AppColors.primaryGradient,
                ),
              ),
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(48),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.18),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.3),
                            width: 2,
                          ),
                        ),
                        child: const Center(
                          child: FaIcon(
                            FontAwesomeIcons.shieldHalved,
                            size: 36,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      const Text(
                        'Bảo mật\ntài khoản',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          height: 1.2,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Xin chào, $hoVaTen.',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Đây là lần đầu tiên bạn đăng nhập. Vui lòng đặt mật khẩu mới để bảo vệ tài khoản trước khi sử dụng ứng dụng.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withValues(alpha: 0.75),
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 40),
                      ..._tips.map(
                        (t) => Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: Row(
                            children: [
                              Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  color:
                                      Colors.white.withValues(alpha: 0.15),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: FaIcon(t.$1,
                                      size: 13, color: Colors.white),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                t.$2,
                                style: TextStyle(
                                  fontSize: 13,
                                  color:
                                      Colors.white.withValues(alpha: 0.85),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          Container(
            width: 480,
            color: context.bgColor,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                  horizontal: 24, vertical: 32),
              child: DoimatkhauLandauForm(onSuccess: onSuccess),
            ),
          ),
        ],
      ),
    );
  }
}
