import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/daotao_model.dart';
import '../../providers/daotao_provider.dart';
import '../common/app_dialogs.dart';

class DaotaoDangKyButton extends StatelessWidget {
  final DaotaoModel lopDaoTao;

  const DaotaoDangKyButton({super.key, required this.lopDaoTao});

  Future<void> _handleDangKy(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Xác nhận đăng ký',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        content: Text(
          'Bạn muốn đăng ký tham gia lớp "${lopDaoTao.tenLopDaoTao}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Đăng ký'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final provider = context.read<DaotaoProvider>();
      final success = await provider.dangKy(lopDaoTao.idLopDaoTao);

      if (context.mounted) {
        if (success) {
          showSuccessDialog(
            context,
            title: 'Đăng ký thành công',
            message: 'Bạn đã đăng ký tham gia lớp "${lopDaoTao.tenLopDaoTao}" thành công.',
          );
        } else {
          showErrorDialog(
            context,
            title: 'Đăng ký thất bại',
            message: provider.errorMessage ?? 'Không thể đăng ký. Vui lòng thử lại sau.',
          );
        }
      }
    }
  }

  Future<void> _handleHuyDangKy(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Xác nhận hủy đăng ký',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        content: Text(
          'Bạn muốn hủy đăng ký lớp "${lopDaoTao.tenLopDaoTao}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Không'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Hủy đăng ký'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final provider = context.read<DaotaoProvider>();
      final success = await provider.huyDangKy(lopDaoTao.idLopDaoTao);

      if (context.mounted) {
        if (success) {
          showSuccessDialog(
            context,
            title: 'Hủy đăng ký thành công',
            message: 'Bạn đã hủy đăng ký lớp "${lopDaoTao.tenLopDaoTao}".',
          );
        } else {
          showErrorDialog(
            context,
            title: 'Hủy đăng ký thất bại',
            message: provider.errorMessage ?? 'Không thể hủy đăng ký. Vui lòng thử lại sau.',
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DaotaoProvider>(
      builder: (context, provider, _) {
        final daDangKy = provider.daDangKy(lopDaoTao.idLopDaoTao);

        if (daDangKy) {
          return _buildButton(
            context: context,
            onPressed: () => _handleHuyDangKy(context),
            label: 'Hủy đăng ký',
            icon: FontAwesomeIcons.xmark,
            color: const Color(0xFFEF4444),
            isOutlined: false,
          );
        }

        return _buildButton(
          context: context,
          onPressed: () => _handleDangKy(context),
          label: 'Đăng ký tham gia',
          icon: FontAwesomeIcons.penToSquare,
          color: AppColors.primary,
          isOutlined: false,
        );
      },
    );
  }

  Widget _buildButton({
    required BuildContext context,
    required VoidCallback onPressed,
    required String label,
    required IconData icon,
    required Color color,
    required bool isOutlined,
  }) {
    final buttonStyle = isOutlined
        ? OutlinedButton.styleFrom(
            foregroundColor: color,
            padding: const EdgeInsets.symmetric(vertical: 13),
            side: BorderSide(color: color.withValues(alpha: 0.5), width: 1.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          )
        : ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 13),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          );

    return SizedBox(
      width: double.infinity,
      child: isOutlined
          ? OutlinedButton.icon(
              onPressed: onPressed,
              icon: FaIcon(icon, size: 14, color: color),
              label: Text(label),
              style: buttonStyle,
            )
          : ElevatedButton.icon(
              onPressed: onPressed,
              icon: FaIcon(icon, size: 14, color: Colors.white),
              label: Text(label),
              style: buttonStyle,
            ),
    );
  }
}
