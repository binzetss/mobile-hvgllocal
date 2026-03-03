import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../widgets/common/common_app_bar.dart';
import '../../widgets/common/app_dialogs.dart';
import '../../core/constants/app_colors.dart';
import '../../core/extensions/theme_extensions.dart';
import '../../data/models/gopykien_model.dart';
import '../../data/models/xemdanhgia_model.dart';
import '../../data/services/xemdanhgia_service.dart';
import '../../providers/gopykien_provider.dart';
import '../../providers/xacthuc_provider.dart';
import '../../widgets/gopykien/gopykien_header.dart';
import '../../widgets/gopykien/gopykien_form_card.dart';
import '../../widgets/gopykien/gopykien_submit_button.dart';
import '../../widgets/xemdanhgia/xemdanhgia_card.dart';

class GopyKienPage extends StatefulWidget {
  const GopyKienPage({super.key});

  @override
  State<GopyKienPage> createState() => _GopyKienPageState();
}

class _GopyKienPageState extends State<GopyKienPage> {
  static const _allowedIds = {
    '00008', '00055', '00949', '00571', '00130', '00873',
  };

  final _feedbackController = TextEditingController();
  String _selectedCategory = 'Góp ý chung';
  int _webTab = 0;
  String _selectedDanhGiaCategory = 'Tất cả';
  late Future<List<XemDanhGiaModel>> _danhGiaFuture;

  final List<String> _categories = [
    'Góp ý chung',
    'Chức năng app',
    'Giao diện',
    'Hiệu suất',
    'Dịch vụ bệnh viện',
    'Khác',
  ];

  @override
  void initState() {
    super.initState();
    _danhGiaFuture = XemDanhGiaService().getDanhGia();
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = kIsWeb && MediaQuery.of(context).size.width >= 768;
    if (isDesktop) return _buildDesktopLayout();
    return _buildMobileLayout();
  }

  // ── Mobile layout (giữ nguyên) ─────────────────────────────────────────────

  Widget _buildMobileLayout() {
    return Scaffold(
      backgroundColor: context.bgColor,
      appBar: const CommonAppBar(title: 'Góp ý và đánh giá'),
      body: Consumer<GopyKienProvider>(
        builder: (context, provider, _) {
          if (provider.isSuccess) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showSuccessDialog(
                context,
                title: 'Cảm ơn bạn!',
                message:
                    'Góp ý của bạn đã được gửi thành công.\nChúng tôi sẽ xem xét và phản hồi sớm nhất.',
              );
              _feedbackController.clear();
              setState(() => _selectedCategory = 'Góp ý chung');
              provider.reset();
            });
          }

          if (provider.hasError) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showErrorDialog(
                context,
                message: provider.errorMessage ?? 'Gửi góp ý thất bại',
              );
              provider.clearError();
            });
          }

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const GopyKienHeader(),
                  const SizedBox(height: 24),
                  GopyKienFormCard(
                    selectedCategory: _selectedCategory,
                    categories: _categories,
                    onCategoryChanged: (value) {
                      if (value != null) {
                        setState(() => _selectedCategory = value);
                      }
                    },
                    feedbackController: _feedbackController,
                  ),
                  const SizedBox(height: 24),
                  GopyKienSubmitButton(
                    isSubmitting: provider.isSubmitting,
                    onPressed: () => _handleSubmit(provider),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ── Desktop layout ─────────────────────────────────────────────────────────

  Widget _buildDesktopLayout() {
    final userMaSo =
        context.read<XacthucProvider>().user?.maSo ?? '';
    final canSeeReviewer = _allowedIds.contains(userMaSo);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          _WebTopBar(
            tab: _webTab,
            onTabChange: (t) => setState(() => _webTab = t),
            canSeeReviewer: canSeeReviewer,
          ),
          Expanded(
            child: (_webTab == 1 && canSeeReviewer)
                ? _buildWebReviewTab()
                : _buildWebFormTab(),
          ),
        ],
      ),
    );
  }

  // ── Tab 0: Gửi góp ý ──────────────────────────────────────────────────────

  Widget _buildWebFormTab() {
    return Consumer<GopyKienProvider>(
      builder: (context, provider, _) {
        if (provider.isSuccess) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showSuccessDialog(
              context,
              title: 'Cảm ơn bạn!',
              message:
                  'Góp ý của bạn đã được gửi thành công.\nChúng tôi sẽ xem xét và phản hồi sớm nhất.',
            );
            _feedbackController.clear();
            setState(() => _selectedCategory = 'Góp ý chung');
            provider.reset();
          });
        }

        if (provider.hasError) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showErrorDialog(
              context,
              message: provider.errorMessage ?? 'Gửi góp ý thất bại',
            );
            provider.clearError();
          });
        }

        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 920),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Left: motivation panel
                    const Expanded(child: _WebMotivationPanel()),
                    const SizedBox(width: 24),
                    // Right: form + submit
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          GopyKienFormCard(
                            selectedCategory: _selectedCategory,
                            categories: _categories,
                            onCategoryChanged: (value) {
                              if (value != null) {
                                setState(() => _selectedCategory = value);
                              }
                            },
                            feedbackController: _feedbackController,
                          ),
                          const SizedBox(height: 20),
                          GopyKienSubmitButton(
                            isSubmitting: provider.isSubmitting,
                            onPressed: () => _handleSubmit(provider),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ── Tab 1: Xem đánh giá ───────────────────────────────────────────────────

  Widget _buildWebReviewTab() {
    return FutureBuilder<List<XemDanhGiaModel>>(
      future: _danhGiaFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text(
              'Chưa có đánh giá nào.',
              style: TextStyle(color: context.textSecondary),
            ),
          );
        }

        final all = snapshot.data!;
        final filtered = _selectedDanhGiaCategory == 'Tất cả'
            ? all
            : all.where((e) => e.danhMuc == _selectedDanhGiaCategory).toList();

        final categoryCount = <String, int>{};
        for (final e in all) {
          categoryCount[e.danhMuc] = (categoryCount[e.danhMuc] ?? 0) + 1;
        }
        final sortedEntries = categoryCount.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));
        final categories = <(String, int)>[
          ('Tất cả', all.length),
          ...sortedEntries.map((e) => (e.key, e.value)),
        ];

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 224,
              child: _WebReviewSidebar(
                categories: categories,
                selected: _selectedDanhGiaCategory,
                onSelect: (cat) =>
                    setState(() => _selectedDanhGiaCategory = cat),
                all: all,
              ),
            ),
            VerticalDivider(width: 1, color: context.borderColor),
            Expanded(
              child: _WebReviewContent(
                all: all,
                filtered: filtered,
                canSeeReviewer: _allowedIds.contains(
                    context.read<XacthucProvider>().user?.maSo ?? ''),
              ),
            ),
          ],
        );
      },
    );
  }

  void _handleSubmit(GopyKienProvider provider) {
    if (_feedbackController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng nhập nội dung góp ý'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    provider.submitFeedback(
      GopyKienModel(
        name: 'User',
        category: _selectedCategory,
        content: _feedbackController.text.trim(),
      ),
    );
  }
}

