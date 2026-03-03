import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../core/extensions/theme_extensions.dart';
import '../../providers/nhansu_provider.dart';
import '../../widgets/nhansu/nhansu_card.dart';
import '../../widgets/nhansu/phongban_section.dart';
import '../../widgets/common/common_search_bar.dart';
import '../../data/models/nhansu_model.dart';

class NhansuPage extends StatefulWidget {
  const NhansuPage({super.key});

  @override
  State<NhansuPage> createState() => _NhansuPageState();
}

class _NhansuPageState extends State<NhansuPage> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedDeptKey; // web only, null = tất cả

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<NhansuProvider>().setSearchQuery('');
        _searchController.clear();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = kIsWeb && MediaQuery.of(context).size.width >= 768;

    if (isDesktop) {
      return Consumer<NhansuProvider>(
        builder: (context, provider, _) => _buildWebLayout(context, provider),
      );
    }

    return Consumer<NhansuProvider>(
      builder: (context, provider, child) {
        final searchByEmployee = provider.isSearchByEmployee;
        final staffList = provider.filteredStaff;
        final departments = provider.filteredDepartments;
        final isEmpty =
            searchByEmployee ? staffList.isEmpty : departments.isEmpty;

        return Container(
          color: context.bgColor,
          child: RefreshIndicator(
            onRefresh: () async {
              await provider.refresh();
            },
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: _buildStatsSection(context, provider),
                ),
                if (provider.isLoading)
                  const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (isEmpty)
                  SliverFillRemaining(
                    child: _buildEmptyState(
                        context, provider.searchQuery.isNotEmpty),
                  )
                else if (searchByEmployee)
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: NhansuCard(
                              staff: staffList[index],
                              index: index,
                            )
                                .animate()
                                .fadeIn(
                                  delay: Duration(milliseconds: 20 * index),
                                  duration: const Duration(milliseconds: 200),
                                )
                                .slideY(
                                  begin: 0.05,
                                  end: 0,
                                  delay: Duration(milliseconds: 20 * index),
                                  duration: const Duration(milliseconds: 200),
                                  curve: Curves.easeOutCubic,
                                ),
                          );
                        },
                        childCount: staffList.length,
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final dept = departments[index];
                          final deptStaff =
                              provider.getFilteredStaffByDepartment(
                                  dept.tenKhoa);
                          return PhongbanSection(
                            department: dept,
                            staffList: deptStaff,
                            index: index,
                          )
                              .animate()
                              .fadeIn(
                                delay: Duration(milliseconds: 40 * index),
                                duration: const Duration(milliseconds: 250),
                              )
                              .slideY(
                                begin: 0.05,
                                end: 0,
                                delay: Duration(milliseconds: 40 * index),
                                duration: const Duration(milliseconds: 250),
                                curve: Curves.easeOutCubic,
                              );
                        },
                        childCount: departments.length,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ── Web layout ──────────────────────────────────────────────────────────────

  Widget _buildWebLayout(BuildContext context, NhansuProvider provider) {
    final List<NhansuModel> staffToShow;
    final String panelTitle;
    final String? activeDept =
        provider.searchQuery.isNotEmpty ? null : _selectedDeptKey;

    if (provider.searchQuery.isNotEmpty) {
      staffToShow = provider.filteredStaff;
      panelTitle = 'Kết quả tìm kiếm';
    } else if (_selectedDeptKey != null) {
      staffToShow = provider.staffByDepartment[_selectedDeptKey!] ?? [];
      panelTitle = _selectedDeptKey!;
    } else {
      staffToShow = provider.allStaff;
      panelTitle = 'Tất cả nhân viên';
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _WebDeptSidebar(
            provider: provider,
            searchController: _searchController,
            selectedDeptKey: activeDept,
            onDeptSelected: (key) {
              provider.setSearchQuery('');
              _searchController.clear();
              setState(() => _selectedDeptKey = key);
            },
            onSearchChanged: (q) {
              provider.setSearchQuery(q);
              setState(() => _selectedDeptKey = null);
            },
            onClearSearch: () {
              provider.setSearchQuery('');
              _searchController.clear();
              setState(() {});
            },
          ),
          Expanded(
            child: _WebStaffPanel(
              staffList: staffToShow,
              title: panelTitle,
              isLoading: provider.isLoading,
            ),
          ),
        ],
      ),
    );
  }

  // ── Mobile helpers ──────────────────────────────────────────────────────────

  Widget _buildStatsSection(BuildContext context, NhansuProvider provider) {
    return Column(
      children: [
        CommonSearchBar(
          controller: _searchController,
          hintText: 'Tìm theo tên, chức vụ, mã NV...',
          searchQuery: provider.searchQuery,
          onChanged: (value) {
            provider.setSearchQuery(value);
            setState(() {});
          },
          onClear: () {
            provider.setSearchQuery('');
            setState(() {});
          },
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  context: context,
                  icon: FontAwesomeIcons.userGroup,
                  value: '${provider.totalStaff}',
                  label: 'Nhân viên',
                  color: const Color(0xFF2196F3),
                  index: 0,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildStatCard(
                  context: context,
                  icon: FontAwesomeIcons.buildingUser,
                  value: '${provider.departments.length}',
                  label: 'Khoa / Phòng',
                  color: const Color(0xFF4CAF50),
                  index: 1,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required BuildContext context,
    required IconData icon,
    required String value,
    required String label,
    required Color color,
    required int index,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            context.cardColor,
            color.withValues(alpha: 0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.15),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FaIcon(icon, color: color, size: 18),
          const SizedBox(width: 10),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: context.textSecondary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(
          delay: Duration(milliseconds: 100 + (index * 60)),
          duration: const Duration(milliseconds: 350),
        )
        .scale(
          begin: const Offset(0.95, 0.95),
          end: const Offset(1, 1),
          delay: Duration(milliseconds: 100 + (index * 60)),
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOutCubic,
        );
  }

  Widget _buildEmptyState(BuildContext context, bool isSearching) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: context.surfaceColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: FaIcon(
                isSearching
                    ? FontAwesomeIcons.magnifyingGlass
                    : FontAwesomeIcons.userGroup,
                size: 32,
                color: context.textSecondary,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            isSearching ? 'Không tìm thấy kết quả' : 'Chưa có nhân viên nào',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: context.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            isSearching
                ? 'Thử tìm kiếm với từ khóa khác'
                : 'Danh sách nhân viên sẽ hiển thị tại đây',
            style: TextStyle(
              fontSize: 15,
              color: context.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Web helpers ────────────────────────────────────────────────────────────────

class _WebDeptSidebar extends StatelessWidget {
  final NhansuProvider provider;
  final TextEditingController searchController;
  final String? selectedDeptKey;
  final ValueChanged<String?> onDeptSelected;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onClearSearch;

  const _WebDeptSidebar({
    required this.provider,
    required this.searchController,
    required this.selectedDeptKey,
    required this.onDeptSelected,
    required this.onSearchChanged,
    required this.onClearSearch,
  });

  static Color _deptColor(String name) {
    final n = name.toLowerCase();
    if (n.contains('nội tim')) return const Color(0xFF2196F3);
    if (n.contains('nội')) return const Color(0xFF2196F3);
    if (n.contains('ngoại')) return const Color(0xFF9C27B0);
    if (n.contains('sản')) return const Color(0xFFE91E63);
    if (n.contains('nhi')) return const Color(0xFFFF9800);
    if (n.contains('cấp cứu') || n.contains('hstc')) return const Color(0xFFF44336);
    if (n.contains('xét nghiệm')) return const Color(0xFF4CAF50);
    if (n.contains('hình ảnh') || n.contains('chẩn đoán')) return const Color(0xFF00BCD4);
    if (n.contains('dược')) return const Color(0xFF673AB7);
    if (n.contains('hành chính') || n.contains('quản trị')) return const Color(0xFF757575);
    if (n.contains('tài chính') || n.contains('kế toán')) return const Color(0xFF009688);
    if (n.contains('công nghệ') || n.contains('cntt')) return const Color(0xFF1877F2);
    if (n.contains('ban giám đốc')) return const Color(0xFF9333EA);
    if (n.contains('điều dưỡng')) return const Color(0xFF06B6D4);
    if (n.contains('đào tạo')) return const Color(0xFFF59E0B);
    if (n.contains('phẫu thuật') || n.contains('gây mê')) return const Color(0xFF8B5CF6);
    if (n.contains('phục hồi') || n.contains('y học cổ')) return const Color(0xFF10B981);
    if (n.contains('khám bệnh')) return const Color(0xFF3B82F6);
    if (n.contains('bảo hiểm')) return const Color(0xFF64748B);
    if (n.contains('dinh dưỡng')) return const Color(0xFF84CC16);
    return const Color(0xFF2196F3);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    return Container(
      width: 264,
      decoration: BoxDecoration(
        color: context.cardColor.withValues(alpha: isDark ? 0.7 : 1.0),
        border: Border(
          right: BorderSide(
            color: context.borderColor.withValues(alpha: isDark ? 1.0 : 0.5),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1877F2).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: const FaIcon(FontAwesomeIcons.hospitalUser,
                          size: 14, color: Color(0xFF1877F2)),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Khoa / Phòng',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: context.textPrimary,
                                  letterSpacing: -0.3)),
                          Text('${provider.departments.length} đơn vị',
                              style: TextStyle(
                                  fontSize: 11, color: context.textSecondary)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                // ── Search ──
                Container(
                  height: 36,
                  decoration: BoxDecoration(
                    color: context.surfaceColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: context.borderColor.withValues(alpha: 0.6)),
                  ),
                  child: TextField(
                    controller: searchController,
                    onChanged: onSearchChanged,
                    style: TextStyle(fontSize: 13, color: context.textPrimary),
                    decoration: InputDecoration(
                      hintText: 'Tìm nhân viên...',
                      hintStyle: TextStyle(
                          fontSize: 13, color: context.textSecondary),
                      prefixIcon: Icon(Icons.search_rounded,
                          size: 16, color: context.textSecondary),
                      suffixIcon: searchController.text.isNotEmpty
                          ? GestureDetector(
                              onTap: onClearSearch,
                              child: Icon(Icons.clear_rounded,
                                  size: 14, color: context.textSecondary),
                            )
                          : null,
                      contentPadding: EdgeInsets.zero,
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // ── Stats chips ──
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Row(
              children: [
                _SidebarStatChip(
                  icon: FontAwesomeIcons.userGroup,
                  value: '${provider.totalStaff}',
                  label: 'Nhân viên',
                  color: const Color(0xFF2196F3),
                ),
                const SizedBox(width: 8),
                _SidebarStatChip(
                  icon: FontAwesomeIcons.buildingUser,
                  value: '${provider.departments.length}',
                  label: 'Khoa/Phòng',
                  color: const Color(0xFF4CAF50),
                ),
              ],
            ),
          ),
          Divider(
              height: 1,
              thickness: 1,
              color: context.borderColor.withValues(alpha: 0.5)),
          // ── "Tất cả" option ──
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
            child: _buildDeptTile(
              context: context,
              icon: FontAwesomeIcons.userGroup,
              name: 'Tất cả nhân viên',
              count: provider.totalStaff,
              color: const Color(0xFF1877F2),
              isSelected: selectedDeptKey == null,
              onTap: () => onDeptSelected(null),
            ),
          ),
          Divider(
              height: 1,
              indent: 12,
              endIndent: 12,
              color: context.borderColor.withValues(alpha: 0.35)),
          // ── Department list ──
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 16),
              itemCount: provider.filteredDepartments.length,
              itemBuilder: (context, index) {
                final dept = provider.filteredDepartments[index];
                final count =
                    (provider.staffByDepartment[dept.tenKhoa] ?? []).length;
                final color = _deptColor(dept.tenKhoa);
                return _buildDeptTile(
                  context: context,
                  icon: FontAwesomeIcons.hospital,
                  name: dept.tenKhoa,
                  count: count,
                  color: color,
                  isSelected: selectedDeptKey == dept.tenKhoa,
                  onTap: () => onDeptSelected(dept.tenKhoa),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeptTile({
    required BuildContext context,
    required IconData icon,
    required String name,
    required int count,
    required Color color,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: isSelected ? color.withValues(alpha: 0.1) : Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: isSelected
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border:
                      Border.all(color: color.withValues(alpha: 0.3), width: 1),
                )
              : null,
          child: Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: isSelected ? 0.2 : 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(child: FaIcon(icon, size: 12, color: color)),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  name,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? color : context.textPrimary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 4),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: isSelected
                      ? color.withValues(alpha: 0.15)
                      : context.surfaceColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$count',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: isSelected ? color : context.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SidebarStatChip extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _SidebarStatChip({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            FaIcon(icon, size: 12, color: color),
            const SizedBox(width: 6),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(value,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: color,
                          letterSpacing: -0.3)),
                  Text(label,
                      style: TextStyle(
                          fontSize: 10,
                          color: context.textSecondary,
                          fontWeight: FontWeight.w500),
                      overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WebStaffPanel extends StatelessWidget {
  final List<NhansuModel> staffList;
  final String title;
  final bool isLoading;

  const _WebStaffPanel({
    required this.staffList,
    required this.title,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Header ──
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: context.textPrimary,
                    letterSpacing: -0.4,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (!isLoading)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1877F2).withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${staffList.length} người',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1877F2),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        // ── Content ──
        Expanded(
          child: isLoading
              ? _buildLoading(context)
              : staffList.isEmpty
                  ? _buildEmpty(context)
                  : _buildGrid(context),
        ),
      ],
    );
  }

  Widget _buildGrid(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cols = constraints.maxWidth > 1100
            ? 4
            : constraints.maxWidth > 800
                ? 3
                : 2;
        return GridView.builder(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: cols,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            mainAxisExtent: 120,
          ),
          itemCount: staffList.length,
          itemBuilder: (context, index) {
            return NhansuCard(
              staff: staffList[index],
              index: index,
            );
          },
        );
      },
    );
  }

  Widget _buildLoading(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cols = constraints.maxWidth > 1100
            ? 4
            : constraints.maxWidth > 800
                ? 3
                : 2;
        return GridView.builder(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: cols,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            mainAxisExtent: 120,
          ),
          itemCount: 12,
          itemBuilder: (context, _) => Container(
            decoration: BoxDecoration(
              color: context.surfaceColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: context.borderColor.withValues(alpha: 0.5)),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: context.surfaceColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: FaIcon(
                FontAwesomeIcons.userSlash,
                size: 26,
                color: context.textSecondary,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text('Không có nhân viên',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: context.textPrimary)),
          const SizedBox(height: 6),
          Text('Khoa/phòng này chưa có nhân viên nào',
              style: TextStyle(fontSize: 13, color: context.textSecondary)),
        ],
      ),
    );
  }
}
