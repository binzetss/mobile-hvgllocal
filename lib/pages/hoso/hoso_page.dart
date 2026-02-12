import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/hoso_provider.dart';
import '../../widgets/common/common_app_bar.dart';
import '../../widgets/hoso/hoso_header.dart';
import '../../widgets/hoso/hoso_section.dart';
import '../../widgets/hoso/hoso_info_row.dart';
import '../../widgets/hoso/hoso_sub_card.dart';

class HosoPage extends StatelessWidget {
  const HosoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<HosoProvider>().profile;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CommonAppBar(title: 'Hồ Sơ Cá Nhân'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          children: [
            HosoHeader(
              name: profile.fullName,
              birthYear: profile.birthYear,
              gender: profile.gender,
            ),
            const SizedBox(height: 20),
            HosoSection(
              title: 'Thông tin cá nhân',
              icon: FontAwesomeIcons.idCard,
              children: [
                HosoInfoRow(label: 'Họ và tên', value: profile.fullName),
                HosoInfoRow(label: 'Năm sinh', value: profile.birthYear),
                HosoInfoRow(label: 'Giới tính', value: profile.gender),
                HosoInfoRow(label: 'Tình trạng hôn nhân', value: profile.maritalStatus),
                HosoInfoRow(label: 'Chỗ ở hiện tại', value: profile.currentAddress),
                HosoInfoRow(
                  label: 'Thường trú',
                  value: profile.permanentAddress,
                  isLast: true,
                ),
              ],
            ),
            HosoSection(
              title: 'Thân nhân',
              icon: FontAwesomeIcons.peopleGroup,
              iconColor: const Color(0xFF10B981),
              children: profile.relatives.asMap().entries.map((entry) {
                final index = entry.key;
                final relative = entry.value;
                return HosoSubCard(
                  index: index,
                  children: [
                    HosoInfoRow(label: 'Quan hệ', value: relative.relation),
                    HosoInfoRow(label: 'Họ và tên', value: relative.fullName),
                    HosoInfoRow(label: 'Năm sinh', value: relative.birthYear),
                    HosoInfoRow(label: 'CCCD', value: relative.cccd),
                    HosoInfoRow(label: 'BHYT', value: relative.bhyt, isLast: true),
                  ],
                );
              }).toList(),
            ),
            HosoSection(
              title: 'Điều chuyển',
              icon: FontAwesomeIcons.arrowsRotate,
              iconColor: const Color(0xFF8B5CF6),
              children: [
                HosoInfoRow(label: 'Nội dung', value: profile.transfer.content),
                HosoInfoRow(
                  label: 'Ngày',
                  value: profile.transfer.date,
                  isLast: true,
                ),
              ],
            ),
            HosoSection(
              title: 'Bảo hiểm',
              icon: FontAwesomeIcons.shieldHalved,
              iconColor: const Color(0xFF3B82F6),
              children: [
                HosoInfoRow(label: 'Số BHYT', value: profile.bhytNumber),
                HosoInfoRow(label: 'Nơi đăng ký BHYT', value: profile.bhytRegisterPlace),
                HosoInfoRow(
                  label: 'Số BHXH',
                  value: profile.bhxhNumber,
                  isLast: true,
                ),
              ],
            ),
            HosoSection(
              title: 'Ngân hàng & Thuế',
              icon: FontAwesomeIcons.buildingColumns,
              iconColor: const Color(0xFFF59E0B),
              children: [
                HosoInfoRow(label: 'Số ngân hàng', value: profile.bankNumber),
                HosoInfoRow(label: 'Họ và tên chủ thẻ', value: profile.bankAccountName),
                HosoInfoRow(label: 'Tên ngân hàng', value: profile.bankName),
                HosoInfoRow(
                  label: 'Mã số thuế',
                  value: profile.taxCode,
                  isLast: true,
                ),
              ],
            ),
            HosoSection(
              title: 'CCCD/CMND',
              icon: FontAwesomeIcons.addressCard,
              iconColor: const Color(0xFFEC4899),
              children: [
                HosoInfoRow(label: 'Số CCCD/CMND', value: profile.cccdNumber),
                HosoInfoRow(label: 'Ngày cấp', value: profile.cccdIssueDate),
                HosoInfoRow(
                  label: 'Nơi cấp',
                  value: profile.cccdIssuePlace,
                  isLast: true,
                ),
              ],
            ),
            HosoSection(
              title: 'CCHN',
              icon: FontAwesomeIcons.certificate,
              iconColor: const Color(0xFF06B6D4),
              children: [
                HosoInfoRow(label: 'Số CCHN', value: profile.cchnNumber),
                HosoInfoRow(label: 'Ngày cấp', value: profile.cchnIssueDate),
                HosoInfoRow(label: 'Nơi cấp', value: profile.cchnIssuePlace),
                HosoInfoRow(label: 'Văn bằng chuyên môn', value: profile.cchnDegree),
                HosoInfoRow(label: 'Phạm vi hoạt động', value: profile.cchnScope),
                HosoInfoRow(label: 'Upload file', value: profile.cchnFile),
                HosoInfoRow(
                  label: 'Ngày cấp dự kiến',
                  value: profile.cchnPlannedDate,
                  isLast: true,
                ),
              ],
            ),
            HosoSection(
              title: 'Chức danh',
              icon: FontAwesomeIcons.trophy,
              iconColor: const Color(0xFFFCD34D),
              children: [
                HosoInfoRow(label: 'Tên chức danh', value: profile.titleName),
                HosoInfoRow(label: 'Hội đồng chức danh', value: profile.titleCouncil),
                HosoInfoRow(
                  label: 'Ngày cấp chức danh',
                  value: profile.titleIssueDate,
                  isLast: true,
                ),
              ],
            ),
            HosoSection(
              title: 'Bằng cấp',
              icon: FontAwesomeIcons.graduationCap,
              iconColor: const Color(0xFFEF4444),
              children: profile.degrees.asMap().entries.map((entry) {
                final index = entry.key;
                final degree = entry.value;
                return HosoSubCard(
                  index: index,
                  children: [
                    HosoInfoRow(label: 'Văn bằng', value: degree.major),
                    HosoInfoRow(label: 'Nơi cấp', value: degree.place),
                    HosoInfoRow(label: 'Xếp loại', value: degree.level),
                    HosoInfoRow(label: 'Ngày cấp', value: degree.date),
                    HosoInfoRow(
                      label: 'Tệp đính kèm',
                      value: degree.attachmentName,
                      isLast: true,
                    ),
                  ],
                );
              }).toList(),
            ),
            HosoSection(
              title: 'Chứng chỉ đào tạo',
              icon: FontAwesomeIcons.award,
              iconColor: const Color(0xFF14B8A6),
              children: profile.certificates.asMap().entries.map((entry) {
                final index = entry.key;
                final cert = entry.value;
                return HosoSubCard(
                  index: index,
                  children: [
                    HosoInfoRow(label: 'Tên chứng chỉ', value: cert.name),
                    HosoInfoRow(label: 'Ngày', value: cert.date),
                    HosoInfoRow(
                      label: 'Tệp đính kèm',
                      value: cert.attachmentName,
                      isLast: true,
                    ),
                  ],
                );
              }).toList(),
            ),
            HosoSection(
              title: 'Đào tạo liên tục',
              icon: FontAwesomeIcons.clockRotateLeft,
              iconColor: const Color(0xFFA855F7),
              children: [
                HosoInfoRow(
                  label: 'Tổng thời gian đào tạo liên tục',
                  value: profile.continuousTrainingHours,
                  isLast: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
