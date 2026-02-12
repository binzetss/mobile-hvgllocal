import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/daotao_model.dart';
import '../../providers/daotao_provider.dart';
import 'the_thongtin_daotao.dart';

class DanhSachThongTinDaoTao extends StatelessWidget {
  final DaotaoModel lopDaoTao;

  const DanhSachThongTinDaoTao({
    super.key,
    required this.lopDaoTao,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Thông tin khóa học',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
            letterSpacing: -0.2,
          ),
        ),
        const SizedBox(height: 16),
        TheThongTinDaoTao(
          icon: FontAwesomeIcons.clock,
          label: 'Số tiết học',
          value: '${lopDaoTao.soTiet} tiết',
          color: AppColors.primary,
        ),
        TheThongTinDaoTao(
          icon: FontAwesomeIcons.calendarDay,
          label: 'Ngày bắt đầu học',
          value: DaotaoProvider.formatDate(lopDaoTao.ngayBatDau),
          color: const Color(0xFF10B981),
        ),
        TheThongTinDaoTao(
          icon: FontAwesomeIcons.calendarPlus,
          label: 'Mở đăng ký',
          value: DaotaoProvider.formatDateTime(lopDaoTao.ngayBatDauDangKy),
          color: const Color(0xFF3B82F6),
        ),
        TheThongTinDaoTao(
          icon: FontAwesomeIcons.calendarXmark,
          label: 'Hạn đăng ký',
          value: DaotaoProvider.formatDateTime(lopDaoTao.ngayKetThucDangKy),
          color: const Color(0xFFF59E0B),
          isLast: true,
        ),
      ],
    );
  }
}
