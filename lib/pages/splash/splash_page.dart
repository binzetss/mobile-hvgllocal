import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/api_endpoints.dart';
import '../../core/routes/app_routes.dart';

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
    await Future.delayed(const Duration(milliseconds: 3300));
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final maxDimension = screenSize.width > screenSize.height ? screenSize.width * 1.5 : screenSize.height * 1.5;

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
        child: Stack(
          children: [
     
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                 
                      Container(
                        width: 300,
                        height: 300,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.2),
                            width: 2,
                          ),
                        ),
                      )
                          .animate(
                            onPlay: (controller) => controller.repeat(),
                          )
                          .rotate(duration: 10000.ms, curve: Curves.linear)
                          .then(delay: 2400.ms)
                          .fadeOut(duration: 300.ms, curve: Curves.easeIn),

                    
                      Container(
                        width: 250,
                        height: 250,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.15),
                            width: 2,
                          ),
                        ),
                      )
                          .animate(
                            onPlay: (controller) => controller.repeat(),
                          )
                          .rotate(
                            duration: 7000.ms,
                            curve: Curves.linear,
                            begin: 1,
                            end: 0,
                          )
                          .then(delay: 2400.ms)
                          .fadeOut(duration: 300.ms, curve: Curves.easeIn),

      
                      Container(
                        width: 220,
                        height: 220,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.1),
                            width: 1,
                          ),
                        ),
                      )
                          .animate(
                            onPlay: (controller) => controller.repeat(),
                          )
                          .rotate(duration: 5000.ms, curve: Curves.linear)
                          .then(delay: 2400.ms)
                          .fadeOut(duration: 300.ms, curve: Curves.easeIn),

                  
                      Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withValues(alpha: 0.3),
                              blurRadius: 80,
                              spreadRadius: 30,
                            ),
                          ],
                        ),
                      )
                          .animate(
                            onPlay: (controller) => controller.repeat(reverse: true),
                          )
                          .fadeIn(duration: 2000.ms)
                          .fadeOut(delay: 2000.ms, duration: 2000.ms),

       
                      Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 40,
                              offset: const Offset(0, 15),
                            ),
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 20,
                              spreadRadius: -5,
                              offset: const Offset(0, 5),
                            ),
                            BoxShadow(
                              color: Colors.white.withValues(alpha: 0.9),
                              blurRadius: 15,
                              spreadRadius: -5,
                              offset: const Offset(0, -5),
                            ),
                          ],
                        ),
                      )
                          .animate()
                          .fadeIn(duration: 800.ms, curve: Curves.easeOut)
                          .scale(
                            begin: const Offset(0.3, 0.3),
                            end: const Offset(1.0, 1.0),
                            duration: 900.ms,
                            curve: Curves.easeOutBack,
                          )
                          .then(delay: 1700.ms)
                          .scale(
                            duration: 600.ms,
                            begin: const Offset(1.0, 1.0),
                            end: Offset(maxDimension / 180, maxDimension / 180),
                            curve: Curves.easeInCubic,
                          ),

         
                      SizedBox(
                        width: 200,
                        height: 200,
                        child: Padding(
                          padding: const EdgeInsets.all(30),
                          child: Image.network(
                            ApiEndpoints.logoHeader,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.local_hospital,
                                size: 100,
                                color: AppColors.primary,
                              );
                            },
                          ),
                        ),
                      )
                          .animate()
                          .fadeIn(duration: 800.ms, curve: Curves.easeOut)
                          .scale(
                            begin: const Offset(0.3, 0.3),
                            end: const Offset(1.0, 1.0),
                            duration: 900.ms,
                            curve: Curves.easeOutBack,
                          )
                          .then(delay: 300.ms)
                          .shimmer(
                            duration: 1400.ms,
                            color: Colors.white.withValues(alpha: 0.6),
                          ),
                    ],
                  ),

                  const SizedBox(height: 40),

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
                        Shadow(
                          color: Colors.black38,
                          offset: Offset(0, 1),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 500.ms, duration: 700.ms)
                      .slideY(
                        begin: 0.5,
                        end: 0,
                        delay: 500.ms,
                        duration: 700.ms,
                        curve: Curves.easeOutCubic,
                      )
                      .then(delay: 1200.ms)
                      .fadeOut(duration: 500.ms, curve: Curves.easeIn),

                  const SizedBox(height: 12),

                  const Text(
                    'HÙNG VƯƠNG GIA LAI',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
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
                        Shadow(
                          color: Colors.black38,
                          offset: Offset(0, 2),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 700.ms, duration: 700.ms)
                      .slideY(
                        begin: 0.5,
                        end: 0,
                        delay: 700.ms,
                        duration: 700.ms,
                        curve: Curves.easeOutCubic,
                      )
                      .then(delay: 200.ms)
                      .shimmer(
                        duration: 1000.ms,
                        color: Colors.white.withValues(alpha: 0.3),
                      )
                      .then(delay: 100.ms)
                      .fadeOut(duration: 500.ms, curve: Curves.easeIn),

                  const SizedBox(height: 60),

                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.1),
                        ),
                      ),
                      SizedBox(
                        width: 42,
                        height: 42,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white.withValues(alpha: 0.9),
                          ),
                          strokeWidth: 3.5,
                          strokeCap: StrokeCap.round,
                        ),
                      ),
                    ],
                  )
                      .animate(
                        onPlay: (controller) => controller.repeat(),
                      )
                      .fadeIn(delay: 1200.ms, duration: 500.ms)
                      .scale(
                        delay: 1200.ms,
                        duration: 500.ms,
                        begin: const Offset(0.8, 0.8),
                        end: const Offset(1.0, 1.0),
                      )
                      .then(delay: 700.ms)
                      .fadeOut(duration: 500.ms, curve: Curves.easeIn),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
