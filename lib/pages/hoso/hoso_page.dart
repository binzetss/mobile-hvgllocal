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
import '../../providers/hoso_provider.dart';
import '../../providers/xacthuc_provider.dart';
import '../../widgets/common/common_app_bar.dart';
import '../../widgets/hoso/hoso_header.dart';
import '../../widgets/hoso/hoso_section.dart';
import '../../widgets/hoso/hoso_info_row.dart';
import '../../widgets/hoso/hoso_sub_card.dart';

class HosoPage extends StatefulWidget {
  const HosoPage({super.key});

  @override
  State<HosoPage> createState() => _HosoPageState();
}

class _HosoPageState extends State<HosoPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final xacThuc = context.read<XacthucProvider>();
      final maSo = xacThuc.user?.maSo ?? '';
      final hoso = context.read<HosoProvider>();
      hoso.fetchNhanVien(maSo);
      hoso.fetchThanNhan();
    });
  }

  Future<void> _pickAvatar(BuildContext ctx) async {
    await showModalBottomSheet(
      context: ctx,
      backgroundColor: ctx.cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetCtx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.only(top: 12, bottom: 16),
              decoration: BoxDecoration(
                color: sheetCtx.borderColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ListTile(
              leading: FaIcon(FontAwesomeIcons.camera, color: sheetCtx.primaryColor),
              title: const Text('Chụp ảnh'),
              onTap: () {
                Navigator.pop(sheetCtx);
                _upload(ctx, ImageSource.camera);
              },
            ),
            ListTile(
              leading: FaIcon(FontAwesomeIcons.image, color: sheetCtx.primaryColor),
              title: const Text('Chọn từ thư viện'),
              onTap: () {
                Navigator.pop(sheetCtx);
                _upload(ctx, ImageSource.gallery);
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Future<void> _upload(BuildContext ctx, ImageSource source) async {
    final xacThuc = context.read<XacthucProvider>();
    final nav = Navigator.of(ctx);
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source, imageQuality: 85, maxWidth: 800);
    if (picked == null) return;
    if (!mounted) return;
    final cropped = await nav.push<File?>(
      MaterialPageRoute(
        builder: (_) => CropAvatarPage(imageFile: File(picked.path)),
      ),
    );
    if (cropped == null || !mounted) return;
    await xacThuc.uploadAnhDaiDien(cropped);
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) return const _WebHosoPage();

    return Scaffold(
      backgroundColor: context.bgColor,
      appBar: CommonAppBar(title: 'Hồ Sơ Cá Nhân'),
      body: Consumer<HosoProvider>(
        builder: (context, hoso, _) {
          final nv = hoso.nhanVien;
          final isLoadingNv = hoso.isLoadingNhanVien;
          final isLoadingTn = hoso.isLoadingThanNhan;
          final thanNhans = hoso.thanNhans;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                if (isLoadingNv)
                  const Center(child: CircularProgressIndicator())
                else if (nv != null)
                  HosoHeader(
                    name: nv.hoVaTen,
                    birthYear: nv.namSinh ?? '',
                    gender: nv.gioiTinh ?? '',
                    chucDanh: nv.chucVu,
                    avatarUrl: nv.anhDaiDienUrl,
                    localAvatarFile: hoso.localAvatar,
                    onAvatarTap: () => _pickAvatar(context),
                  ),

                const SizedBox(height: 16),

                // Thông tin cá nhân
                HosoSection(
                  title: 'Thông tin cá nhân',
                  icon: FontAwesomeIcons.idCard,
                  children: isLoadingNv
                      ? [const Center(child: CircularProgressIndicator())]
                      : [
                          HosoInfoRow(label: 'Họ và tên', value: nv?.hoVaTen ?? ''),
                          HosoInfoRow(label: 'Ngày sinh', value: nv?.namSinh ?? ''),
                          HosoInfoRow(label: 'Giới tính', value: nv?.gioiTinh ?? ''),
                          HosoInfoRow(
                            label: 'Tình trạng hôn nhân',
                            value: nv?.tenTinhTrangHonNhan ?? '',
                          ),
                          HosoInfoRow(label: 'Tôn giáo', value: nv?.tenTonGiao ?? ''),
                          HosoInfoRow(label: 'Tổ đội', value: nv?.tenToDoi ?? ''),
                          HosoInfoRow(label: 'Khoa phòng', value: nv?.khoaPhongTen ?? ''),
                          HosoInfoRow(label: 'Chức vụ', value: nv?.tenChucVu ?? ''),
                          HosoInfoRow(label: 'Số điện thoại', value: nv?.soDienThoai ?? ''),
                          HosoInfoRow(
                            label: 'Chỗ ở hiện tại',
                            value: nv?.diaChi ?? '',
                            isLast: true,
                          ),
                        ],
                ),

                // Thân nhân
                HosoSection(
                  title: 'Thân nhân',
                  icon: FontAwesomeIcons.peopleGroup,
                  children: isLoadingTn
                      ? [const Center(child: CircularProgressIndicator())]
                      : thanNhans.isEmpty
                          ? [
                              Center(
                                child: Text(
                                  'Chưa có dữ liệu',
                                  style: TextStyle(color: context.textSecondary),
                                ),
                              ),
                            ]
                          : List.generate(thanNhans.length, (i) {
                              final t = thanNhans[i];
                              return HosoSubCard(
                                index: i,
                                children: [
                                  HosoInfoRow(label: 'Quan hệ', value: t.moiQuanHe),
                                  HosoInfoRow(label: 'Họ và tên', value: t.tenThanNhan),
                                  HosoInfoRow(
                                    label: 'Số CCCD',
                                    value: t.soCCCD,
                                    isLast: true,
                                  ),
                                ],
                              );
                            }),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ─── Web ────────────────────────────────────────────────────────────────────

class _WebHosoPage extends StatefulWidget {
  const _WebHosoPage();

  @override
  State<_WebHosoPage> createState() => _WebHosoPageState();
}

class _WebHosoPageState extends State<_WebHosoPage> {
  int _selectedIndex = 0;

  final List<_NavItem> _navItems = const [
    _NavItem(icon: FontAwesomeIcons.idCard, label: 'Thông tin cá nhân'),
    _NavItem(icon: FontAwesomeIcons.peopleGroup, label: 'Thân nhân'),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final xacThuc = context.read<XacthucProvider>();
      final maSo = xacThuc.user?.maSo ?? '';
      final hoso = context.read<HosoProvider>();
      hoso.fetchNhanVien(maSo);
      hoso.fetchThanNhan();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.bgColor,
      appBar: CommonAppBar(title: 'Hồ Sơ Cá Nhân'),
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 256,
            color: context.cardColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Web profile card
                Consumer2<HosoProvider, XacthucProvider>(
                  builder: (context, hoso, xacThuc, _) {
                    final nv = hoso.nhanVien;
                    return _WebProfileCard(
                      name: nv?.hoVaTen ?? xacThuc.user?.hoVaTen ?? '',
                      chucDanh: nv?.chucVu ?? '',
                      avatarUrl: nv?.anhDaiDienUrl,
                      localAvatarFile: hoso.localAvatar,
                    );
                  },
                ),
                const Divider(height: 1),
                const SizedBox(height: 8),
                ...List.generate(_navItems.length, (i) {
                  return _WebNavItem(
                    item: _navItems[i],
                    isSelected: _selectedIndex == i,
                    onTap: () => setState(() => _selectedIndex = i),
                  );
                }),
              ],
            ),
          ),

          // Content
          Expanded(
            child: Consumer<HosoProvider>(
              builder: (context, hoso, _) {
                final nv = hoso.nhanVien;
                final isLoadingNv = hoso.isLoadingNhanVien;
                final isLoadingTn = hoso.isLoadingThanNhan;
                final thanNhans = hoso.thanNhans;

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: _selectedIndex == 0
                      ? HosoSection(
                          title: 'Thông tin cá nhân',
                          icon: FontAwesomeIcons.idCard,
                          children: isLoadingNv
                              ? [const Center(child: CircularProgressIndicator())]
                              : [
                                  HosoInfoRow(label: 'Họ và tên', value: nv?.hoVaTen ?? ''),
                                  HosoInfoRow(label: 'Ngày sinh', value: nv?.namSinh ?? ''),
                                  HosoInfoRow(label: 'Giới tính', value: nv?.gioiTinh ?? ''),
                                  HosoInfoRow(
                                    label: 'Tình trạng hôn nhân',
                                    value: nv?.tenTinhTrangHonNhan ?? '',
                                  ),
                                  HosoInfoRow(label: 'Tôn giáo', value: nv?.tenTonGiao ?? ''),
                                  HosoInfoRow(label: 'Tổ đội', value: nv?.tenToDoi ?? ''),
                                  HosoInfoRow(label: 'Khoa phòng', value: nv?.khoaPhongTen ?? ''),
                                  HosoInfoRow(label: 'Chức vụ', value: nv?.tenChucVu ?? ''),
                                  HosoInfoRow(
                                    label: 'Số điện thoại',
                                    value: nv?.soDienThoai ?? '',
                                  ),
                                  HosoInfoRow(
                                    label: 'Chỗ ở hiện tại',
                                    value: nv?.diaChi ?? '',
                                    isLast: true,
                                  ),
                                ],
                        )
                      : HosoSection(
                          title: 'Thân nhân',
                          icon: FontAwesomeIcons.peopleGroup,
                          children: isLoadingTn
                              ? [const Center(child: CircularProgressIndicator())]
                              : thanNhans.isEmpty
                                  ? [
                                      Center(
                                        child: Text(
                                          'Chưa có dữ liệu',
                                          style: TextStyle(color: context.textSecondary),
                                        ),
                                      ),
                                    ]
                                  : List.generate(thanNhans.length, (i) {
                                      final t = thanNhans[i];
                                      return HosoSubCard(
                                        index: i,
                                        children: [
                                          HosoInfoRow(label: 'Quan hệ', value: t.moiQuanHe),
                                          HosoInfoRow(label: 'Họ và tên', value: t.tenThanNhan),
                                          HosoInfoRow(
                                            label: 'Số CCCD',
                                            value: t.soCCCD,
                                            isLast: true,
                                          ),
                                        ],
                                      );
                                    }),
                        ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;

  const _NavItem({required this.icon, required this.label});
}

class _WebProfileCard extends StatelessWidget {
  final String name;
  final String chucDanh;
  final String? avatarUrl;
  final File? localAvatarFile;

  const _WebProfileCard({
    required this.name,
    required this.chucDanh,
    this.avatarUrl,
    this.localAvatarFile,
  });

  Widget _buildAvatarContent() {
    if (localAvatarFile != null) {
      return Image.file(
        localAvatarFile!,
        width: 64,
        height: 64,
        fit: BoxFit.cover,
        errorBuilder: (ctx, err, st) => const FaIcon(
          FontAwesomeIcons.userTie,
          color: Colors.white,
          size: 28,
        ),
      );
    }
    if (avatarUrl != null && avatarUrl!.isNotEmpty) {
      final token = TokenManager().getCachedToken();
      return CachedNetworkImage(
        imageUrl: avatarUrl!,
        httpHeaders: token != null ? {'Authorization': 'Bearer $token'} : {},
        width: 64,
        height: 64,
        fit: BoxFit.cover,
        placeholder: (ctx, url) => const FaIcon(
          FontAwesomeIcons.userTie,
          color: Colors.white,
          size: 28,
        ),
        errorWidget: (ctx, url, err) => const FaIcon(
          FontAwesomeIcons.userTie,
          color: Colors.white,
          size: 28,
        ),
      );
    }
    return const FaIcon(FontAwesomeIcons.userTie, color: Colors.white, size: 28);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
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
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (chucDanh.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              chucDanh,
              style: TextStyle(fontSize: 12, color: context.textSecondary),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}

class _WebNavItem extends StatelessWidget {
  final _NavItem item;
  final bool isSelected;
  final VoidCallback onTap;

  const _WebNavItem({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? context.primaryColor.withValues(alpha: 0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            FaIcon(
              item.icon,
              size: 15,
              color: isSelected ? context.primaryColor : context.textSecondary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                item.label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? context.primaryColor : context.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
