import 'package:flutter/material.dart';

class ExpandTransition extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;

  const ExpandTransition({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 800),
    this.curve = Curves.easeInOutCubic,
  });

  @override
  State<ExpandTransition> createState() => _ExpandTransitionState();
}

class _ExpandTransitionState extends State<ExpandTransition>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 30.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        widget.child,
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Positioned.fill(
              child: IgnorePointer(
                child: Container(
                  color: Colors.transparent,
                  child: Center(
                    child: Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Container(
                        width: size.width,
                        height: size.width,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(
                            alpha: _fadeAnimation.value,
                          ),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class ExpandPageRoute extends PageRouteBuilder {
  final Widget page;

  ExpandPageRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: const Duration(milliseconds: 1200),
          reverseTransitionDuration: const Duration(milliseconds: 600),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
                ),
              ),
              child: child,
            );
          },
        );
}