// ── Web top bar ────────────────────────────────────────────────────────────────

class _WebTopBar extends StatelessWidget {
  final int tab;
  final ValueChanged<int> onTabChange;
  final bool canSeeReviewer;

  const _WebTopBar({
    required this.tab,
    required this.onTabChange,
    this.canSeeReviewer = false,
  });

  @override
  Widget build(BuildContext context) {
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
              color: const Color(0xFF06B6D4).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
              child: FaIcon(
                FontAwesomeIcons.commentDots,
                size: 16,
                color: Color(0xFF06B6D4),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Góp ý & Đánh giá',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: context.textPrimary,
            ),
          ),
          const SizedBox(width: 32),
          _TabBtn(
            label: 'Gửi góp ý',
            icon: FontAwesomeIcons.paperPlane,
            isSelected: tab == 0,
            onTap: () => onTabChange(0),
          ),
          const SizedBox(width: 4),
          if (canSeeReviewer)
            _TabBtn(
              label: 'Xem đánh giá',
              icon: FontAwesomeIcons.star,
              isSelected: tab == 1,
              onTap: () => onTabChange(1),
            ),
          const Spacer(),
        ],
      ),
    );
  }
}

class _TabBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabBtn({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF06B6D4).withValues(alpha: 0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: isSelected
              ? Border.all(
                  color: const Color(0xFF06B6D4).withValues(alpha: 0.4),
                )
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FaIcon(
              icon,
              size: 13,
              color: isSelected
                  ? const Color(0xFF06B6D4)
                  : context.textSecondary,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight:
                    isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected
                    ? const Color(0xFF06B6D4)
                    : context.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Tab 0: Motivation panel (left column) ─────────────────────────────────────

class _WebMotivationPanel extends StatelessWidget {
  const _WebMotivationPanel();

  static const List<(IconData, String, Color)> _points = [
    (FontAwesomeIcons.lightbulb, 'Đề xuất tính năng mới cho ứng dụng',
        Color(0xFFF59E0B)),
    (FontAwesomeIcons.chartLine, 'Cải thiện giao diện và trải nghiệm người dùng',
        Color(0xFF3B82F6)),
    (FontAwesomeIcons.heart, 'Phản ánh về chất lượng dịch vụ bệnh viện',
        Color(0xFFEF4444)),
    (FontAwesomeIcons.shieldHalved, 'Báo cáo lỗi và sự cố kỹ thuật',
        Color(0xFF10B981)),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF06B6D4), Color(0xFF0891B2)],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF06B6D4).withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Center(
                  child: FaIcon(
                    FontAwesomeIcons.commentDots,
                    size: 24,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Ý kiến của bạn\nrất quan trọng!',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Mỗi góp ý giúp chúng tôi cải thiện ứng dụng và dịch vụ tốt hơn cho toàn bộ nhân viên bệnh viện.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withValues(alpha: 0.85),
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        ..._points.map(
          (p) => _PointRow(icon: p.$1, text: p.$2, color: p.$3),
        ),
      ],
    );
  }
}

