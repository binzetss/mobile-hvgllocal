import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class AppPageTransitions {
  AppPageTransitions._();

  static Route fadeTransition(Widget page) {
    return PageTransition(
      type: PageTransitionType.fade,
      duration: const Duration(milliseconds: 300),
      reverseDuration: const Duration(milliseconds: 250),
      child: page,
      curve: Curves.easeInOut,
    );
  }

  static Route scaleTransition(Widget page) {
    return PageTransition(
      type: PageTransitionType.scale,
      alignment: Alignment.center,
      duration: const Duration(milliseconds: 350),
      reverseDuration: const Duration(milliseconds: 300),
      child: page,
      curve: Curves.easeOutCubic,
    );
  }

  static Route slideRightTransition(Widget page) {
    return PageTransition(
      type: PageTransitionType.rightToLeft,
      duration: const Duration(milliseconds: 300),
      reverseDuration: const Duration(milliseconds: 250),
      child: page,
      curve: Curves.easeOutCubic,
    );
  }

  static Route slideUpTransition(Widget page) {
    return PageTransition(
      type: PageTransitionType.bottomToTop,
      duration: const Duration(milliseconds: 350),
      reverseDuration: const Duration(milliseconds: 300),
      child: page,
      curve: Curves.easeOutCubic,
    );
  }

  static Route rotateFadeTransition(Widget page) {
    return PageTransition(
      type: PageTransitionType.rotate,
      alignment: Alignment.center,
      duration: const Duration(milliseconds: 400),
      reverseDuration: const Duration(milliseconds: 350),
      child: page,
      curve: Curves.easeInOutCubic,
    );
  }

  static Route sizeTransition(Widget page) {
    return PageTransition(
      type: PageTransitionType.size,
      alignment: Alignment.center,
      duration: const Duration(milliseconds: 350),
      reverseDuration: const Duration(milliseconds: 300),
      child: page,
      curve: Curves.easeOutCubic,
    );
  }

  static Route smoothSlideTransition(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: const Duration(milliseconds: 350),
      reverseTransitionDuration: const Duration(milliseconds: 300),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        final tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: Curves.easeOutCubic),
        );
        final offsetAnimation = animation.drive(tween);
        final fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: animation,
            curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
          ),
        );

        return SlideTransition(
          position: offsetAnimation,
          child: FadeTransition(
            opacity: fadeAnimation,
            child: child,
          ),
        );
      },
    );
  }

  static Route heroZoomTransition(Widget page, {String? tag}) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: const Duration(milliseconds: 400),
      reverseTransitionDuration: const Duration(milliseconds: 350),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
          CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          ),
        );
        final fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: animation,
            curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
          ),
        );

        return ScaleTransition(
          scale: scaleAnimation,
          child: FadeTransition(
            opacity: fadeAnimation,
            child: child,
          ),
        );
      },
    );
  }
}
