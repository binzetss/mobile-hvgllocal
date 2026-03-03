import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../core/extensions/theme_extensions.dart';
import '../../providers/doimatkhau_landau_provider.dart';
import '../../providers/xacthuc_provider.dart';
import '../doimatkhau/doimatkhau_password_field.dart';
import '../doimatkhau/doimatkhau_requirements.dart';

class DoimatkhauLandauForm extends StatelessWidget {
  final VoidCallback onSuccess;

  const DoimatkhauLandauForm({super.key, required this.onSuccess});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Consumer<DoimatkhauLandauProvider>(
      builder: (context, provider, _) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
          child: Form(
            key: provider.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Form card
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: context.cardColor,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: context.borderColor,
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Đặt mật khẩu mới',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: context.textPrimary,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 24),
                      DoimatkhauPasswordField(
                        controller: provider.matKhauCuController,
                        label: 'Mật khẩu hiện tại',
                        icon: FontAwesomeIcons.key,
                        isVisible: provider.isMatKhauCuVisible,
                        onToggleVisibility: provider.toggleMatKhauCuVisibility,
                        validator: provider.validateMatKhauCu,
                      ),
                      const SizedBox(height: 20),
                      DoimatkhauPasswordField(
                        controller: provider.matKhauMoiController,
                        label: 'Mật khẩu mới',
                        icon: FontAwesomeIcons.lockOpen,
                        isVisible: provider.isMatKhauMoiVisible,
                        onToggleVisibility: provider.toggleMatKhauMoiVisibility,
                        validator: provider.validateMatKhauMoi,
                      ),
                      const SizedBox(height: 20),
                      DoimatkhauPasswordField(
                        controller: provider.xacNhanMatKhauController,
                        label: 'Xác nhận mật khẩu mới',
                        icon: FontAwesomeIcons.circleCheck,
                        isVisible: provider.isXacNhanVisible,
                        onToggleVisibility: provider.toggleXacNhanVisibility,
                        validator: provider.validateXacNhan,
                      ),
                    ],
                  ),
                ),

                if (provider.errorMessage != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF3A0A0A)
                          : const Color(0xFFFFF0F0),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDark
                            ? const Color(0xFF7F1D1D)
                            : const Color(0xFFFFCDD2),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: Color(0xFFE53935),
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            provider.errorMessage!,
                            style: TextStyle(
                              fontSize: 14,
                              color: isDark
                                  ? const Color(0xFFF87171)
                                  : const Color(0xFFB71C1C),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 20),
                const DoimatkhauRequirements(),
                const SizedBox(height: 28),

                // Nút xác nhận
                SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: provider.isLoading
                        ? null
                        : () async {
                            final maSo =
                                context.read<XacthucProvider>().user?.maSo ??
                                    '';
                            final success = await provider.doiMatKhau(maSo);
                            if (success && context.mounted) {
                              onSuccess();
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.primaryColor,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor:
                          context.primaryColor.withValues(alpha: 0.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: provider.isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FaIcon(
                                FontAwesomeIcons.check,
                                size: 16,
                              ),
                              SizedBox(width: 10),
                              Text(
                                'Xác nhận & Vào ứng dụng',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -0.2,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
