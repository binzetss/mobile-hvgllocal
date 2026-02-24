import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../providers/nhansu_provider.dart';
import '../../widgets/nhansu/nhansu_card.dart';
import '../../widgets/common/common_search_bar.dart';

class NhansuPage extends StatefulWidget {
  const NhansuPage({super.key});

  @override
  State<NhansuPage> createState() => _NhansuPageState();
}

class _NhansuPageState extends State<NhansuPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NhansuProvider>(
      builder: (context, provider, child) {
        final staffList = provider.filteredStaff;

        return Container(
          color: Colors.grey[50],
          child: RefreshIndicator(
            onRefresh: () async {
              await provider.refresh();
            },
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: _buildStatsSection(provider),
                ),
                if (provider.isLoading)
                  const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (staffList.isEmpty)
                  SliverFillRemaining(
                    child: _buildEmptyState(provider.searchQuery.isNotEmpty),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final staff = staffList[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: NhansuCard(
                              staff: staff,
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
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatsSection(NhansuProvider provider) {
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
                  icon: FontAwesomeIcons.userGroup,
                  value: '${provider.totalStaff}',
                  label: 'Nhân viên',
                  color: const Color(0xFF2196F3),
                  index: 0,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
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
            Colors.white,
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
          FaIcon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
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

  Widget _buildEmptyState(bool isSearching) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              shape: BoxShape.circle,
            ),
            child: FaIcon(
              isSearching
                  ? FontAwesomeIcons.magnifyingGlass
                  : FontAwesomeIcons.userGroup,
              size: 32,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            isSearching ? 'Không tìm thấy kết quả' : 'Chưa có nhân viên nào',
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            isSearching
                ? 'Thử tìm kiếm với từ khóa khác'
                : 'Danh sách nhân viên sẽ hiển thị tại đây',
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
