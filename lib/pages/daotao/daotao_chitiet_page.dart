import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/daotao_model.dart';
import '../../providers/daotao_provider.dart';
import '../../widgets/common/app_dialogs.dart';
import '../../widgets/common/common_app_bar.dart';
import '../../widgets/daotao_chitiet/danh_sach_thongtin_daotao.dart';
import '../../widgets/daotao_chitiet/khoa_hoc_header_card.dart';
import '../../widgets/daotao_chitiet/nut_dangky.dart';

class DaotaoChitietPage extends StatelessWidget {
  final DaotaoModel lopDaoTao;

  const DaotaoChitietPage({super.key, required this.lopDaoTao});

  Future<void> _handleDangKy(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
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
            autoCloseDuration: const Duration(milliseconds: 2000),
          );
        } else {
          showErrorDialog(
            context,
            title: 'Đăng ký thất bại',
            message: 'Không thể đăng ký. Vui lòng thử lại sau.',
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: const CommonAppBar(title: 'Chi Tiết Đào Tạo'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            KhoaHocHeaderCard(lopDaoTao: lopDaoTao),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DanhSachThongTinDaoTao(lopDaoTao: lopDaoTao),
                  const SizedBox(height: 24),

                  if (lopDaoTao.dangMoDangKy)
                    NutDangKy(
                      onPressed: () => _handleDangKy(context),
                    ),
                  if (lopDaoTao.hetHanDangKy) const ThongBaoHetHan(),
                  if (lopDaoTao.chuaMoDangKy)
                    ThongBaoChuaMo(
                      ngayMo: DaotaoProvider.formatDateTime(
                          lopDaoTao.ngayBatDauDangKy),
                    ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
