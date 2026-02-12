import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../widgets/common/common_app_bar.dart';
import '../../providers/doimatkhau_provider.dart';
import '../../widgets/doimatkhau/doimatkhau_header.dart';
import '../../widgets/doimatkhau/doimatkhau_password_field.dart';
import '../../widgets/doimatkhau/doimatkhau_requirements.dart';
import '../../widgets/doimatkhau/doimatkhau_submit_button.dart';
import '../../widgets/doimatkhau/doimatkhau_success_dialog.dart';

class DoimatkhauPage extends StatelessWidget {
  const DoimatkhauPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DoimatkhauProvider(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        appBar: const CommonAppBar(title: 'Đổi mật khẩu'),
        body: Consumer<DoimatkhauProvider>(
          builder: (context, provider, child) {
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
                        _buildPasswordForm(provider),
                        const SizedBox(height: 24),
                        const DoimatkhauRequirements(),
                        const SizedBox(height: 32),
                        DoimatkhauSubmitButton(
                          isLoading: provider.isLoading,
                          onPressed: () => _handleChangePassword(context, provider),
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
      ),
    );
  }

  Widget _buildPasswordForm(DoimatkhauProvider provider) {
    return Form(
      key: provider.formKey,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE8EAF0), width: 1),
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
            const Text(
              'Thông tin mật khẩu',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A1A),
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

  Future<void> _handleChangePassword(
    BuildContext context,
    DoimatkhauProvider provider,
  ) async {
    final success = await provider.changePassword();

    if (success && context.mounted) {
      DoimatkhauSuccessDialog.show(context);
    }
  }
}
