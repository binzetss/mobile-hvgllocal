import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/extensions/theme_extensions.dart';
import '../../core/utils/token_manager.dart';
import '../../data/models/nhansu_model.dart';

class NhansuCard extends StatelessWidget {
  final NhansuModel staff;
  final VoidCallback? onTap;
  final int index;
  final Color? departmentColor;

  const NhansuCard({
    super.key,
    required this.staff,
    this.onTap,
    this.index = 0,
    this.departmentColor,
  });

  String _buildInitials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    final first = parts.first.substring(0, 1);
    final last = parts.last.substring(0, 1);
    return (first + last).toUpperCase();
  }

  String _formatBirthDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (_) {
      return dateStr;
    }
  }

  Color? _getPositionColor() {
    final pos = staff.tenChucVu.toLowerCase().trim();
    if (pos.contains('hội đồng')) return const Color(0xFF14B8A6);
    if (pos.contains('phó') && pos.contains('giám đốc'))
      return const Color(0xFF06B6D4);
    if (pos.contains('giám đốc')) return const Color(0xFF9333EA);
    if (pos.contains('chủ tịch')) return const Color(0xFF6366F1);
    if (pos.contains('tổ trưởng')) return const Color(0xFF22C55E);
    if (pos.contains('trưởng ban')) return const Color(0xFFF97316);
    if (pos.contains('trưởng')) return const Color(0xFFF59E0B);
    if (pos.contains('phó')) return const Color(0xFF3B82F6);
    return null;
  }

  Color _getAvatarColor(Color? posColor) {
    if (posColor != null) return posColor;
    if (departmentColor != null) return departmentColor!;
    final colors = [
      const Color(0xFF2196F3),
      const Color(0xFF4CAF50),
      const Color(0xFF00BCD4),
      const Color(0xFF9C27B0),
      const Color(0xFFE91E63),
    ];
    return colors[staff.id.hashCode % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final posColor = _getPositionColor();
    final avatarColor = _getAvatarColor(posColor);
    final initials = _buildInitials(staff.hoVaTen);

    return InkWell(
      onTap: onTap ?? () => _showStaffDetails(context),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: context.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: posColor != null
                ? posColor.withValues(alpha: 0.6)
                : context.borderColor,
            width: posColor != null ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: avatarColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child:
                    staff.anhDaiDienUrl != null &&
                        staff.anhDaiDienUrl!.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: staff.anhDaiDienUrl!,
                        httpHeaders: {
                          if (TokenManager().getCachedToken() != null)
                            'Authorization':
                                'Bearer ${TokenManager().getCachedToken()}',
                        },
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Center(
                          child: Text(
                            initials,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: avatarColor,
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Center(
                          child: Text(
                            initials,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: avatarColor,
                            ),
                          ),
                        ),
                      )
                    : Center(
                        child: Text(
                          initials,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: avatarColor,
                          ),
                        ),
                      ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          staff.hoVaTen,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: context.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (posColor != null) ...[
                        const SizedBox(width: 6),
                        _buildPositionBadge(posColor),
                      ],
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    staff.chucVu,
                    style: TextStyle(fontSize: 13, color: context.textSecondary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (staff.soDienThoai != null &&
                      staff.soDienThoai!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.phone, size: 11, color: context.textSecondary),
                        const SizedBox(width: 4),
                        Text(
                          staff.soDienThoai!,
                          style: TextStyle(
                            fontSize: 12,
                            color: context.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (staff.namSinh != null &&
                      staff.namSinh!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.cake_outlined,
                            size: 11, color: context.textSecondary),
                        const SizedBox(width: 4),
                        Text(
                          _formatBirthDate(staff.namSinh!),
                          style: TextStyle(
                            fontSize: 12,
                            color: context.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.chevron_right, color: context.textSecondary, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildPositionBadge(Color color) {
    final label = staff.tenChucVu.isNotEmpty ? staff.tenChucVu : 'Trưởng';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: color.withValues(alpha: 0.4),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star_rounded, size: 10, color: color),
          const SizedBox(width: 3),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: color,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }

  void _showStaffDetails(BuildContext context) {
    final isDesktop = kIsWeb && MediaQuery.of(context).size.width >= 768;
    final deptColor = departmentColor ?? const Color(0xFF2196F3);

    if (isDesktop) {
      showDialog(
        context: context,
        builder: (context) => Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(32),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: _StaffDetailContent(
              staff: staff,
              departmentColor: deptColor,
              isDialog: true,
            ),
          ),
        ),
      );
    } else {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => _StaffDetailContent(
          staff: staff,
          departmentColor: deptColor,
          isDialog: false,
        ),
      );
    }
  }
}

class _StaffDetailContent extends StatelessWidget {
  final NhansuModel staff;
  final Color departmentColor;
  final bool isDialog;

  const _StaffDetailContent({
    required this.staff,
    required this.departmentColor,
    required this.isDialog,
  });

  String _buildInitials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (_) {
      return dateStr;
    }
  }

  Color? _getPositionColor() {
    final pos = staff.tenChucVu.toLowerCase().trim();
    if (pos.contains('hội đồng')) return const Color(0xFF14B8A6);
    if (pos.contains('phó') && pos.contains('giám đốc'))
      return const Color(0xFF06B6D4);
    if (pos.contains('giám đốc')) return const Color(0xFF9333EA);
    if (pos.contains('chủ tịch')) return const Color(0xFF6366F1);
    if (pos.contains('tổ trưởng')) return const Color(0xFF22C55E);
    if (pos.contains('trưởng ban')) return const Color(0xFFF97316);
    if (pos.contains('trưởng')) return const Color(0xFFF59E0B);
    if (pos.contains('phó')) return const Color(0xFF3B82F6);
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final posColor = _getPositionColor();
    final avatarColor = posColor ?? departmentColor;
    final initials = _buildInitials(staff.hoVaTen);
    final hasPhone =
        staff.soDienThoai != null && staff.soDienThoai!.isNotEmpty;

    final radius = isDialog
        ? BorderRadius.circular(24)
        : const BorderRadius.vertical(top: Radius.circular(24));

    return ClipRRect(
      borderRadius: radius,
      child: Container(
        decoration: BoxDecoration(
          color: context.cardColor,
          borderRadius: radius,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            _buildHeader(context, avatarColor, initials, posColor),

            _buildInfoSection(context),

            _buildActions(context, hasPhone),
            SizedBox(
                height: isDialog
                    ? 20
                    : MediaQuery.of(context).padding.bottom + 16),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(
      BuildContext context, Color avatarColor, String initials, Color? posColor) {

    final gradEnd = Color.fromARGB(
      255,
      (avatarColor.r * 255 * 0.75).round().clamp(0, 255),
      (avatarColor.g * 255 * 0.75).round().clamp(0, 255),
      (avatarColor.b * 255 * 0.85).round().clamp(0, 255),
    );

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [avatarColor, gradEnd],
        ),
      ),
      child: Stack(
        children: [

          if (isDialog)
            Positioned(
              top: 12,
              right: 12,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.close_rounded,
                      size: 16, color: Colors.white),
                ),
              ),
            ),

          if (!isDialog)
            Positioned(
              top: 10,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),

          Padding(
            padding: EdgeInsets.fromLTRB(20, isDialog ? 20 : 24, 20, 24),
            child: Column(
              children: [

                Container(
                  width: 84,
                  height: 84,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                        color: Colors.white.withValues(alpha: 0.6), width: 2.5),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 16,
                          offset: const Offset(0, 4)),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: staff.anhDaiDienUrl != null &&
                            staff.anhDaiDienUrl!.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: staff.anhDaiDienUrl!,
                            httpHeaders: {
                              if (TokenManager().getCachedToken() != null)
                                'Authorization':
                                    'Bearer ${TokenManager().getCachedToken()}',
                            },
                            fit: BoxFit.cover,
                            placeholder: (context2, url) => Center(
                              child: Text(initials,
                                  style: const TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white)),
                            ),
                            errorWidget: (context2, url, err) => Center(
                              child: Text(initials,
                                  style: const TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white)),
                            ),
                          )
                        : Center(
                            child: Text(initials,
                                style: const TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white)),
                          ),
                  ),
                ),
                const SizedBox(height: 14),

                Text(
                  staff.hoVaTen,
                  style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: -0.4),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),

                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    if (posColor != null && staff.tenChucVu.isNotEmpty)
                      _Chip(
                          text: staff.tenChucVu,
                          icon: Icons.star_rounded,
                          bright: true),
                    if (staff.chucVu.isNotEmpty &&
                        staff.chucVu != staff.tenChucVu)
                      _Chip(text: staff.chucVu, bright: false),
                  ],
                ),
                if (staff.khoaPhongTen.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.location_on_rounded,
                          size: 12, color: Colors.white60),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          staff.khoaPhongTen,
                          style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white70,
                              fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context) {
    final isDark = context.isDark;
    final rows = <_InfoRowData>[];

    rows.add(_InfoRowData(
        icon: FontAwesomeIcons.idBadge,
        label: 'Mã nhân viên',
        value: staff.maSo,
        color: const Color(0xFF6366F1)));

    rows.add(_InfoRowData(
        icon: FontAwesomeIcons.buildingUser,
        label: 'Khoa / Phòng',
        value: staff.khoaPhongTen.isNotEmpty ? staff.khoaPhongTen : '—',
        color: const Color(0xFF0EA5E9)));

    if (staff.soDienThoai != null && staff.soDienThoai!.isNotEmpty) {
      rows.add(_InfoRowData(
          icon: FontAwesomeIcons.phone,
          label: 'Điện thoại',
          value: staff.soDienThoai!,
          color: const Color(0xFF22C55E)));
    }

    if (staff.namSinh != null && staff.namSinh!.isNotEmpty) {
      rows.add(_InfoRowData(
          icon: FontAwesomeIcons.cakeCandles,
          label: 'Ngày sinh',
          value: _formatDate(staff.namSinh!),
          color: const Color(0xFFF97316)));
    }

    if (staff.gioiTinh != null && staff.gioiTinh!.isNotEmpty) {
      rows.add(_InfoRowData(
          icon: FontAwesomeIcons.person,
          label: 'Giới tính',
          value: staff.gioiTinh!,
          color: const Color(0xFFEC4899)));
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      decoration: BoxDecoration(
        color: isDark
            ? context.surfaceColor
            : const Color(0xFFF8F9FB),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: context.borderColor.withValues(alpha: isDark ? 1.0 : 0.5)),
      ),
      child: Column(
        children: [
          for (int i = 0; i < rows.length; i++) ...[
            _buildInfoRow(context, rows[i]),
            if (i < rows.length - 1)
              Divider(
                  height: 1,
                  indent: 52,
                  color: context.borderColor.withValues(alpha: 0.6)),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, _InfoRowData data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: data.color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Center(
              child: FaIcon(data.icon, size: 13, color: data.color),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data.label,
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: context.textSecondary)),
                const SizedBox(height: 2),
                Text(data.value,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: context.textPrimary),
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context, bool hasPhone) {
    final isDesktop = kIsWeb && MediaQuery.of(context).size.width >= 768;
    final zaloBtn = _ActionButton(
      label: 'Mở Zalo',
      imageAsset: 'assets/images/zalo.png',
      color: const Color(0xFF0EA5E9),
      enabled: hasPhone,
      onPressed: hasPhone
          ? () => launchUrl(
              Uri.parse('https://zalo.me/${staff.soDienThoai}'),
              mode: LaunchMode.externalApplication)
          : null,
    );

    if (isDesktop) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: zaloBtn,
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        children: [
          Expanded(
            child: _ActionButton(
              label: 'Gọi điện',
              imageAsset: 'assets/images/telephone.png',
              imageSize: 26,
              color: const Color(0xFF22C55E),
              enabled: hasPhone,
              onPressed: hasPhone
                  ? () => launchUrl(
                      Uri.parse('tel:${staff.soDienThoai}'),
                      mode: LaunchMode.externalApplication)
                  : null,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: zaloBtn),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String text;
  final IconData? icon;
  final bool bright;

  const _Chip({required this.text, this.icon, required this.bright});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bright
            ? Colors.white.withValues(alpha: 0.25)
            : Colors.black.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
            color: Colors.white.withValues(alpha: bright ? 0.5 : 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 11, color: Colors.white),
            const SizedBox(width: 4),
          ],
          Text(text,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withValues(alpha: bright ? 1.0 : 0.85))),
        ],
      ),
    );
  }
}

class _InfoRowData {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  const _InfoRowData(
      {required this.icon,
      required this.label,
      required this.value,
      required this.color});
}

class _ActionButton extends StatelessWidget {
  final String label;
  final String? imageAsset;
  final double imageSize;
  final Color color;
  final bool enabled;
  final VoidCallback? onPressed;

  const _ActionButton({
    required this.label,
    this.imageAsset,
    this.imageSize = 32,
    required this.color,
    required this.enabled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: enabled ? color : context.surfaceColor,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (imageAsset != null)
                Opacity(
                  opacity: enabled ? 1.0 : 0.4,
                  child: Image.asset(imageAsset!, width: imageSize, height: imageSize),
                ),
              const SizedBox(width: 8),
              Text(label,
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color:
                          enabled ? Colors.white : context.textSecondary)),
            ],
          ),
        ),
      ),
    );
  }
}
