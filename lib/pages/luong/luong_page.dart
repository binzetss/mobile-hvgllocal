import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/extensions/theme_extensions.dart';
import '../../data/models/luong_model.dart';
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
    final isDesktop = kIsWeb && MediaQuery.of(context).size.width >= 768;
    return ChangeNotifierProvider(
      create: (_) => LuongProvider(),
      child: Consumer<LuongProvider>(
        builder: (context, provider, _) {
          if (provider.salaryData == null) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          final data = provider.salaryData!;
          if (isDesktop) return _buildWebLayout(context, provider, data);
          return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            appBar: const CommonAppBar(title: 'Thông Tin Lương'),
            body: _buildMobileBody(context, provider, data),
          );
        },
      ),
    );
  }

  // ── Mobile ──────────────────────────────────────────────────────────────────

  Widget _buildMobileBody(
      BuildContext context, LuongProvider provider, LuongInfo data) {
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
              _buildRow(provider, 'Mức lương P1 (1+2+3)', data.mucLuongP1,
                  subtitle: 'Mức đóng BHXH', isHighlight: true),
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
              _buildRow(provider, 'Tổng công tính P1', data.tongCongTinhP1,
                  isWorkday: true, isHighlight: true),
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
  }

  // ── Web ─────────────────────────────────────────────────────────────────────

  Widget _buildWebLayout(
      BuildContext context, LuongProvider provider, LuongInfo data) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          // ── Top bar ──
          _WebTopBar(provider: provider),
          // ── Scrollable content ──
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(28, 24, 28, 32),
              child: Column(
                children: [
                  // Summary card — full width
                  LuongSummaryCard(
                    thucNhan: data.thucNhan,
                    tienNhanDot1: data.tienNhanDot1,
                    tienNhanDot2: data.tienNhanDot2,
                    formatCurrency: provider.formatCurrency,
                  ),
                  const SizedBox(height: 20),
                  // 2-column sections
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left column
                      Expanded(
                        child: Column(
                          children: [
                            LuongSectionCard(
                              title: 'LƯƠNG CƠ BẢN',
                              icon: FontAwesomeIcons.moneyBill,
                              children: [
                                _buildRow(provider, 'Lương cơ bản (1)', data.luongCoBan),
                                _buildRow(provider, 'Phụ cấp chức vụ (2)', data.phuCapChucVu),
                                _buildRow(provider, 'Phụ cấp độc hại (3)', data.phuCapDocHai),
                                _buildRow(provider, 'Mức lương P1 (1+2+3)', data.mucLuongP1,
                                    subtitle: 'Mức đóng BHXH', isHighlight: true),
                              ],
                            ),
                            const SizedBox(height: 14),
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
                            const SizedBox(height: 14),
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
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Right column
                      Expanded(
                        child: Column(
                          children: [
                            LuongSectionCard(
                              title: 'NGÀY CÔNG',
                              icon: FontAwesomeIcons.calendarDays,
                              children: [
                                _buildRow(provider, 'Công chính thức', data.congChinhThuc, isWorkday: true),
                                _buildRow(provider, 'Công ngày lễ', data.congNgayLe, isWorkday: true),
                                _buildRow(provider, 'Công phép (F,PĐB)', data.congPhep, isWorkday: true),
                                _buildRow(provider, 'Công tăng ca (*150%)', data.congTangCa, isWorkday: true),
                                _buildRow(provider, 'Tổng công tính P1', data.tongCongTinhP1,
                                    isWorkday: true, isHighlight: true),
                              ],
                            ),
                            const SizedBox(height: 14),
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
                            const SizedBox(height: 14),
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
                            const SizedBox(height: 14),
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
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Net salary — full width
                  LuongNetSalaryCard(
                    thucNhan: data.thucNhan,
                    formatCurrency: provider.formatCurrency,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Shared helper ────────────────────────────────────────────────────────────

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

// ── Web helpers ────────────────────────────────────────────────────────────────

class _WebTopBar extends StatelessWidget {
  final LuongProvider provider;
  const _WebTopBar({required this.provider});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
      decoration: BoxDecoration(
        color: context.cardColor.withValues(alpha: isDark ? 0.6 : 0.85),
        border: Border(
          bottom: BorderSide(
              color: context.borderColor.withValues(alpha: 0.4)),
        ),
      ),
      child: Row(
        children: [
          // Title
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(9),
            ),
            child: FaIcon(FontAwesomeIcons.sackDollar,
                size: 14, color: context.primaryColor),
          ),
          const SizedBox(width: 12),
          Text(
            'Thông tin lương',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: context.textPrimary,
              letterSpacing: -0.3,
            ),
          ),
          const Spacer(),
          // Month selector (compact)
          _WebMonthPicker(provider: provider),
        ],
      ),
    );
  }
}

class _WebMonthPicker extends StatelessWidget {
  final LuongProvider provider;
  const _WebMonthPicker({required this.provider});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
            color: context.borderColor.withValues(alpha: isDark ? 1.0 : 0.6)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: provider.selectedMonth,
          items: provider.availableMonths
              .map((m) => DropdownMenuItem(
                    value: m,
                    child: Text(
                      'Tháng $m',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: context.textPrimary),
                    ),
                  ))
              .toList(),
          onChanged: (month) {
            if (month != null) provider.onMonthChanged(month);
          },
          icon: FaIcon(FontAwesomeIcons.chevronDown,
              size: 11, color: context.textSecondary),
          dropdownColor: context.cardColor,
          isDense: true,
          style: TextStyle(fontSize: 13, color: context.textPrimary),
        ),
      ),
    );
  }
}
