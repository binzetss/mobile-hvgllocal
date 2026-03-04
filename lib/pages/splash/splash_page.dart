import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../core/constants/api_endpoints.dart';
import '../../core/routes/app_routes.dart';
import '../../providers/xacthuc_provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _navigateToLogin();
  }

  Future<void> _navigateToLogin() async {
    await Future.delayed(const Duration(milliseconds: 2000));
    if (!mounted) return;
    final auth = context.read<XacthucProvider>();
    final isLoggedIn = await auth.checkAuthStatus();
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed(
      isLoggedIn ? AppRoutes.home : AppRoutes.login,
    );
  }

  @override
  Widget build(BuildContext context) {

    final screenSize = MediaQuery.of(context).size;

    final maxDimension = screenSize.width > screenSize.height
        ? screenSize.width * 1.5
        : screenSize.height * 1.5;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF007AFF),
              Color(0xFF5AC8FA),
              Color(0xFF007AFF),
            ],
          ),
        ),
        child: Center(
          child: _buildContent(context, maxDimension),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, double maxDimension) {

    final isDesktop = kIsWeb && MediaQuery.of(context).size.width >= 768;

    final content = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [

            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).cardColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 40,
                    offset: const Offset(0, 15),
                  ),
                ],
              ),
            )
                .animate()
                .fadeIn(duration: 300.ms, curve: Curves.easeOut)
                .scale(
                  begin: const Offset(0.85, 0.85),
                  end: const Offset(1.0, 1.0),
                  duration: 300.ms,
                  curve: Curves.easeOut,
                )
                .then(delay: 150.ms)
                .scale(
                  duration: 1550.ms,
                  begin: const Offset(1.0, 1.0),
                  end: Offset(maxDimension / 180, maxDimension / 180),
                  curve: Curves.easeInCubic,
                ),

            SizedBox(
              width: 200,
              height: 200,
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: kIsWeb
                    ? Image.asset(
                        'assets/images/logo_splash.png',
                        fit: BoxFit.contain,
                      )
                    : Image.network(
                        ApiEndpoints.logoHeader,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.local_hospital,
                            size: 100,
                            color: Color(0xFF007AFF),
                          );
                        },
                      ),
              ),
            )
                .animate()
                .fadeIn(duration: 300.ms, curve: Curves.easeOut)
                .scale(
                  begin: const Offset(0.85, 0.85),
                  end: const Offset(1.0, 1.0),
                  duration: 300.ms,
                  curve: Curves.easeOut,
                ),
          ],
        ),

        const SizedBox(height: 32),

        const Text(
          'NỘI BỘ',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: 6,
            height: 1.3,
            shadows: [
              Shadow(
                color: Color(0xFF003D7A),
                offset: Offset(0, 3),
                blurRadius: 8,
              ),
            ],
          ),
        ).animate().fadeIn(delay: 100.ms, duration: 300.ms),

        const SizedBox(height: 8),

        const Text(
          'HÙNG VƯƠNG GIA LAI',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            letterSpacing: 2,
            height: 1.2,
            shadows: [
              Shadow(
                color: Color(0xFF003D7A),
                offset: Offset(0, 4),
                blurRadius: 12,
              ),
            ],
          ),
        ).animate().fadeIn(delay: 150.ms, duration: 300.ms),
      ],
    );

    if (!isDesktop) return content;

    return SizedBox(
      width: 480,
      child: content,
    );
  }
}
