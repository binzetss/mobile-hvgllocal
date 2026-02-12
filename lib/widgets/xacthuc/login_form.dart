import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../providers/xacthuc_provider.dart';
import '../common/common.dart';

class LoginForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final VoidCallback onSubmit;

  const LoginForm({
    super.key,
    required this.formKey,
    required this.usernameController,
    required this.passwordController,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<XacthucProvider>(
      builder: (context, authProvider, child) {
        return Form(
          key: formKey,
          child: Column(
            children: [
              _buildTitle(),
              const SizedBox(height: 8),
              _buildSubtitle(),
              const SizedBox(height: 36),
              _buildUsernameField(),
              const SizedBox(height: 20),
              _buildPasswordField(),
              const SizedBox(height: 20),
              _buildRememberMe(authProvider),
              const SizedBox(height: 36),
              _buildSubmitButton(authProvider),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTitle() {
    return const Text(
      AppStrings.loginTitle,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary,
        letterSpacing: -0.5,
      ),
    );
  }

  Widget _buildSubtitle() {
    return const Text(
      AppStrings.loginSubtitle,
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
        letterSpacing: -0.2,
      ),
    );
  }

  Widget _buildUsernameField() {
    return AppTextField(
      controller: usernameController,
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
        .slideX(begin: -0.2, end: 0);
  }

  Widget _buildPasswordField() {
    return AppTextField(
      controller: passwordController,
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
        .slideX(begin: -0.2, end: 0);
  }

  Widget _buildRememberMe(XacthucProvider authProvider) {
    return Row(
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
        .slideX(begin: -0.1, end: 0);
  }

  Widget _buildSubmitButton(XacthucProvider authProvider) {
    return AppButton(
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
        );
  }
}
