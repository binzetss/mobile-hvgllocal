import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/constants/app_colors.dart';
import '../../core/extensions/theme_extensions.dart';
import '../../data/models/lichtruc_model.dart';
import '../../data/services/nhansu_service.dart';
import '../nhansu/nhansu_card.dart';
const _colorPrimary = AppColors.primary;
String _initials(String name) {
  final parts = name.trim().split(' ');
  if (parts.length >= 2) return parts.last[0].toUpperCase();
  return name.isNotEmpty ? name[0].toUpperCase() : '?';
}

class LichtructDeptSection extends StatefulWidget {
  final String deptName;
  final List<ChamTrucModel> items;
  const LichtructDeptSection({
    super.key,
    required this.deptName,
    required this.items,
  });

  @override
  State<LichtructDeptSection> createState() => _LichtructDeptSectionState();
}

class _LichtructDeptSectionState extends State<LichtructDeptSection> {
  bool _expanded = true;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        GestureDetector(
          onTap: () => setState(() => _expanded = !_expanded),
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 6),
            child: Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: _colorPrimary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: FaIcon(FontAwesomeIcons.hospital,
                        size: 12, color: _colorPrimary),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.deptName,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: context.textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                  decoration: BoxDecoration(
                    color: _colorPrimary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${widget.items.length} người',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: _colorPrimary,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                AnimatedRotation(
                  turns: _expanded ? 0 : -0.25,
                  duration: const Duration(milliseconds: 200),
                  child: FaIcon(
                    FontAwesomeIcons.chevronDown,
                    size: 11,
                    color: context.textSecondary.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Animated body
        AnimatedSize(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeInOut,
          child: _expanded
              ? Container(
                  margin: const EdgeInsets.only(bottom: 4),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: isDark
                            ? Colors.black.withValues(alpha: 0.2)
                            : Colors.black.withValues(alpha: 0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Column(
                      children: List.generate(widget.items.length, (i) {
                        return Column(
                          children: [
                            _DeptShiftItem(s: widget.items[i]),
                            if (i < widget.items.length - 1)
                              Divider(
                                  height: 1,
                                  indent: 66,
                                  color: context.borderColor),
                          ],
                        );
                      }),
                    ),
                  ),
                )
              : const SizedBox(width: double.infinity),
        ),
      ],
    );
  }
}

class _DeptShiftItem extends StatefulWidget {
  final ChamTrucModel s;
  const _DeptShiftItem({required this.s});

  @override
  State<_DeptShiftItem> createState() => _DeptShiftItemState();
}

class _DeptShiftItemState extends State<_DeptShiftItem> {
  bool _loading = false;

  Future<void> _onTap() async {
    if (_loading) return;
    setState(() => _loading = true);
    try {
      final results = await NhansuService().getStaff(maSo: widget.s.maSo);
      if (!mounted) return;
      final staff = results.isNotEmpty ? results.first : null;
      if (staff != null) {
        showNhansuDetailSheet(context, staff);
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.s;
    return InkWell(
      onTap: _onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 11, 14, 11),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Avatar
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _colorPrimary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  _initials(s.hoVaTen),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: _colorPrimary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    s.hoVaTen,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: context.textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  if (s.tenChucDanh.isNotEmpty)
                    Text(
                      s.tenChucDanh,
                      style: TextStyle(
                        fontSize: 12,
                        color: context.textSecondary.withValues(alpha: 0.75),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  if (s.moTa.isNotEmpty)
                    Text(
                      s.moTa,
                      style: TextStyle(
                        fontSize: 11,
                        color: context.textSecondary.withValues(alpha: 0.55),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            // Ký hiệu badge hoặc loading
            if (_loading)
              const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: _colorPrimary,
                ),
              )
            else if (s.kyHieu.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: _colorPrimary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Text(
                  s.kyHieu,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: _colorPrimary,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