class _PointRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const _PointRow({
    required this.icon,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(child: FaIcon(icon, size: 15, color: color)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: context.textPrimary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Tab 1: Review sidebar ──────────────────────────────────────────────────────

class _WebReviewSidebar extends StatelessWidget {
  final List<(String, int)> categories;
  final String selected;
  final ValueChanged<String> onSelect;
  final List<XemDanhGiaModel> all;

  const _WebReviewSidebar({
    required this.categories,
    required this.selected,
    required this.onSelect,
    required this.all,
  });

  @override
  Widget build(BuildContext context) {
    final uniqueCategories = all.map((e) => e.danhMuc).toSet().length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'DANH MỤC',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: context.textSecondary.withValues(alpha: 0.7),
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 8),
          ...categories.map(
            (cat) => _SidebarChip(
              label: cat.$1,
              count: cat.$2,
              isSelected: selected == cat.$1,
              onTap: () => onSelect(cat.$1),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: context.surfaceColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'THỐNG KÊ',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: context.textSecondary.withValues(alpha: 0.7),
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 12),
                _StatRow(
                  icon: FontAwesomeIcons.commentDots,
                  label: 'Tổng góp ý',
                  value: '${all.length}',
                  color: const Color(0xFF06B6D4),
                ),
                const SizedBox(height: 8),
                _StatRow(
                  icon: FontAwesomeIcons.users,
                  label: 'Nhân viên',
                  value: '${all.map((e) => e.maSo).toSet().length}',
                  color: const Color(0xFF3B82F6),
                ),
                const SizedBox(height: 8),
                _StatRow(
                  icon: FontAwesomeIcons.tag,
                  label: 'Danh mục',
                  value: '$uniqueCategories',
                  color: const Color(0xFF10B981),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarChip extends StatelessWidget {
  final String label;
  final int count;
  final bool isSelected;
  final VoidCallback onTap;

  const _SidebarChip({
    required this.label,
    required this.count,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.only(bottom: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF06B6D4).withValues(alpha: 0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(9),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight:
                      isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected
                      ? const Color(0xFF06B6D4)
                      : context.textPrimary,
                ),
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF06B6D4).withValues(alpha: 0.2)
                    : context.surfaceColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '$count',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: isSelected
                      ? const Color(0xFF06B6D4)
                      : context.textSecondary,
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
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(7),
          ),
          child: Center(child: FaIcon(icon, size: 12, color: color)),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style:
                TextStyle(fontSize: 12, color: context.textSecondary),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: context.textPrimary,
          ),
        ),
      ],
    );
  }
}

// ── Tab 1: Review content ──────────────────────────────────────────────────────

class _WebReviewContent extends StatelessWidget {
  final List<XemDanhGiaModel> all;
  final List<XemDanhGiaModel> filtered;
  final bool canSeeReviewer;

  const _WebReviewContent({
    required this.all,
    required this.filtered,
    required this.canSeeReviewer,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _MiniStatCard(
                  icon: FontAwesomeIcons.commentDots,
                  value: '${all.length}',
                  label: 'Tổng góp ý',
                  color: const Color(0xFF06B6D4),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _MiniStatCard(
                  icon: FontAwesomeIcons.users,
                  value: '${all.map((e) => e.maSo).toSet().length}',
                  label: 'Nhân viên',
                  color: const Color(0xFF3B82F6),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _MiniStatCard(
                  icon: FontAwesomeIcons.tag,
                  value: '${all.map((e) => e.danhMuc).toSet().length}',
                  label: 'Danh mục',
                  color: const Color(0xFF10B981),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Text(
                'Danh sách đánh giá',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: context.textPrimary,
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color:
                      const Color(0xFF06B6D4).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${filtered.length}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF06B6D4),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (filtered.isEmpty)
            Padding(
              padding: const EdgeInsets.all(40),
              child: Center(
                child: Text(
                  'Không có góp ý nào trong danh mục này.',
                  style: TextStyle(color: context.textSecondary),
                ),
              ),
            )
          else
            _WebReviewGrid(items: filtered, canSeeReviewer: canSeeReviewer),
        ],
      ),
    );
  }
}

class _MiniStatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _MiniStatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.borderColor),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(child: FaIcon(icon, size: 16, color: color)),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: context.textPrimary,
                  height: 1,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: context.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WebReviewGrid extends StatelessWidget {
  final List<XemDanhGiaModel> items;
  final bool canSeeReviewer;

  const _WebReviewGrid({
    required this.items,
    required this.canSeeReviewer,
  });

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    for (int i = 0; i < items.length; i += 2) {
      rows.add(
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: XemDanhGiaCard(
                item: items[i],
                canSeeReviewer: canSeeReviewer,
              )),
              const SizedBox(width: 14),
              items.length > i + 1
                  ? Expanded(child: XemDanhGiaCard(
                      item: items[i + 1],
                      canSeeReviewer: canSeeReviewer,
                    ))
                  : const Expanded(child: SizedBox()),
            ],
          ),
        ),
      );
    }
    return Column(children: rows);
  }
}
