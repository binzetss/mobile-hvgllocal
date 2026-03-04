import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/extensions/theme_extensions.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/bosung_chamcong_provider.dart';
import '../../providers/navigation_provider.dart';
import '../../data/models/bosung_chamcong_model.dart';
import '../../widgets/common/shimmer_loading.dart';
import '../../widgets/common/common_app_bar.dart';
import '../../widgets/bosungcong/bosungcong_list_item.dart';
import '../../widgets/bosungcong/bosungcong_empty_state.dart';

class DanhsachBosungcongPage extends StatefulWidget {
  const DanhsachBosungcongPage({super.key});

  @override
  State<DanhsachBosungcongPage> createState() => _DanhsachBosungcongPageState();
}

class _DanhsachBosungcongPageState extends State<DanhsachBosungcongPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BosungChamcongProvider>().init();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = kIsWeb && MediaQuery.of(context).size.width >= 768;
    if (isDesktop) return _buildWebLayout();
    return _buildMobileLayout();
  }

  Widget _buildMobileLayout() {
    return Scaffold(
      backgroundColor: context.bgColor,
      appBar: const CommonAppBar(title: 'Danh Sách Bổ Sung Công'),
      body: Consumer<BosungChamcongProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return _buildLoading();
          }

          if (provider.supplementaryList.isEmpty) {
            return const BosungcongEmptyState();
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: provider.supplementaryList.length,
            itemBuilder: (context, index) {
              final item = provider.supplementaryList[index];
              return BosungcongListItem(
                stt: index + 1,
                item: item,
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildWebLayout() {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [

          _DanhsachBreadcrumb(
            onBack: () => context.read<NavigationProvider>().setIndex(3),
          ),

          Expanded(
            child: Consumer<BosungChamcongProvider>(
              builder: (context, provider, _) {
                if (provider.isLoading) {
                  return _buildWebLoading();
                }
                return SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(28, 24, 28, 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      _WebStatsRow(list: provider.supplementaryList),
                      const SizedBox(height: 24),

                      if (provider.supplementaryList.isEmpty)
                        const BosungcongEmptyState()
                      else
                        _WebListCard(list: provider.supplementaryList),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWebLoading() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 24, 28, 0),
      child: Column(
        children: List.generate(
          4,
          (i) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            child: const ShimmerLoading(
                width: double.infinity, height: 80, borderRadius: 12),
          ),
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: const ShimmerLoading(
            width: double.infinity,
            height: 120,
            borderRadius: 12,
          ),
        );
      },
    );
  }
}

class _DanhsachBreadcrumb extends StatelessWidget {
  final VoidCallback onBack;
  const _DanhsachBreadcrumb({required this.onBack});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
      decoration: BoxDecoration(
        color: context.cardColor.withValues(alpha: isDark ? 0.6 : 0.85),
        border: Border(
          bottom:
              BorderSide(color: context.borderColor.withValues(alpha: 0.4)),
        ),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: onBack,
            borderRadius: BorderRadius.circular(6),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.arrow_back_ios_rounded,
                      size: 13, color: context.primaryColor),
                  const SizedBox(width: 4),
                  Text('Chấm công',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: context.primaryColor)),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Icon(Icons.chevron_right_rounded,
                size: 16, color: context.textSecondary),
          ),
          Text('Danh Sách Bổ Sung Công',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: context.textSecondary)),
        ],
      ),
    );
  }
}

class _WebStatsRow extends StatelessWidget {
  final List<BosungChamcongModel> list;
  const _WebStatsRow({required this.list});

  @override
  Widget build(BuildContext context) {
    final total = list.length;
    final pending = list.where((x) => x.trangThai == BosungStatus.pending).length;
    final approved = list.where((x) => x.trangThai == BosungStatus.approved).length;
    final rejected = list.where((x) => x.trangThai == BosungStatus.rejected).length;

    return Row(
      children: [
        Expanded(child: _StatChip(label: 'Tổng', value: total, color: context.primaryColor, icon: Icons.assignment_rounded)),
        const SizedBox(width: 12),
        Expanded(child: _StatChip(label: 'Chờ duyệt', value: pending, color: const Color(0xFFF97316), icon: Icons.hourglass_empty_rounded)),
        const SizedBox(width: 12),
        Expanded(child: _StatChip(label: 'Đã duyệt', value: approved, color: const Color(0xFF22C55E), icon: Icons.check_circle_outline_rounded)),
        const SizedBox(width: 12),
        Expanded(child: _StatChip(label: 'Từ chối', value: rejected, color: const Color(0xFFEF4444), icon: Icons.cancel_outlined)),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final int value;
  final Color color;
  final IconData icon;
  const _StatChip({required this.label, required this.value, required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.25), width: 1),
        boxShadow: [
          BoxShadow(
              color: color.withValues(alpha: isDark ? 0.08 : 0.06),
              blurRadius: 8,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('$value',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: context.textPrimary,
                      letterSpacing: -0.5)),
              Text(label,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: context.textSecondary)),
            ],
          ),
        ],
      ),
    );
  }
}

