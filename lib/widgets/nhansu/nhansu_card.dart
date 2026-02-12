import 'dart:convert';
import 'package:flutter/material.dart';
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

  Color _getAvatarColor() {
    if (staff.isHead) return const Color(0xFFFF9800);
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
    final avatarColor = _getAvatarColor();
    final initials = _buildInitials(staff.hoVaTen);

    return InkWell(
      onTap: onTap ?? () => _showStaffDetails(context),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: staff.isHead
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white,
                    const Color(0xFFFF9800).withValues(alpha: 0.03),
                  ],
                )
              : null,
          color: staff.isHead ? null : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: staff.isHead
                ? const Color(0xFFFF9800).withValues(alpha: 0.2)
                : Colors.grey.withValues(alpha: 0.1),
            width: 1,
          ),
          boxShadow: staff.isHead
              ? [
                  BoxShadow(
                    color: const Color(0xFFFF9800).withValues(alpha: 0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
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
                child: staff.hinhAnh != null && staff.hinhAnh!.isNotEmpty
                    ? Image.memory(
                        base64Decode(
                          staff.hinhAnh!.contains(',')
                              ? staff.hinhAnh!.split(',').last
                              : staff.hinhAnh!,
                        ),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: Text(
                              initials,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: avatarColor,
                              ),
                            ),
                          );
                        },
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
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (staff.isHead) ...[
                        const SizedBox(width: 6),
                        _buildHeadBadge(),
                      ],
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    staff.chucVu,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (staff.soDienThoai != null) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.phone,
                          size: 11,
                          color: Colors.grey[500],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          staff.soDienThoai!,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.chevron_right,
              color: Colors.grey[400],
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeadBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFFF9800).withValues(alpha: 0.2),
            const Color(0xFFFF9800).withValues(alpha: 0.15),
          ],
        ),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: const Color(0xFFFF9800).withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.star_rounded,
            size: 10,
            color: Color(0xFFFF9800),
          ),
          const SizedBox(width: 3),
          const Text(
            'Trưởng',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: Color(0xFFFF9800),
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }

  void _showStaffDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) => _StaffDetailSheet(
        staff: staff,
        departmentColor: departmentColor ?? const Color(0xFF2196F3),
      ),
    );
  }
}

class _StaffDetailSheet extends StatelessWidget {
  final NhansuModel staff;
  final Color departmentColor;

  const _StaffDetailSheet({
    required this.staff,
    required this.departmentColor,
  });

  String _buildInitials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    final first = parts.first.substring(0, 1);
    final last = parts.last.substring(0, 1);
    return (first + last).toUpperCase();
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    final initials = _buildInitials(staff.hoVaTen);
    final avatarColor = staff.isHead ? const Color(0xFFFF9800) : departmentColor;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 5,
              margin: const EdgeInsets.only(top: 8),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2.5),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: avatarColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(18),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: staff.hinhAnh != null && staff.hinhAnh!.isNotEmpty
                    ? Image.memory(
                        base64Decode(
                          staff.hinhAnh!.contains(',')
                              ? staff.hinhAnh!.split(',').last
                              : staff.hinhAnh!,
                        ),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: Text(
                              initials,
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w700,
                                color: avatarColor,
                              ),
                            ),
                          );
                        },
                      )
                    : Center(
                        child: Text(
                          initials,
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                            color: avatarColor,
                          ),
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 14),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                staff.hoVaTen,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: departmentColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                staff.chucVu,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: departmentColor,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildInfoRow(
                    icon: Icons.badge,
                    label: 'Mã NV',
                    value: staff.maSo,
                  ),
                  _buildDivider(),
                  _buildInfoRow(
                    icon: Icons.business,
                    label: 'Khoa/Phòng',
                    value: staff.khoaPhongTen,
                  ),
                  if (staff.soDienThoai != null) ...[
                    _buildDivider(),
                    _buildInfoRow(
                      icon: Icons.phone,
                      label: 'Điện thoại',
                      value: staff.soDienThoai!,
                    ),
                  ],
                  if (staff.namSinh != null) ...[
                    _buildDivider(),
                    _buildInfoRow(
                      icon: Icons.cake,
                      label: 'Năm sinh',
                      value: _formatDate(staff.namSinh!),
                    ),
                  ],
                  if (staff.gioiTinh != null) ...[
                    _buildDivider(),
                    _buildInfoRow(
                      icon: Icons.person,
                      label: 'Giới tính',
                      value: staff.gioiTinh!,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4CAF50),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.phone, size: 18),
                      label: const Text(
                        'Gọi điện',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2196F3),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.chat_bubble, size: 18),
                      label: const Text(
                        'Zalo',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: Colors.grey[600],
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      indent: 44,
      color: Colors.grey[300],
    );
  }
}
