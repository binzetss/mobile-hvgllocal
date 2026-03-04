import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

const _kGreen = Color(0xFF34C759);
const _kRed = Color(0xFFFF3B30);
const _kBlue = Color(0xFF1877F2);

void showSuccessDialog(
  BuildContext context, {
  required String title,
  required String message,
  Duration autoCloseDuration = const Duration(milliseconds: 2200),
}) {
  final overlay = Overlay.of(context);
  late OverlayEntry entry;

  entry = OverlayEntry(
    builder: (_) => IgnorePointer(
      child: _AnimatedToast(
        icon: Icons.check_rounded,
        accentColor: _kGreen,
        title: title,
        message: message,
        duration: autoCloseDuration,
      ),
    ),
  );

  overlay.insert(entry);

  Future.delayed(autoCloseDuration + const Duration(milliseconds: 300), () {
    entry.remove();
  });
}

void showErrorDialog(
  BuildContext context, {
  String title = 'Không thành công',
  required String message,
}) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: '',
    barrierColor: Colors.black.withValues(alpha: 0.45),
    transitionDuration: const Duration(milliseconds: 320),
    pageBuilder: (_, _, _) => const SizedBox.shrink(),
    transitionBuilder: (ctx, anim, _, _) {
      return ScaleTransition(
        scale: CurvedAnimation(parent: anim, curve: Curves.easeOutBack),
        child: FadeTransition(
          opacity: CurvedAnimation(parent: anim, curve: Curves.easeOut),
          child: _AlertModal(
            icon: Icons.close_rounded,
            accentColor: _kRed,
            title: title,
            message: message,
            buttonText: 'Đóng',
            onButton: () => Navigator.of(ctx).pop(),
          ),
        ),
      );
    },
  );
}

void showInfoDialog(
  BuildContext context, {
  required String title,
  required String message,
  String buttonText = 'Đóng',
}) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: '',
    barrierColor: Colors.black.withValues(alpha: 0.45),
    transitionDuration: const Duration(milliseconds: 320),
    pageBuilder: (_, _, _) => const SizedBox.shrink(),
    transitionBuilder: (ctx, anim, _, _) {
      return ScaleTransition(
        scale: CurvedAnimation(parent: anim, curve: Curves.easeOutBack),
        child: FadeTransition(
          opacity: CurvedAnimation(parent: anim, curve: Curves.easeOut),
          child: _AlertModal(
            icon: Icons.info_outline_rounded,
            accentColor: _kBlue,
            title: title,
            message: message,
            buttonText: buttonText,
            onButton: () => Navigator.of(ctx).pop(),
          ),
        ),
      );
    },
  );
}

class _AnimatedToast extends StatefulWidget {
  const _AnimatedToast({
    required this.icon,
    required this.accentColor,
    required this.title,
    required this.message,
    required this.duration,
  });

  final IconData icon;
  final Color accentColor;
  final String title;
  final String message;
  final Duration duration;

  @override
  State<_AnimatedToast> createState() => _AnimatedToastState();
}

class _AnimatedToastState extends State<_AnimatedToast>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
    );
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);

    _slide = Tween<Offset>(
      begin: kIsWeb ? const Offset(1.0, 0.0) : const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));

    _ctrl.forward();

    Future.delayed(widget.duration, () {
      if (mounted) _ctrl.reverse();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF1C1C1E) : Colors.white;
    final titleColor = isDark ? Colors.white : const Color(0xFF1C1C1E);
    final subtitleColor = isDark ? const Color(0xFF8E8E93) : const Color(0xFF8E8E93);
    final shadowColor = isDark
        ? Colors.black.withValues(alpha: 0.5)
        : Colors.black.withValues(alpha: 0.13);

    final toastContent = Material(
      color: Colors.transparent,
      child: Container(
        constraints: kIsWeb
            ? const BoxConstraints(maxWidth: 360)
            : const BoxConstraints(),
        margin: kIsWeb
            ? const EdgeInsets.only(top: 20, right: 20)
            : const EdgeInsets.fromLTRB(12, 0, 12, 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: isDark
              ? Border.all(color: const Color(0xFF38383A), width: 0.5)
              : null,
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              blurRadius: 28,
              spreadRadius: 0,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: kIsWeb ? MainAxisSize.min : MainAxisSize.max,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: widget.accentColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(widget.icon, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 12),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: titleColor,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    widget.message,
                    style: TextStyle(
                      fontSize: 13,
                      color: subtitleColor,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: Align(
          alignment:
              kIsWeb ? Alignment.topRight : Alignment.bottomCenter,
          child: SafeArea(child: toastContent),
        ),
      ),
    );
  }
}

class _AlertModal extends StatelessWidget {
  const _AlertModal({
    required this.icon,
    required this.accentColor,
    required this.title,
    required this.message,
    required this.buttonText,
    required this.onButton,
  });

  final IconData icon;
  final Color accentColor;
  final String title;
  final String message;
  final String buttonText;
  final VoidCallback onButton;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF1C1C1E) : Colors.white;
    final titleColor = isDark ? Colors.white : const Color(0xFF1C1C1E);
    final messageColor =
        isDark ? const Color(0xFF8E8E93) : const Color(0xFF8E8E93);
    final dividerColor =
        isDark ? const Color(0xFF38383A) : const Color(0xFFF0F0F0);

    return Center(
      child: Material(
        color: Colors.transparent,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 40),
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(22),
              border: isDark
                  ? Border.all(
                      color: const Color(0xFF38383A), width: 0.5)
                  : null,
              boxShadow: [
                BoxShadow(
                  color: Colors.black
                      .withValues(alpha: isDark ? 0.5 : 0.18),
                  blurRadius: 32,
                  spreadRadius: 0,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: accentColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, color: Colors.white, size: 30),
                ),
                const SizedBox(height: 18),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: titleColor,
                    height: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 14,
                    color: messageColor,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 22),
                Container(height: 1, color: dividerColor),
                const SizedBox(height: 4),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: onButton,
                    style: TextButton.styleFrom(
                      foregroundColor: accentColor,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      buttonText,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: accentColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