class _WebListCard extends StatelessWidget {
  final List<BosungChamcongModel> list;
  const _WebListCard({required this.list});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    return Container(
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: context.borderColor.withValues(alpha: isDark ? 1.0 : 0.4),
            width: 0.5),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
              blurRadius: 16,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 14),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: FaIcon(FontAwesomeIcons.listCheck,
                      size: 16, color: AppColors.primary),
                ),
                const SizedBox(width: 12),
                Text('Danh sách yêu cầu',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: context.textPrimary,
                        letterSpacing: -0.3)),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text('${list.length} yêu cầu',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: context.primaryColor)),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: context.borderColor.withValues(alpha: 0.5)),

          _TableHeader(),
          Divider(height: 1, color: context.borderColor.withValues(alpha: 0.4)),

          ...list.asMap().entries.map((e) => Column(
                children: [
                  _TableRow(stt: e.key + 1, item: e.value),
                  if (e.key < list.length - 1)
                    Divider(
                        height: 1,
                        color: context.borderColor.withValues(alpha: 0.25),
                        indent: 20,
                        endIndent: 20),
                ],
              )),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _TableHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.surfaceColor.withValues(alpha: 0.6),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          SizedBox(width: 36, child: _HeaderCell('#')),
          Expanded(flex: 3, child: _HeaderCell('Ngày bổ sung')),
          Expanded(flex: 2, child: _HeaderCell('Buổi')),
          Expanded(flex: 2, child: _HeaderCell('Loại')),
          Expanded(flex: 4, child: _HeaderCell('Lý do')),
          Expanded(flex: 2, child: _HeaderCell('Trạng thái', end: true)),
        ],
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  final String text;
  final bool end;
  const _HeaderCell(this.text, {this.end = false});

  @override
  Widget build(BuildContext context) {
    return Text(text,
        textAlign: end ? TextAlign.right : TextAlign.left,
        style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: context.textSecondary,
            letterSpacing: 0.3));
  }
}

class _TableRow extends StatelessWidget {
  final int stt;
  final BosungChamcongModel item;
  const _TableRow({required this.stt, required this.item});

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor();
    final statusText = item.trangThaiText;
    final date = '${item.ngayBoSung.day.toString().padLeft(2, '0')}/'
        '${item.ngayBoSung.month.toString().padLeft(2, '0')}/'
        '${item.ngayBoSung.year}';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          SizedBox(
            width: 36,
            child: Container(
              width: 24,
              height: 24,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [Color(0xFF1877F2), Color(0xFF42A5F5)]),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text('$stt',
                  style: const TextStyle(
                      fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white)),
            ),
          ),
          Expanded(
              flex: 3,
              child: Text(date,
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: context.textPrimary))),
          Expanded(
              flex: 2,
              child: Row(children: [
                Icon(
                  item.buoi == SessionType.morning
                      ? Icons.wb_sunny_rounded
                      : Icons.brightness_3_rounded,
                  size: 13,
                  color: item.buoi == SessionType.morning
                      ? const Color(0xFFF97316)
                      : const Color(0xFF6366F1),
                ),
                const SizedBox(width: 5),
                Text(item.buoiText,
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: context.textPrimary)),
              ])),
          Expanded(
              flex: 2,
              child: Text(item.loai,
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: context.textPrimary))),
          Expanded(
              flex: 4,
              child: Text(item.lyDo,
                  style: TextStyle(
                      fontSize: 13,
                      color: context.textSecondary),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis)),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(statusText,
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: statusColor)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _statusColor() {
    switch (item.trangThai) {
      case BosungStatus.pending:  return const Color(0xFFF97316);
      case BosungStatus.approved: return const Color(0xFF22C55E);
      case BosungStatus.rejected: return const Color(0xFFEF4444);
    }
  }
}
