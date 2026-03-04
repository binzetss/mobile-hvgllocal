import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/extensions/theme_extensions.dart';
import '../../providers/xacthuc_provider.dart';

class DangnhapWebCard extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController maSoController;
  final TextEditingController matKhauController;
  final VoidCallback onSubmit;

  const DangnhapWebCard({
    super.key,
    required this.formKey,
    required this.maSoController,
    required this.matKhauController,
    required this.onSubmit,
  });

  @override
  State<DangnhapWebCard> createState() => _DangnhapWebCardState();
}

class _DangnhapWebCardState extends State<DangnhapWebCard> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.10),
            blurRadius: 48,
            offset: const Offset(0, 20),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [

          Container(
            height: 4,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF4599FF), const Color(0xFF60AFFF)]
                    : [
                        const Color(0xFF0D47A1),
                        const Color(0xFF1976D2),
                        const Color(0xFF42A5F5),
                      ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(36, 28, 36, 36),
            child: Consumer<XacthucProvider>(
              builder: (context, auth, _) {
                return Form(
                  key: widget.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [

                      Text(
                        'Đăng nhập',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: context.textPrimary,
                          letterSpacing: -0.3,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Chào mừng bạn trở lại',
                        style: TextStyle(
                          fontSize: 14,
                          color: context.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 28),

                      _buildLabel(context, 'Tên đăng nhập'),
                      const SizedBox(height: 6),
                      _buildTextField(
                        context: context,
                        controller: widget.maSoController,
                        hint: 'Nhập tên đăng nhập',
                        icon: Icons.person_outline_rounded,
                        isPassword: false,
                        validator: (v) => (v == null || v.isEmpty)
                            ? 'Vui lòng nhập tài khoản'
                            : null,
                      ),

                      const SizedBox(height: 16),

                      _buildLabel(context, 'Mật khẩu'),
                      const SizedBox(height: 6),
                      _buildTextField(
                        context: context,
                        controller: widget.matKhauController,
                        hint: 'Nhập mật khẩu',
                        icon: Icons.lock_outline_rounded,
                        isPassword: true,
                        validator: (v) => (v == null || v.isEmpty)
                            ? 'Vui lòng nhập mật khẩu'
                            : null,
                      ),

                      const SizedBox(height: 14),

                      Row(
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: Checkbox(
                              value: auth.rememberMe,
                              onChanged: (v) => auth.setRememberMe(v ?? false),
                              activeColor: context.primaryColor,
                              side: BorderSide(
                                  color: context.borderColor, width: 1.5),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Ghi nhớ đăng nhập',
                            style: TextStyle(
                                fontSize: 13, color: context.textSecondary),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      SizedBox(
                        height: 52,
                        child: ElevatedButton(
                          onPressed: auth.isLoading ? null : widget.onSubmit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isDark
                                ? context.primaryColor
                                : const Color(0xFF1A3A7A),
                            foregroundColor: Colors.white,
                            disabledBackgroundColor:
                                context.primaryColor.withValues(alpha: 0.5),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: auth.isLoading
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2, color: Colors.white),
                                )
                              : const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Đăng nhập',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Icon(Icons.arrow_forward_rounded, size: 18),
                                  ],
                                ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      Row(
                        children: [
                          Expanded(
                              child: Divider(
                                  color: context.borderColor, height: 1)),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 14),
                            child: Text(
                              'HOẶC',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: context.textSecondary,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                          Expanded(
                              child: Divider(
                                  color: context.borderColor, height: 1)),
                        ],
                      ),

                      const SizedBox(height: 16),

                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyle(
                              fontSize: 13, color: context.textSecondary),
                          children: [
                            const TextSpan(text: 'Bạn cần hỗ trợ? Liên hệ '),
                            TextSpan(
                              text: '0376 299 300',
                              style: TextStyle(
                                color: context.primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(BuildContext context, String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: context.textSecondary,
      ),
    );
  }

  Widget _buildTextField({
    required BuildContext context,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required bool isPassword,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword ? _obscurePassword : false,
      keyboardType: isPassword ? null : TextInputType.text,
      validator: validator,
      style: TextStyle(
        fontSize: 14,
        color: context.textPrimary,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: context.textSecondary.withValues(alpha: 0.6),
          fontSize: 14,
        ),
        prefixIcon: Icon(icon, size: 18, color: context.textSecondary),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: 18,
                  color: context.textSecondary,
                ),
                onPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
              )
            : null,
        filled: true,
        fillColor: context.surfaceColor,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: context.borderColor, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: context.borderColor, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: context.primaryColor, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.5),
        ),
      ),
    );
  }
}
