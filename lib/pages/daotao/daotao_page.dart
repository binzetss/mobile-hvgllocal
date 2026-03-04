import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/extensions/theme_extensions.dart';
import '../../data/models/daotao_model.dart';
import '../../providers/daotao_provider.dart';
import '../../widgets/common/common_app_bar.dart';
import '../../widgets/common/common_search_bar.dart';
import '../../widgets/daotao/daotao_header_stats.dart';
import '../../widgets/daotao/daotao_loc_trangthai.dart';
import '../../widgets/daotao/daotao_ketqua_boloc.dart';
import '../../widgets/daotao/daotao_danh_sach.dart';
import '../../widgets/daotao/daotao_nut_dangky.dart';

class DaotaoPage extends StatefulWidget {
  const DaotaoPage({super.key});

  @override
  State<DaotaoPage> createState() => _DaotaoPageState();
}

class _DaotaoPageState extends State<DaotaoPage> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<DaotaoProvider>();
      if (!provider.isInitialized) {
        provider.init();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = kIsWeb && MediaQuery.of(context).size.width >= 768;
    return Scaffold(
      backgroundColor: isDesktop ? Colors.transparent : context.bgColor,
      appBar: isDesktop ? null : const CommonAppBar(title: 'Đào Tạo'),
      body: Consumer<DaotaoProvider>(
        builder: (context, provider, _) {
          if (isDesktop) {
            return _buildWebLayout(context, provider);
          }
          return _buildMobileLayout(context, provider);
        },
      ),
    );
  }

  Widget _buildMobileLayout(
      BuildContext context, DaotaoProvider provider) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverToBoxAdapter(
          child: DaotaoHeaderStats(provider: provider),
        ),
        SliverToBoxAdapter(
          child: CommonSearchBar(
            controller: _searchController,
            hintText: 'Tìm kiếm khóa học...',
            searchQuery: provider.tuKhoa,
            onChanged: (value) => provider.timKiem(value),
            onClear: () => provider.xoaTimKiem(),
          ),
        ),
        const SliverToBoxAdapter(
          child: DaotaoLocTrangThai(),
        ),
        SliverToBoxAdapter(
          child: DaotaoKetQuaBoLoc(
            provider: provider,
            searchController: _searchController,
          ),
        ),
        const DaotaoDanhSach(),
        const SliverToBoxAdapter(child: SizedBox(height: 20)),
      ],
    );
  }

  Widget _buildWebLayout(
      BuildContext context, DaotaoProvider provider) {
    return Column(
      children: [
        _WebTopBar(
          provider: provider,
          searchController: _searchController,
        ),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 224,
                child: _WebSidebar(provider: provider),
              ),
              VerticalDivider(width: 1, color: context.borderColor),
              Expanded(
                child: _WebContent(provider: provider),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _WebTopBar extends StatelessWidget {
  final DaotaoProvider provider;
  final TextEditingController searchController;

  const _WebTopBar({
    required this.provider,
    required this.searchController,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
        border: Border(
          bottom: BorderSide(color: context.borderColor, width: 1),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const FaIcon(FontAwesomeIcons.graduationCap,
                size: 16, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Text(
            'Đào Tạo',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : const Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(width: 24),

          Expanded(
            child: Container(
              height: 38,
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF2C2C2E)
                    : const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isDark
                      ? const Color(0xFF38383A)
                      : const Color(0xFFE0E0E0),
                ),
              ),
              child: TextField(
                controller: searchController,
                onChanged: (v) => provider.timKiem(v),
                style: TextStyle(
                  fontSize: 13,
                  color:
                      isDark ? Colors.white : const Color(0xFF1A1A1A),
                ),
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm khóa học...',
                  hintStyle: TextStyle(
                    fontSize: 13,
                    color: isDark ? Colors.grey[500] : Colors.grey[500],
                  ),
                  prefixIcon: Padding(
                    padding:
                        const EdgeInsets.only(left: 12, right: 8),
                    child: FaIcon(FontAwesomeIcons.magnifyingGlass,
                        size: 13,
                        color: isDark
                            ? Colors.grey[500]
                            : Colors.grey[500]),
                  ),
                  prefixIconConstraints:
                      const BoxConstraints(minWidth: 0, minHeight: 0),
                  suffixIcon: provider.tuKhoa.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            searchController.clear();
                            provider.xoaTimKiem();
                          },
                          icon: FaIcon(FontAwesomeIcons.xmark,
                              size: 11,
                              color: isDark
                                  ? Colors.grey[500]
                                  : Colors.grey[500]),
                          padding: EdgeInsets.zero,
                          visualDensity: VisualDensity.compact,
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          InkWell(
            onTap: provider.refresh,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  FaIcon(FontAwesomeIcons.arrowsRotate,
                      size: 12, color: AppColors.primary),
                  SizedBox(width: 8),
                  Text(
                    'Làm mới',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WebSidebar extends StatelessWidget {
  final DaotaoProvider provider;
  const _WebSidebar({required this.provider});

  static const List<(String, String, IconData, Color)> _filters = [
    ('all', 'Tất cả', FontAwesomeIcons.layerGroup, AppColors.primary),
    (
      'dangMo',
      'Đang mở',
      FontAwesomeIcons.circleCheck,
      Color(0xFF10B981)
    ),
    ('chuaMo', 'Sắp mở', FontAwesomeIcons.clock, Color(0xFFF59E0B)),
    ('hetHan', 'Đã đóng', FontAwesomeIcons.lock, Color(0xFF9CA3AF)),
  ];

  int _countFor(String filter) {
    switch (filter) {
      case 'dangMo':
        return provider.danhSach.where((l) => l.dangMoDangKy).length;
      case 'chuaMo':
        return provider.danhSach.where((l) => l.chuaMoDangKy).length;
      case 'hetHan':
        return provider.danhSach.where((l) => l.hetHanDangKy).length;
      default:
        return provider.danhSach.length;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final dangKyCount = provider.danhSach
        .where((l) => provider.daDangKy(l.idLopDaoTao))
        .length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SCard(
            isDark: isDark,
            icon: FontAwesomeIcons.filter,
            title: 'TRẠNG THÁI',
            child: Column(
              children: _filters.indexed.map((item) {
                final (i, (value, label, icon, color)) = item;
                final isSelected = provider.locTrangThai == value;
                return Padding(
                  padding: EdgeInsets.only(top: i == 0 ? 0 : 4),
                  child: _StatusBtn(
                    label: label,
                    icon: icon,
                    color: color,
                    count: _countFor(value),
                    isSelected: isSelected,
                    isDark: isDark,
                    onTap: () => context
                        .read<DaotaoProvider>()
                        .locTheoTrangThai(value),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 12),
          _SCard(
            isDark: isDark,
            icon: FontAwesomeIcons.chartBar,
            title: 'THỐNG KÊ',
            child: Column(
              children: [
                _StatRow(
                  label: 'Tổng khóa học',
                  value: '${provider.danhSach.length}',
                  color: AppColors.primary,
                  isDark: isDark,
                ),
                const SizedBox(height: 8),
                _StatRow(
                  label: 'Đang mở đăng ký',
                  value: '${provider.soLopDangMo}',
                  color: const Color(0xFF10B981),
                  isDark: isDark,
                ),
                const SizedBox(height: 8),
                _StatRow(
                  label: 'Đã đăng ký',
                  value: '$dangKyCount',
                  color: const Color(0xFF9C27B0),
                  isDark: isDark,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SCard extends StatelessWidget {
  final bool isDark;
  final IconData icon;
  final String title;
  final Widget child;

  const _SCard({
    required this.isDark,
    required this.icon,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C2C2E) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.2)
                : Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              FaIcon(icon, size: 11, color: AppColors.primary),
              const SizedBox(width: 7),
              Text(
                title,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _StatusBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final int count;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  const _StatusBtn({
    required this.label,
    required this.icon,
    required this.color,
    required this.count,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: double.infinity,
        padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withValues(alpha: 0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? color.withValues(alpha: 0.35)
                : Colors.transparent,
          ),
        ),
        child: Row(
          children: [
            FaIcon(icon,
                size: 12,
                color: isSelected
                    ? color
                    : (isDark
                        ? Colors.grey[500]
                        : Colors.grey[500])),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected
                      ? FontWeight.w600
                      : FontWeight.w400,
                  color: isSelected
                      ? color
                      : (isDark
                          ? Colors.grey[300]
                          : const Color(0xFF1A1A1A)),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected
                    ? color.withValues(alpha: 0.15)
                    : (isDark
                        ? const Color(0xFF38383A)
                        : const Color(0xFFEEEEEE)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$count',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? color
                      : (isDark
                          ? Colors.grey[400]
                          : Colors.grey[600]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final bool isDark;

  const _StatRow({
    required this.label,
    required this.value,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 6,
          height: 6,
          decoration:
              BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _WebContent extends StatelessWidget {
  final DaotaoProvider provider;
  const _WebContent({required this.provider});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(FontAwesomeIcons.triangleExclamation,
                size: 36,
                color: AppColors.error.withValues(alpha: 0.5)),
            const SizedBox(height: 16),
            const Text(
              'Không thể tải dữ liệu',
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: provider.refresh,
              icon: const FaIcon(FontAwesomeIcons.arrowsRotate,
                  size: 13, color: Colors.white),
              label: const Text('Thử lại'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
      );
    }

    final list = provider.danhSach;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            children: [
              _MiniStat(
                icon: FontAwesomeIcons.bookOpen,
                label: 'Tổng khóa học',
                value: '${list.length}',
                color: AppColors.primary,
                isDark: isDark,
              ),
              const SizedBox(width: 12),
              _MiniStat(
                icon: FontAwesomeIcons.circleCheck,
                label: 'Đang mở đăng ký',
                value: '${provider.soLopDangMo}',
                color: const Color(0xFF10B981),
                isDark: isDark,
              ),
              const SizedBox(width: 12),
              _MiniStat(
                icon: FontAwesomeIcons.penToSquare,
                label: 'Khóa mới hôm nay',
                value: '${provider.soLopMoi}',
                color: const Color(0xFFF59E0B),
                isDark: isDark,
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (list.isEmpty)
            _WebEmpty(
                isDark: isDark,
                hasSearch: provider.tuKhoa.isNotEmpty)
          else
            _WebGrid(courses: list, isDark: isDark),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final bool isDark;

  const _MiniStat({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2C2C2E) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.2)
                  : Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: FaIcon(icon, size: 18, color: color),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: isDark
                        ? Colors.white
                        : const Color(0xFF1A1A1A),
                    height: 1,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _WebGrid extends StatelessWidget {
  final List<DaotaoModel> courses;
  final bool isDark;

  const _WebGrid({required this.courses, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    for (int i = 0; i < courses.length; i += 2) {
      rows.add(
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _WebCourseCard(
                    course: courses[i], isDark: isDark),
              ),
              const SizedBox(width: 14),
              courses.length > i + 1
                  ? Expanded(
                      child: _WebCourseCard(
                          course: courses[i + 1], isDark: isDark),
                    )
                  : const Expanded(child: SizedBox()),
            ],
          ),
        ),
      );
      if (i + 2 < courses.length) {
        rows.add(const SizedBox(height: 14));
      }
    }
    return Column(children: rows);
  }
}

class _WebCourseCard extends StatelessWidget {
  final DaotaoModel course;
  final bool isDark;

  const _WebCourseCard(
      {required this.course, required this.isDark});

  Color get _statusColor {
    if (course.dangMoDangKy) return const Color(0xFF10B981);
    if (course.chuaMoDangKy) return const Color(0xFFF59E0B);
    return const Color(0xFF9CA3AF);
  }

  String get _statusLabel {
    if (course.dangMoDangKy) return 'Đang mở đăng ký';
    if (course.chuaMoDangKy) return 'Sắp mở';
    return 'Đã đóng';
  }

  IconData get _statusIcon {
    if (course.dangMoDangKy) return FontAwesomeIcons.circleCheck;
    if (course.chuaMoDangKy) return FontAwesomeIcons.clock;
    return FontAwesomeIcons.lock;
  }

  String _fmt(DateTime d) {
    final now = DateTime.now();
    if (d.year == now.year && d.month == now.month && d.day == now.day) {
      return 'Hôm nay';
    }
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
  }

  String _fmtDt(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year} '
      '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final color = _statusColor;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C2C2E) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.2)
                : Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Container(
            padding: const EdgeInsets.fromLTRB(14, 11, 14, 11),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.06),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
              ),
              border: Border(
                bottom: BorderSide(
                    color: color.withValues(alpha: 0.12), width: 1),
              ),
            ),
            child: Row(
              children: [

                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(7),
                    border: Border.all(
                        color: color.withValues(alpha: 0.25), width: 1),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FaIcon(_statusIcon, size: 10, color: color),
                      const SizedBox(width: 5),
                      Text(
                        _statusLabel,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                ),
                if (course.isNew) ...[
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF6B6B), Color(0xFFEE5A24)],
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Text(
                      'MỚI',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const FaIcon(FontAwesomeIcons.bookOpen,
                          size: 10, color: AppColors.primary),
                      const SizedBox(width: 4),
                      Text(
                        '${course.soTiet.toStringAsFixed(course.soTiet % 1 == 0 ? 0 : 1)} tiết',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course.tenLopDaoTao,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    height: 1.4,
                    color: isDark
                        ? Colors.white
                        : const Color(0xFF1A1A1A),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                _DateInfo(
                  icon: FontAwesomeIcons.calendarDay,
                  label: 'Ngày học',
                  value: _fmt(course.ngayBatDau),
                  color: AppColors.primary,
                  isDark: isDark,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _DateInfo(
                        icon: FontAwesomeIcons.calendarPlus,
                        label: 'Bắt đầu ĐK',
                        value: _fmtDt(course.ngayBatDauDangKy),
                        color: const Color(0xFF10B981),
                        isDark: isDark,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _DateInfo(
                        icon: FontAwesomeIcons.calendarXmark,
                        label: 'Hết hạn ĐK',
                        value: _fmtDt(course.ngayKetThucDangKy),
                        color: const Color(0xFFF59E0B),
                        isDark: isDark,
                      ),
                    ),
                  ],
                ),
                if (course.dangMoDangKy) ...[
                  const SizedBox(height: 12),
                  DaotaoDangKyButton(lopDaoTao: course),
                ] else
                  const SizedBox(height: 4),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DateInfo extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final bool isDark;

  const _DateInfo({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(7),
          ),
          child: Center(
            child: FaIcon(icon, size: 11, color: color),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  color: isDark ? Colors.grey[500] : Colors.grey[500],
                ),
              ),
              const SizedBox(height: 1),
              Text(
                value,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? Colors.white
                      : const Color(0xFF1A1A1A),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _WebEmpty extends StatelessWidget {
  final bool isDark;
  final bool hasSearch;

  const _WebEmpty({required this.isDark, required this.hasSearch});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 64),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C2C2E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.2)
                : Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          FaIcon(
            FontAwesomeIcons.graduationCap,
            size: 40,
            color: AppColors.primary.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            hasSearch
                ? 'Không tìm thấy khóa học'
                : 'Chưa có khóa học nào',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            hasSearch
                ? 'Thử tìm kiếm với từ khóa khác'
                : 'Các khóa học sẽ được hiển thị tại đây',
            style: TextStyle(
              fontSize: 13,
              color: isDark ? Colors.grey[600] : Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }
}
