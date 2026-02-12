import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class AppButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final double? width;
  final double height;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? textColor;
  final double fontSize;
  final FontWeight fontWeight;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.width,
    this.height = 50,
    this.borderRadius = 14,
    this.backgroundColor,
    this.textColor,
    this.fontSize = 17,
    this.fontWeight = FontWeight.w600,
  });

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> with SingleTickerProviderStateMixin {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final bgColor = widget.backgroundColor ?? AppColors.primary;

    return GestureDetector(
      onTapDown: widget.isLoading ? null : (_) => setState(() => _isPressed = true),
      onTapUp: widget.isLoading ? null : (_) => setState(() => _isPressed = false),
      onTapCancel: widget.isLoading ? null : () => setState(() => _isPressed = false),
      onTap: widget.isLoading ? null : widget.onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
        width: widget.width ?? double.infinity,
        height: widget.height,
        decoration: BoxDecoration(
          color: widget.isOutlined
              ? Colors.transparent
              : (widget.isLoading
                  ? bgColor.withValues(alpha: 0.6)
                  : (_isPressed
                      ? bgColor.withValues(alpha: 0.8)
                      : bgColor)),
          borderRadius: BorderRadius.circular(widget.borderRadius),
          border: widget.isOutlined
              ? Border.all(
                  color: _isPressed
                      ? bgColor.withValues(alpha: 0.6)
                      : bgColor,
                  width: 1.5,
                )
              : null,
          boxShadow: widget.isOutlined || widget.isLoading
              ? null
              : [
                  BoxShadow(
                    color: bgColor.withValues(alpha: _isPressed ? 0.15 : 0.25),
                    blurRadius: _isPressed ? 8 : 12,
                    offset: Offset(0, _isPressed ? 2 : 4),
                  ),
                ],
        ),
        child: Center(
          child: widget.isLoading
              ? SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      widget.isOutlined ? AppColors.primary : AppColors.textWhite,
                    ),
                  ),
                )
              : Text(
                  widget.text,
                  style: TextStyle(
                    fontSize: widget.fontSize,
                    fontWeight: widget.fontWeight,
                    letterSpacing: -0.4,
                    color: widget.isOutlined
                        ? bgColor
                        : (widget.textColor ?? AppColors.textWhite),
                  ),
                ),
        ),
      ),
    );
  }
}
