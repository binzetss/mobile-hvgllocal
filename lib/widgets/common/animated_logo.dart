import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/api_endpoints.dart';

class AnimatedLogo extends StatelessWidget {
  final double size;
  final bool showBorderCircles;
  final bool showGlow;

  const AnimatedLogo({
    super.key,
    this.size = 200,
    this.showBorderCircles = true,
    this.showGlow = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [

          if (showBorderCircles)
            Container(
              width: size * 1.5,
              height: size * 1.5,
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
                .rotate(duration: 10000.ms, curve: Curves.linear),

          if (showBorderCircles)
            Container(
              width: size * 1.25,
              height: size * 1.25,
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
                ),

          if (showBorderCircles)
            Container(
              width: size * 1.1,
              height: size * 1.1,
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
                .rotate(duration: 5000.ms, curve: Curves.linear),

          if (showGlow)
            Container(
              width: size,
              height: size,
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

          if (showGlow)
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.4),
                  width: 3,
                ),
              ),
            )
                .animate(
                  onPlay: (controller) => controller.repeat(),
                )
                .fadeOut(duration: 2500.ms)
                .scale(
                  begin: const Offset(1.0, 1.0),
                  end: const Offset(1.5, 1.5),
                  duration: 2500.ms,
                  curve: Curves.easeOut,
                ),

          if (showGlow)
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.3),
                  width: 2.5,
                ),
              ),
            )
                .animate(
                  onPlay: (controller) => controller.repeat(),
                )
                .fadeOut(delay: 800.ms, duration: 2500.ms)
                .scale(
                  delay: 800.ms,
                  begin: const Offset(1.0, 1.0),
                  end: const Offset(1.5, 1.5),
                  duration: 2500.ms,
                  curve: Curves.easeOut,
                ),

          if (showGlow)
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.25),
                  width: 2,
                ),
              ),
            )
                .animate(
                  onPlay: (controller) => controller.repeat(),
                )
                .fadeOut(delay: 1600.ms, duration: 2500.ms)
                .scale(
                  delay: 1600.ms,
                  begin: const Offset(1.0, 1.0),
                  end: const Offset(1.5, 1.5),
                  duration: 2500.ms,
                  curve: Curves.easeOut,
                ),

          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).cardColor,
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
              ),

          SizedBox(
            width: size,
            height: size,
            child: Padding(
              padding: EdgeInsets.all(size * 0.15),
              child: kIsWeb
                  ? Image.asset(
                      'assets/images/logo_splash.png',
                      fit: BoxFit.contain,
                    )
                  : Image.network(
                      ApiEndpoints.logoHeader,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.local_hospital,
                          size: size * 0.5,
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
    );
  }
}
