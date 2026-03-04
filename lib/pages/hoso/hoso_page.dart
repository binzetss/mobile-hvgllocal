import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'crop_avatar_page.dart';
import '../../core/constants/app_colors.dart';
import '../../core/extensions/theme_extensions.dart';
import '../../core/utils/token_manager.dart';
import '../../data/models/hoso_model.dart';
import '../../providers/hoso_provider.dart';
import '../../providers/xacthuc_provider.dart';
import '../../widgets/common/common_app_bar.dart';
import '../../widgets/hoso/hoso_header.dart';
import '../../widgets/hoso/hoso_section.dart';
import '../../widgets/hoso/hoso_info_row.dart';
import '../../widgets/hoso/hoso_sub_card.dart';

class HosoPage extends StatelessWidget {
  const HosoPage({super.key});

  Future<void> _pickAvatar(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      backgroundColor: context.cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: context.borderColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text(
                  'Đổi ảnh đại diện',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
              ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: context.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.camera_alt_rounded, color: context.primaryColor),
                ),
                title: const Text('Chụp ảnh'),
                onTap: () {
                  Navigator.pop(context);
                  _upload(context, ImageSource.camera);
                },
              ),
              ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: context.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.photo_library_rounded, color: context.primaryColor),
                ),
                title: const Text('Chọn từ thư viện'),
                onTap: () {
                  Navigator.pop(context);
                  _upload(context, ImageSource.gallery);
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _upload(BuildContext context, ImageSource source) async {
    final picker = ImagePicker();
    final picked =
        await picker.pickImage(source: source, imageQuality: 90, maxWidth: 1024);
    if (picked == null || !context.mounted) return;

    final cropped = await Navigator.push<File>(
      context,
      MaterialPageRoute(
        builder: (_) => CropAvatarPage(imageFile: File(picked.path)),
      ),
    );
    if (cropped == null || !context.mounted) return;

    final auth = context.read<XacthucProvider>();
    final error = await auth.uploadAnhDaiDien(cropped);

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error ?? 'Cập nhật ảnh đại diện thành công'),
        backgroundColor:
            error != null ? const Color(0xFFE53935) : const Color(0xFF43A047),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = kIsWeb && MediaQuery.of(context).size.width >= 768;
    if (isDesktop) return const _WebHosoPage();

    final profile = context.watch<HosoProvider>().profile;
    final auth = context.watch<XacthucProvider>();
    final avatarUrl = auth.user?.hinhAnh;

    return Scaffold(
      backgroundColor: context.bgColor,
      appBar: const CommonAppBar(title: 'Hồ Sơ Cá Nhân'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          children: [
            HosoHeader(
              name: profile.fullName,
              birthYear: profile.birthYear,
              gender: profile.gender,
              avatarUrl: avatarUrl,
              localAvatarFile: auth.localAvatarFile,
              isUploading: auth.isUploadingAvatar,
              onAvatarTap: () => _pickAvatar(context),
            ),
            const SizedBox(height: 20),
            HosoSection(
              title: 'Thông tin cá nhân',
              icon: FontAwesomeIcons.idCard,
              children: [
                HosoInfoRow(label: 'Họ và tên', value: profile.fullName),
                HosoInfoRow(label: 'Năm sinh', value: profile.birthYear),
                HosoInfoRow(label: 'Giới tính', value: profile.gender),
                HosoInfoRow(
                    label: 'Tình trạng hôn nhân', value: profile.maritalStatus),
                HosoInfoRow(
                    label: 'Chỗ ở hiện tại', value: profile.currentAddress),
                HosoInfoRow(
                    label: 'Thường trú',
                    value: profile.permanentAddress,
                    isLast: true),
              ],
            ),
            HosoSection(
              title: 'Thân nhân',
              icon: FontAwesomeIcons.peopleGroup,
              iconColor: const Color(0xFF10B981),
              children: profile.relatives.asMap().entries.map((entry) {
                final relative = entry.value;
                return HosoSubCard(
                  index: entry.key,
                  children: [
                    HosoInfoRow(label: 'Quan hệ', value: relative.relation),
                    HosoInfoRow(label: 'Họ và tên', value: relative.fullName),
                    HosoInfoRow(label: 'Năm sinh', value: relative.birthYear),
                    HosoInfoRow(label: 'CCCD', value: relative.cccd),
                    HosoInfoRow(
                        label: 'BHYT', value: relative.bhyt, isLast: true),
                  ],
                );
              }).toList(),
            ),
            HosoSection(
              title: 'Điều chuyển',
              icon: FontAwesomeIcons.arrowsRotate,
              iconColor: const Color(0xFF8B5CF6),
              children: [
                HosoInfoRow(
                    label: 'Nội dung', value: profile.transfer.content),
                HosoInfoRow(
                    label: 'Ngày', value: profile.transfer.date, isLast: true),
              ],
            ),
            HosoSection(
              title: 'Bảo hiểm',
              icon: FontAwesomeIcons.shieldHalved,
              iconColor: const Color(0xFF3B82F6),
              children: [
                HosoInfoRow(label: 'Số BHYT', value: profile.bhytNumber),
                HosoInfoRow(
                    label: 'Nơi đăng ký BHYT',
                    value: profile.bhytRegisterPlace),
                HosoInfoRow(
                    label: 'Số BHXH', value: profile.bhxhNumber, isLast: true),
              ],
            ),
            HosoSection(
              title: 'Ngân hàng & Thuế',
              icon: FontAwesomeIcons.buildingColumns,
              iconColor: const Color(0xFFF59E0B),
              children: [
                HosoInfoRow(label: 'Số ngân hàng', value: profile.bankNumber),
                HosoInfoRow(
                    label: 'Họ và tên chủ thẻ',
                    value: profile.bankAccountName),
                HosoInfoRow(label: 'Tên ngân hàng', value: profile.bankName),
                HosoInfoRow(
                    label: 'Mã số thuế', value: profile.taxCode, isLast: true),
              ],
            ),
            HosoSection(
              title: 'CCCD/CMND',
              icon: FontAwesomeIcons.addressCard,
              iconColor: const Color(0xFFEC4899),
              children: [
                HosoInfoRow(
                    label: 'Số CCCD/CMND', value: profile.cccdNumber),
                HosoInfoRow(label: 'Ngày cấp', value: profile.cccdIssueDate),
                HosoInfoRow(
                    label: 'Nơi cấp',
                    value: profile.cccdIssuePlace,
                    isLast: true),
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
                HosoInfoRow(
                    label: 'Văn bằng chuyên môn', value: profile.cchnDegree),
                HosoInfoRow(
                    label: 'Phạm vi hoạt động', value: profile.cchnScope),
                HosoInfoRow(label: 'Upload file', value: profile.cchnFile),
                HosoInfoRow(
                    label: 'Ngày cấp dự kiến',
                    value: profile.cchnPlannedDate,
                    isLast: true),
              ],
            ),
            HosoSection(
              title: 'Chức danh',
              icon: FontAwesomeIcons.trophy,
              iconColor: const Color(0xFFFCD34D),
              children: [
                HosoInfoRow(label: 'Tên chức danh', value: profile.titleName),
                HosoInfoRow(
                    label: 'Hội đồng chức danh', value: profile.titleCouncil),
                HosoInfoRow(
                    label: 'Ngày cấp chức danh',
                    value: profile.titleIssueDate,
                    isLast: true),
              ],
            ),
            HosoSection(
              title: 'Bằng cấp',
              icon: FontAwesomeIcons.graduationCap,
              iconColor: const Color(0xFFEF4444),
              children: profile.degrees.asMap().entries.map((entry) {
                final degree = entry.value;
                return HosoSubCard(
                  index: entry.key,
                  children: [
                    HosoInfoRow(label: 'Văn bằng', value: degree.major),
                    HosoInfoRow(label: 'Nơi cấp', value: degree.place),
                    HosoInfoRow(label: 'Xếp loại', value: degree.level),
                    HosoInfoRow(label: 'Ngày cấp', value: degree.date),
                    HosoInfoRow(
                        label: 'Tệp đính kèm',
                        value: degree.attachmentName,
                        isLast: true),
                  ],
                );
              }).toList(),
            ),
            HosoSection(
              title: 'Chứng chỉ đào tạo',
              icon: FontAwesomeIcons.award,
              iconColor: const Color(0xFF14B8A6),
              children: profile.certificates.asMap().entries.map((entry) {
                final cert = entry.value;
                return HosoSubCard(
                  index: entry.key,
                  children: [
                    HosoInfoRow(label: 'Tên chứng chỉ', value: cert.name),
                    HosoInfoRow(label: 'Ngày', value: cert.date),
                    HosoInfoRow(
                        label: 'Tệp đính kèm',
                        value: cert.attachmentName,
                        isLast: true),
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

class _WebHosoPage extends StatefulWidget {
  const _WebHosoPage();

  @override
  State<_WebHosoPage> createState() => _WebHosoPageState();
}

class _WebHosoPageState extends State<_WebHosoPage> {
  int _selected = 0;

  static const List<(IconData, String, Color)> _navItems = [
    (FontAwesomeIcons.idCard, 'Thông tin cá nhân', Color(0xFF1877F2)),
    (FontAwesomeIcons.peopleGroup, 'Thân nhân', Color(0xFF10B981)),
    (FontAwesomeIcons.arrowsRotate, 'Điều chuyển', Color(0xFF8B5CF6)),
    (FontAwesomeIcons.shieldHalved, 'Bảo hiểm', Color(0xFF3B82F6)),
    (FontAwesomeIcons.buildingColumns, 'Ngân hàng & Thuế', Color(0xFFF59E0B)),
    (FontAwesomeIcons.addressCard, 'CCCD/CMND', Color(0xFFEC4899)),
    (FontAwesomeIcons.certificate, 'CCHN', Color(0xFF06B6D4)),
    (FontAwesomeIcons.trophy, 'Chức danh', Color(0xFFFCD34D)),
    (FontAwesomeIcons.graduationCap, 'Bằng cấp', Color(0xFFEF4444)),
    (FontAwesomeIcons.award, 'Chứng chỉ đào tạo', Color(0xFF14B8A6)),
    (FontAwesomeIcons.clockRotateLeft, 'Đào tạo liên tục', Color(0xFFA855F7)),
  ];

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<HosoProvider>().profile;
    final auth = context.watch<XacthucProvider>();
    final avatarUrl = auth.user?.hinhAnh;

    return Scaffold(
      backgroundColor: context.bgColor,
      body: Column(
        children: [
          _buildTopBar(context),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSidebar(context, profile, avatarUrl),
                VerticalDivider(
                    width: 1, thickness: 1, color: context.borderColor),
                Expanded(child: _buildContent(context, profile)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: context.cardColor,
        border: Border(bottom: BorderSide(color: context.borderColor)),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: context.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: FaIcon(FontAwesomeIcons.idCard,
                  size: 16, color: context.primaryColor),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Hồ Sơ Cá Nhân',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: context.textPrimary,
              letterSpacing: -0.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar(
      BuildContext context, HosoData profile, String? avatarUrl) {
    return SizedBox(
      width: 256,
      child: Container(
        color: context.cardColor,
        child: Column(
          children: [
            _WebProfileCard(
              name: profile.fullName,
              birthYear: profile.birthYear,
              gender: profile.gender,
              avatarUrl: avatarUrl,
            ),
            Divider(height: 1, thickness: 1, color: context.borderColor),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'DANH MỤC',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: context.textSecondary,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                itemCount: _navItems.length,
                itemBuilder: (ctx, i) {
                  final item = _navItems[i];
                  return _WebNavItem(
                    icon: item.$1,
                    label: item.$2,
                    color: item.$3,
                    isSelected: _selected == i,
                    onTap: () => setState(() => _selected = i),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, HosoData profile) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 860),
          child: SizedBox(
            width: double.infinity,
            child: _buildSection(profile),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(HosoData profile) {
    switch (_selected) {
      case 0:
        return HosoSection(
          title: 'Thông tin cá nhân',
          icon: FontAwesomeIcons.idCard,
          children: [
            HosoInfoRow(label: 'Họ và tên', value: profile.fullName),
            HosoInfoRow(label: 'Năm sinh', value: profile.birthYear),
            HosoInfoRow(label: 'Giới tính', value: profile.gender),
            HosoInfoRow(
                label: 'Tình trạng hôn nhân', value: profile.maritalStatus),
            HosoInfoRow(
                label: 'Chỗ ở hiện tại', value: profile.currentAddress),
            HosoInfoRow(
                label: 'Thường trú',
                value: profile.permanentAddress,
                isLast: true),
          ],
        );
      case 1:
        return HosoSection(
          title: 'Thân nhân',
          icon: FontAwesomeIcons.peopleGroup,
          iconColor: const Color(0xFF10B981),
          children: profile.relatives.asMap().entries.map((e) => HosoSubCard(
                index: e.key,
                children: [
                  HosoInfoRow(label: 'Quan hệ', value: e.value.relation),
                  HosoInfoRow(label: 'Họ và tên', value: e.value.fullName),
                  HosoInfoRow(label: 'Năm sinh', value: e.value.birthYear),
                  HosoInfoRow(label: 'CCCD', value: e.value.cccd),
                  HosoInfoRow(
                      label: 'BHYT', value: e.value.bhyt, isLast: true),
                ],
              )).toList(),
        );
      case 2:
        return HosoSection(
          title: 'Điều chuyển',
          icon: FontAwesomeIcons.arrowsRotate,
          iconColor: const Color(0xFF8B5CF6),
          children: [
            HosoInfoRow(label: 'Nội dung', value: profile.transfer.content),
            HosoInfoRow(
                label: 'Ngày', value: profile.transfer.date, isLast: true),
          ],
        );
      case 3:
        return HosoSection(
          title: 'Bảo hiểm',
          icon: FontAwesomeIcons.shieldHalved,
          iconColor: const Color(0xFF3B82F6),
          children: [
            HosoInfoRow(label: 'Số BHYT', value: profile.bhytNumber),
            HosoInfoRow(
                label: 'Nơi đăng ký BHYT', value: profile.bhytRegisterPlace),
            HosoInfoRow(
                label: 'Số BHXH', value: profile.bhxhNumber, isLast: true),
          ],
        );
      case 4:
        return HosoSection(
          title: 'Ngân hàng & Thuế',
          icon: FontAwesomeIcons.buildingColumns,
          iconColor: const Color(0xFFF59E0B),
          children: [
            HosoInfoRow(label: 'Số ngân hàng', value: profile.bankNumber),
            HosoInfoRow(
                label: 'Họ và tên chủ thẻ', value: profile.bankAccountName),
            HosoInfoRow(label: 'Tên ngân hàng', value: profile.bankName),
            HosoInfoRow(
                label: 'Mã số thuế', value: profile.taxCode, isLast: true),
          ],
        );
      case 5:
        return HosoSection(
          title: 'CCCD/CMND',
          icon: FontAwesomeIcons.addressCard,
          iconColor: const Color(0xFFEC4899),
          children: [
            HosoInfoRow(label: 'Số CCCD/CMND', value: profile.cccdNumber),
            HosoInfoRow(label: 'Ngày cấp', value: profile.cccdIssueDate),
            HosoInfoRow(
                label: 'Nơi cấp',
                value: profile.cccdIssuePlace,
                isLast: true),
          ],
        );
      case 6:
        return HosoSection(
          title: 'CCHN',
          icon: FontAwesomeIcons.certificate,
          iconColor: const Color(0xFF06B6D4),
          children: [
            HosoInfoRow(label: 'Số CCHN', value: profile.cchnNumber),
            HosoInfoRow(label: 'Ngày cấp', value: profile.cchnIssueDate),
            HosoInfoRow(label: 'Nơi cấp', value: profile.cchnIssuePlace),
            HosoInfoRow(
                label: 'Văn bằng chuyên môn', value: profile.cchnDegree),
            HosoInfoRow(
                label: 'Phạm vi hoạt động', value: profile.cchnScope),
            HosoInfoRow(label: 'Upload file', value: profile.cchnFile),
            HosoInfoRow(
                label: 'Ngày cấp dự kiến',
                value: profile.cchnPlannedDate,
                isLast: true),
          ],
        );
      case 7:
        return HosoSection(
          title: 'Chức danh',
          icon: FontAwesomeIcons.trophy,
          iconColor: const Color(0xFFFCD34D),
          children: [
            HosoInfoRow(label: 'Tên chức danh', value: profile.titleName),
            HosoInfoRow(
                label: 'Hội đồng chức danh', value: profile.titleCouncil),
            HosoInfoRow(
                label: 'Ngày cấp chức danh',
                value: profile.titleIssueDate,
                isLast: true),
          ],
        );
      case 8:
        return HosoSection(
          title: 'Bằng cấp',
          icon: FontAwesomeIcons.graduationCap,
          iconColor: const Color(0xFFEF4444),
          children: profile.degrees.asMap().entries.map((e) => HosoSubCard(
                index: e.key,
                children: [
                  HosoInfoRow(label: 'Văn bằng', value: e.value.major),
                  HosoInfoRow(label: 'Nơi cấp', value: e.value.place),
                  HosoInfoRow(label: 'Xếp loại', value: e.value.level),
                  HosoInfoRow(label: 'Ngày cấp', value: e.value.date),
                  HosoInfoRow(
                      label: 'Tệp đính kèm',
                      value: e.value.attachmentName,
                      isLast: true),
                ],
              )).toList(),
        );
      case 9:
        return HosoSection(
          title: 'Chứng chỉ đào tạo',
          icon: FontAwesomeIcons.award,
          iconColor: const Color(0xFF14B8A6),
          children: profile.certificates.asMap().entries.map((e) => HosoSubCard(
                index: e.key,
                children: [
                  HosoInfoRow(label: 'Tên chứng chỉ', value: e.value.name),
                  HosoInfoRow(label: 'Ngày', value: e.value.date),
                  HosoInfoRow(
                      label: 'Tệp đính kèm',
                      value: e.value.attachmentName,
                      isLast: true),
                ],
              )).toList(),
        );
      case 10:
      default:
        return HosoSection(
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
        );
    }
  }
}

class _WebProfileCard extends StatelessWidget {
  final String name;
  final String birthYear;
  final String gender;
  final String? avatarUrl;

  const _WebProfileCard({
    required this.name,
    required this.birthYear,
    required this.gender,
    this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: AppColors.primaryGradient,
              ),
              shape: BoxShape.circle,
            ),
            child: ClipOval(child: _buildAvatarContent()),
          ),
          const SizedBox(height: 12),
          Text(
            name,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: context.textPrimary,
              letterSpacing: -0.3,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildChip(context, FontAwesomeIcons.cakeCandles, birthYear),
              const SizedBox(width: 6),
              _buildChip(
                context,
                gender.toLowerCase().contains('nam')
                    ? FontAwesomeIcons.mars
                    : FontAwesomeIcons.venus,
                gender,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarContent() {
    if (avatarUrl != null && avatarUrl!.isNotEmpty) {
      final token = TokenManager().getCachedToken();
      return CachedNetworkImage(
        imageUrl: avatarUrl!,
        httpHeaders: token != null ? {'Authorization': 'Bearer $token'} : {},
        width: 72,
        height: 72,
        fit: BoxFit.cover,
        placeholder: (ctx, url) => _defaultIcon(),
        errorWidget: (ctx, url, err) => _defaultIcon(),
      );
    }
    return _defaultIcon();
  }

  Widget _defaultIcon() {
    return const Center(
      child: FaIcon(FontAwesomeIcons.userTie, color: Colors.white, size: 30),
    );
  }

  Widget _buildChip(BuildContext context, IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: context.primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(icon, size: 10, color: context.primaryColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: context.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _WebNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _WebNavItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.only(bottom: 2),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: isSelected
                    ? color.withValues(alpha: 0.18)
                    : context.surfaceColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: FaIcon(
                  icon,
                  size: 13,
                  color: isSelected ? color : context.textSecondary,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight:
                      isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? color : context.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isSelected)
              Container(
                width: 6,
                height: 6,
                decoration:
                    BoxDecoration(color: color, shape: BoxShape.circle),
              ),
          ],
        ),
      ),
    );
  }
}
