import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../providers/xacthuc_provider.dart';
import '../common/common.dart';

class DangnhapLoginCard extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController maSoController;
  final TextEditingController matKhauController;
  final VoidCallback onSubmit;

  const DangnhapLoginCard({
    super.key,
    required this.formKey,
    required this.maSoController,
    required this.matKhauController,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.95),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.6),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 40,
                  offset: const Offset(0, 20),
                ),
              ],
            ),
            child: Consumer<XacthucProvider>(
              builder: (context, authProvider, child) {
                return Form(
                  key: formKey,
                  child: Column(
                    children: [
        
                      const Text(
                        AppStrings.loginTitle,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1976D2),
                          letterSpacing: 0.3,
                          height: 1.3,
                        ),
                        textAlign: TextAlign.center,
                      )
                          .animate()
                          .fadeIn(delay: 600.ms, duration: 500.ms)
                          .slideY(begin: -0.2, end: 0, curve: Curves.easeOut),
                      const SizedBox(height: 10),
    
                      const Text(
                        AppStrings.loginSubtitle,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF607D8B),
                          letterSpacing: 0.1,
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      )
                          .animate()
                          .fadeIn(delay: 700.ms, duration: 500.ms)
                          .slideY(begin: -0.1, end: 0, curve: Curves.easeOut),
                      const SizedBox(height: 36),
                      AppTextField(
                        controller: maSoController,
                        prefixIcon: Icons.person_outline_rounded,
                        hintText: AppStrings.usernameHint,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vui lòng nhập tài khoản';
                          }
                          return null;
                        },
                      )
                          .animate()
                          .fadeIn(delay: 700.ms, duration: 400.ms)
                          .slideX(begin: -0.2, end: 0),
                      const SizedBox(height: 20),
                      AppTextField(
                        controller: matKhauController,
                        prefixIcon: Icons.lock_outline_rounded,
                        hintText: AppStrings.passwordHint,
                        isPassword: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vui lòng nhập mật khẩu';
                          }
                          return null;
                        },
                      )
                          .animate()
                          .fadeIn(delay: 850.ms, duration: 400.ms)
                          .slideX(begin: -0.2, end: 0),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          AppCheckbox(
                            value: authProvider.rememberMe,
                            onChanged: (value) {
                              authProvider.setRememberMe(value ?? false);
                            },
                            label: AppStrings.rememberMe,
                          ),
                        ],
                      )
                          .animate()
                          .fadeIn(delay: 1000.ms, duration: 400.ms)
                          .slideX(begin: -0.1, end: 0),
                      const SizedBox(height: 36),
                      AppButton(
                        text: AppStrings.loginButton,
                        isLoading: authProvider.status == AuthStatus.loading,
                        onPressed: onSubmit,
                        height: 56,
                      )
                          .animate()
                          .fadeIn(delay: 1150.ms, duration: 400.ms)
                          .scale(
                            begin: const Offset(0.9, 0.9),
                            curve: Curves.easeOutBack,
                          ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(delay: 600.ms, duration: 600.ms)
        .slideY(begin: 0.3, end: 0, curve: Curves.easeOutCubic);
  }
}
