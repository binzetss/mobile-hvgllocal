import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/xacthuc_provider.dart';
import '../../widgets/common/app_dialogs.dart';
import '../../widgets/dangnhap/dangnhap_animated_background.dart';
import '../../widgets/dangnhap/dangnhap_header.dart';
import '../../widgets/dangnhap/dangnhap_login_card.dart';
import '../../widgets/dangnhap/dangnhap_footer.dart';
import '../../widgets/dangnhap/dangnhap_success_overlay.dart';
import '../../data/services/data_preload_service.dart';
import '../trangchu/trangchu_page.dart';

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

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _listenToProviderInit();
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

    // Listen for when provider finishes initialization
    final authProvider = context.read<XacthucProvider>();
    if (authProvider.isInitialized) {
      // Already initialized, load credentials immediately
      _initCredentials();
    } else {
      // Not initialized yet, listen for changes
      authProvider.addListener(_onProviderChanged);
    }
  }

  void _onProviderChanged() {
    if (!mounted) return; // Check if widget is still mounted

    final authProvider = context.read<XacthucProvider>();
    if (authProvider.isInitialized) {
      _initCredentials();
      // Remove listener after loading credentials once
      authProvider.removeListener(_onProviderChanged);
    }
  }

  void _initCredentials() {
    if (!mounted) return; // Check if widget is still mounted

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


      DataPreloadService().preloadAllData(context);

      if (!mounted) return;
      _navigateToHome();
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

  void _navigateToHome() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const TrangchuPage(),
        transitionDuration: Duration.zero,
      ),
    );
  }
  void _showLoginError(String? errorMessage) {
    showErrorDialog(
      context,
      title: 'Đăng nhập thất bại',
      message: errorMessage ?? 'Mã số hoặc mật khẩu không đúng.\nVui lòng kiểm tra lại.',
    );
  }

  @override
  void dispose() {
    try {
      final authProvider = context.read<XacthucProvider>();
      authProvider.removeListener(_onProviderChanged);
    } catch (e) {
      // Provider might not be available during dispose
    }
    _gradientController.dispose();
    _particleController.dispose();
    _maSoController.dispose();
    _matKhauController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  minHeight:
                      size.height -
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
}
