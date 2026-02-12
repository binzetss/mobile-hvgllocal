import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/luong_provider.dart';
import '../../widgets/common/common_app_bar.dart';
import '../../widgets/luong/luong_month_selector.dart';
import '../../widgets/luong/luong_summary_card.dart';
import '../../widgets/luong/luong_section_card.dart';
import '../../widgets/luong/luong_row.dart';
import '../../widgets/luong/luong_net_salary_card.dart';

class LuongPage extends StatelessWidget {
  const LuongPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LuongProvider(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: const CommonAppBar(title: 'Thông Tin Lương'),
        body: Consumer<LuongProvider>(
          builder: (context, provider, child) {
            if (provider.salaryData == null) {
              return const Center(child: CircularProgressIndicator());
            }

            final data = provider.salaryData!;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LuongMonthSelector(
                    selectedMonth: provider.selectedMonth,
                    availableMonths: provider.availableMonths,
                    onMonthChanged: (month) {
                      if (month != null) provider.onMonthChanged(month);
                    },
                  ),
                  const SizedBox(height: 16),
                  LuongSummaryCard(
                    thucNhan: data.thucNhan,
                    tienNhanDot1: data.tienNhanDot1,
                    tienNhanDot2: data.tienNhanDot2,
                    formatCurrency: provider.formatCurrency,
                  ),
                  const SizedBox(height: 16),
                  LuongSectionCard(
                    title: 'LƯƠNG CƠ BẢN',
                    icon: FontAwesomeIcons.moneyBill,
                    children: [
                      _buildRow(provider, 'Lương cơ bản (1)', data.luongCoBan),
                      _buildRow(provider, 'Phụ cấp chức vụ (2)', data.phuCapChucVu),
                      _buildRow(provider, 'Phụ cấp độc hại (3)', data.phuCapDocHai),
                      _buildRow(
                        provider,
                        'Mức lương P1 (1+2+3)',
                        data.mucLuongP1,
                        subtitle: 'Mức đóng BHXH',
                        isHighlight: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  LuongSectionCard(
                    title: 'NGÀY CÔNG',
                    icon: FontAwesomeIcons.calendarDays,
                    children: [
                      _buildRow(provider, 'Công chính thức', data.congChinhThuc, isWorkday: true),
                      _buildRow(provider, 'Công ngày lễ', data.congNgayLe, isWorkday: true),
                      _buildRow(provider, 'Công phép (F,PĐB)', data.congPhep, isWorkday: true),
                      _buildRow(provider, 'Công tăng ca (*150%)', data.congTangCa, isWorkday: true),
                      _buildRow(
                        provider,
                        'Tổng công tính P1',
                        data.tongCongTinhP1,
                        isWorkday: true,
                        isHighlight: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  LuongSectionCard(
                    title: 'TIỀN LƯƠNG',
                    icon: FontAwesomeIcons.wallet,
                    children: [
                      _buildRow(provider, 'Tiền lương P1 (+)', data.tienLuongP1, isPositive: true),
                      _buildRow(provider, 'Mức P2', data.mucP2),
                      _buildRow(provider, 'Mức tính P2 theo công chính thức', data.mucTinhP2TheoCongChinhThuc),
                      _buildRow(provider, '% P2', data.phanTramP2, isPercent: true),
                      _buildRow(provider, 'Tiền lương P2 (+)', data.tienLuongP2, isPositive: true),
                    ],
                  ),
                  const SizedBox(height: 12),
                  LuongSectionCard(
                    title: 'CÁC KHOẢN CỘNG',
                    icon: FontAwesomeIcons.plus,
                    children: [
                      _buildRow(provider, 'Tiền lương sản phẩm (+)', data.tienLuongSanPham, isPositive: true),
                      _buildRow(provider, 'PC khác (+)', data.pcKhac, isPositive: true),
                      _buildRow(provider, 'Tiền trực (+)', data.tienTruc, isPositive: true),
                      _buildRow(provider, 'Tiền sinh nhật (+)', data.tienSinhNhat, isPositive: true),
                      _buildRow(provider, 'Hỗ trợ tiền trang điểm, cắt tóc (+)', data.hoTroTrangDiem, isPositive: true),
                    ],
                  ),
                  const SizedBox(height: 12),
                  LuongSectionCard(
                    title: 'HỌC VIỆC / THỬ VIỆC / ĐI HỌC',
                    icon: FontAwesomeIcons.graduationCap,
                    children: [
                      _buildRow(provider, 'Số ngày đi học', data.soNgayDiHoc, isWorkday: true),
                      _buildRow(provider, 'Tiền hỗ trợ lưu trú (+)', data.tienHoTroLuuTru, isPositive: true),
                      _buildRow(provider, 'Tiền hỗ trợ sinh hoạt (+)', data.tienHoTroSinhHoat, isPositive: true),
                      _buildRow(provider, 'Mức lương học việc', data.mucLuongHocViec),
                      _buildRow(provider, 'Công học việc', data.congHocViec, isWorkday: true),
                      _buildRow(provider, 'Tiền lương học việc (+)', data.tienLuongHocViec, isPositive: true),
                      _buildRow(provider, 'Mức lương thử việc', data.mucLuongThuViec),
                      _buildRow(provider, 'Công thử việc', data.congThuViec, isWorkday: true),
                      _buildRow(provider, 'Tiền lương thử việc (+)', data.tienLuongThuViec, isPositive: true),
                      _buildRow(provider, 'Mức lương đi học', data.mucLuongDiHoc),
                      _buildRow(provider, 'Công đi học', data.congDiHoc, isWorkday: true),
                      _buildRow(provider, 'Tiền lương đi học (+)', data.tienLuongDiHoc, isPositive: true),
                    ],
                  ),
                  const SizedBox(height: 12),
                  LuongSectionCard(
                    title: 'TỔNG HỢP',
                    icon: FontAwesomeIcons.calculator,
                    children: [
                      _buildRow(provider, 'Tiền phạt (-)', data.tienPhat, isNegative: true),
                      _buildRow(provider, 'Tổng lương', data.tongLuong, isHighlight: true),
                      _buildRow(provider, 'Truy lĩnh (+)', data.truyLinh, isPositive: true),
                      _buildRow(provider, 'Truy thu (-)', data.truyThu, isNegative: true),
                      _buildRow(provider, 'Tổng thu nhập', data.tongThuNhap, isHighlight: true),
                    ],
                  ),
                  const SizedBox(height: 12),
                  LuongSectionCard(
                    title: 'CÁC KHOẢN TRỪ',
                    icon: FontAwesomeIcons.minus,
                    iconColor: AppColors.error,
                    children: [
                      _buildRow(provider, 'Số người phụ thuộc', data.soNguoiPhuThuoc, isWorkday: true),
                      _buildRow(provider, 'BHXH 8%/BHYT 1,5%/BHTN 1% (-)', data.bhxhBhytBhtn, isNegative: true),
                      _buildRow(provider, 'Đoàn phí công đoàn 1% (-)', data.doanPhiCongDoan, isNegative: true),
                      _buildRow(provider, 'Trừ khác (-)', data.truKhac, isNegative: true),
                      _buildRow(provider, 'Tạm ứng (-)', data.tamUng, isNegative: true),
                      _buildRow(provider, 'Thuế TNCN (tạm tính) (-)', data.thueTncn, isNegative: true),
                      _buildRow(provider, 'Trả khác (+)', data.traKhac, isPositive: true),
                    ],
                  ),
                  const SizedBox(height: 12),
                  LuongNetSalaryCard(
                    thucNhan: data.thucNhan,
                    formatCurrency: provider.formatCurrency,
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildRow(
    LuongProvider provider,
    String label,
    double value, {
    String? subtitle,
    bool isHighlight = false,
    bool isPositive = false,
    bool isNegative = false,
    bool isWorkday = false,
    bool isPercent = false,
  }) {
    return LuongRow(
      label: label,
      formattedValue: provider.formatValue(
        value: value,
        isWorkday: isWorkday,
        isPercent: isPercent,
      ),
      subtitle: subtitle,
      isHighlight: isHighlight,
      isPositive: isPositive,
      isNegative: isNegative,
      value: value,
    );
  }
}
