import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/xacthuc_provider.dart';
import '../../widgets/common/app_dialogs.dart';
import '../../widgets/dangnhap/dangnhap_animated_background.dart';
import '../../widgets/dangnhap/dangnhap_header.dart';
import '../../widgets/dangnhap/dangnhap_login_card.dart';
import '../../widgets/dangnhap/dangnhap_footer.dart';
import '../../widgets/dangnhap/dangnhap_success_overlay.dart';
import '../../widgets/dangnhap/dangnhap_web_background.dart';
import '../../widgets/dangnhap/dangnhap_web_header.dart';
import '../../widgets/dangnhap/dangnhap_web_card.dart';
import '../../widgets/dangnhap/dangnhap_web_footer.dart';
import '../../widgets/dangnhap/dangnhap_web_download.dart';
import '../../data/services/data_preload_service.dart';
import '../trangchu/trangchu_page.dart';
import '../doimatkhau_landau/doimatkhau_landau_page.dart';

class DangnhapPage extends StatefulWidget {
  const DangnhapPage({super.key});

  @override
  State<DangnhapPage> createState() => _DangnhapPageState();
}

class _DangnhapPageState extends State<DangnhapPage>
    with TickerProviderStateMixin {

  final _formKey = GlobalKey<FormState>();
  final _maSoController = TextEditingController();
  final _matKhauController = TextEditingController();

  late AnimationController _gradientController;
  late AnimationController _particleController;
  late XacthucProvider _authProviderRef;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _listenToProviderInit();
  }

  @override
  void dispose() {
    _authProviderRef.removeListener(_onProviderChanged);
    _gradientController.dispose();
    _particleController.dispose();
    _maSoController.dispose();
    _matKhauController.dispose();
    super.dispose();
  }

  void _initAnimations() {
    _gradientController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);

    _particleController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();
  }

  void _listenToProviderInit() {
    if (!mounted) return;
    _authProviderRef = context.read<XacthucProvider>();
    if (_authProviderRef.isInitialized) {
      _initCredentials();
    } else {
      _authProviderRef.addListener(_onProviderChanged);
    }
  }

  void _onProviderChanged() {
    if (!mounted) return;
    final authProvider = context.read<XacthucProvider>();
    if (authProvider.isInitialized) {
      _initCredentials();
      authProvider.removeListener(_onProviderChanged);
    }
  }

  void _initCredentials() {
    if (!mounted) return;
    final authProvider = context.read<XacthucProvider>();
    _maSoController.text = authProvider.savedUsername;
    _matKhauController.text = authProvider.savedPassword;
  }

  Future<void> _handleLogin() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final authProvider = context.read<XacthucProvider>();
    final success = await authProvider.performLogin(
      _maSoController.text.trim(),
      _matKhauController.text,
    );

    if (!mounted) return;

    if (success) {
      await _showLoginSuccessAnimation();
      if (!mounted) return;

      if (authProvider.isFirstLogin) {
        _navigateToFirstLogin();
      } else {

        DataPreloadService().reset();
        DataPreloadService().preloadAllData(context);
        if (!mounted) return;
        _navigateToHome();
      }
    } else {
      _showLoginError(authProvider.errorMessage);
    }
  }

  Future<void> _showLoginSuccessAnimation() async {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (context) => const DangnhapSuccessOverlay(),
    );
    overlay.insert(overlayEntry);
    await Future.delayed(const Duration(milliseconds: 900));
    overlayEntry.remove();
  }

  void _navigateToFirstLogin() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, _, _) => const DoimatkhauLandauPage(),
        transitionDuration: Duration.zero,
      ),
    );
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, _, _) => const TrangchuPage(),
        transitionDuration: Duration.zero,
      ),
    );
  }

  void _showLoginError(String? errorMessage) {
    showErrorDialog(
      context,
      title: 'Đăng nhập thất bại',
      message: errorMessage ??
          'Mã số hoặc mật khẩu không đúng.\nVui lòng kiểm tra lại.',
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = kIsWeb && MediaQuery.of(context).size.width >= 768;
    if (isDesktop) return _buildWebLayout(context);
    return _buildMobileLayout(context);
  }

  Widget _buildMobileLayout(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          DangnhapAnimatedBackground(
            gradientController: _gradientController,
            particleController: _particleController,
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: size.height -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      const DangnhapHeader(),
                      const SizedBox(height: 60),
                      DangnhapLoginCard(
                        formKey: _formKey,
                        maSoController: _maSoController,
                        matKhauController: _matKhauController,
                        onSubmit: _handleLogin,
                      ),
                      const Spacer(),
                      const DangnhapFooter(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWebLayout(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          DangnhapWebBackground(controller: _gradientController),

          Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 48, vertical: 32),
                  child: Row(
                    children: [

                      Expanded(
                        child: Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 420),
                            child: DangnhapWebCard(
                              formKey: _formKey,
                              maSoController: _maSoController,
                              matKhauController: _matKhauController,
                              onSubmit: _handleLogin,
                            ),
                          ),
                        ),
                      ),

                      Container(
                        width: 1,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        color: Colors.white.withValues(alpha: 0.25),
                      ),

                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const DangnhapWebHeader(),
                            const SizedBox(height: 48),
                            const DangnhapWebDownload(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const DangnhapWebFooter(),
            ],
          ),
        ],
      ),
    );
  }
}
