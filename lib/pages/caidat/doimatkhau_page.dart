import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/extensions/theme_extensions.dart';
import '../../widgets/common/common_app_bar.dart';
import '../../providers/doimatkhau_provider.dart';
import '../../providers/xacthuc_provider.dart';
import '../../widgets/doimatkhau/doimatkhau_header.dart';
import '../../widgets/doimatkhau/doimatkhau_password_field.dart';
import '../../widgets/doimatkhau/doimatkhau_requirements.dart';
import '../../widgets/doimatkhau/doimatkhau_submit_button.dart';
import '../../widgets/doimatkhau/doimatkhau_success_dialog.dart';

class DoimatkhauPage extends StatelessWidget {
  const DoimatkhauPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = kIsWeb && MediaQuery.of(context).size.width >= 768;
    return ChangeNotifierProvider(
      create: (_) => DoimatkhauProvider(),
      child: isDesktop
          ? const _WebDoimatkhauPage()
          : const _MobileDoimatkhauPage(),
    );
  }
}

class _MobileDoimatkhauPage extends StatelessWidget {
  const _MobileDoimatkhauPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.bgColor,
      appBar: const CommonAppBar(title: 'Đổi mật khẩu'),
      body: Consumer<DoimatkhauProvider>(
        builder: (context, provider, _) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                const DoimatkhauHeader(),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPasswordForm(context, provider),
                      if (provider.errorMessage != null) ...[
                        const SizedBox(height: 12),
                        _buildErrorBanner(provider.errorMessage!),
                      ],
                      const SizedBox(height: 24),
                      const DoimatkhauRequirements(),
                      const SizedBox(height: 32),
                      DoimatkhauSubmitButton(
                        isLoading: provider.isLoading,
                        onPressed: () =>
                            _handleChangePassword(context, provider),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _WebDoimatkhauPage extends StatelessWidget {
  const _WebDoimatkhauPage();

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Consumer<DoimatkhauProvider>(
        builder: (context, provider, _) {
          return Column(
            children: [

              Container(
                height: 64,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  color: context.cardColor,
                  border: Border(
                      bottom: BorderSide(color: context.borderColor)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: FaIcon(
                          FontAwesomeIcons.lock,
                          size: 15,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Đổi mật khẩu',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: context.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 860),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(32),
                      child: IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [

                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.stretch,
                                children: [
                                  _buildInfoCard(context, isDark),
                                  const SizedBox(height: 20),
                                  const DoimatkhauRequirements(),
                                ],
                              ),
                            ),
                            const SizedBox(width: 24),

                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.stretch,
                                children: [
                                  _buildPasswordForm(context, provider),
                                  if (provider.errorMessage != null) ...[
                                    const SizedBox(height: 12),
                                    _buildErrorBanner(
                                        provider.errorMessage!),
                                  ],
                                  const SizedBox(height: 24),
                                  DoimatkhauSubmitButton(
                                    isLoading: provider.isLoading,
                                    onPressed: () => _handleChangePassword(
                                        context, provider),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [AppColors.primaryDark, AppColors.primaryLight]
              : AppColors.primaryGradient,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.28),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              shape: BoxShape.circle,
              border: Border.all(
                  color: Colors.white.withValues(alpha: 0.25), width: 2),
            ),
            child: const Center(
              child: FaIcon(FontAwesomeIcons.lock,
                  size: 24, color: Colors.white),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Đổi mật khẩu',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Thay đổi mật khẩu định kỳ giúp bảo vệ tài khoản khỏi các truy cập trái phép và đảm bảo an toàn dữ liệu.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.85),
              height: 1.55,
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildPasswordForm(
    BuildContext context, DoimatkhauProvider provider) {
  return Form(
    key: provider.formKey,
    child: Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.dark
              ? const Color(0xFF38383A)
              : const Color(0xFFE8EAF0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Thông tin mật khẩu',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : const Color(0xFF1A1A1A),
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 24),
          DoimatkhauPasswordField(
            controller: provider.oldPasswordController,
            label: 'Mật khẩu hiện tại',
            icon: FontAwesomeIcons.key,
            isVisible: provider.isOldPasswordVisible,
            onToggleVisibility: provider.toggleOldPasswordVisibility,
            validator: provider.validateOldPassword,
          ),
          const SizedBox(height: 20),
          DoimatkhauPasswordField(
            controller: provider.newPasswordController,
            label: 'Mật khẩu mới',
            icon: FontAwesomeIcons.lockOpen,
            isVisible: provider.isNewPasswordVisible,
            onToggleVisibility: provider.toggleNewPasswordVisibility,
            validator: provider.validateNewPassword,
          ),
          const SizedBox(height: 20),
          DoimatkhauPasswordField(
            controller: provider.confirmPasswordController,
            label: 'Xác nhận mật khẩu mới',
            icon: FontAwesomeIcons.circleCheck,
            isVisible: provider.isConfirmPasswordVisible,
            onToggleVisibility: provider.toggleConfirmPasswordVisibility,
            validator: provider.validateConfirmPassword,
          ),
        ],
      ),
    ),
  );
}

Widget _buildErrorBanner(String message) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    decoration: BoxDecoration(
      color: const Color(0xFFFFF0F0),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: const Color(0xFFFFCDD2)),
    ),
    child: Row(
      children: [
        const Icon(Icons.error_outline, color: Color(0xFFE53935), size: 20),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            message,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFFB71C1C),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    ),
  );
}

Future<void> _handleChangePassword(
  BuildContext context,
  DoimatkhauProvider provider,
) async {
  final maSo = context.read<XacthucProvider>().user?.maSo ?? '';
  final success = await provider.changePassword(maSo);
  if (success && context.mounted) {
    DoimatkhauSuccessDialog.show(
      context,
      onClose: () {
        context.read<XacthucProvider>().logout();
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/login',
          (route) => false,
        );
      },
    );
  }
}
