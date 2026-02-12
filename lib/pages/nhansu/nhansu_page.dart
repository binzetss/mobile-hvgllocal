import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../providers/nhansu_provider.dart';
import '../../widgets/nhansu/phongban_section.dart';
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
      builder: (context, staffProvider, child) {
        return Container(
          color: Colors.grey[50],
          child: RefreshIndicator(
            onRefresh: () async {
              await Future.delayed(const Duration(milliseconds: 500));
            },
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: _buildStatsSection(staffProvider),
                ),
                if (staffProvider.isLoading)
                  const SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                else if (staffProvider.filteredDepartments.isEmpty)
                  SliverFillRemaining(
                    child: _buildEmptyState(),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final dept = staffProvider.filteredDepartments[index];
                          
                          return PhongbanSection(
                            department: dept,
                         
                            index: index,
                          )
                              .animate()
                              .fadeIn(
                                delay: Duration(milliseconds: 50 * index),
                                duration: const Duration(milliseconds: 20),
                              )
                              .slideY(
                                begin: 0.05,
                                end: 0,
                                delay: Duration(milliseconds: 50 * index),
                                duration: const Duration(milliseconds: 20),
                                curve: Curves.easeOutCubic,
                              );
                        },
                        childCount: staffProvider.filteredDepartments.length,
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

  Widget _buildStatsSection(NhansuProvider staffProvider) {
    return Column(
      children: [
        CommonSearchBar(
          controller: _searchController,
          hintText: 'Tìm theo tên, chức vụ, mã NV...',
          searchQuery: staffProvider.searchQuery,
          onChanged: (value) {
            staffProvider.setSearchQuery(value);
            setState(() {});
          },
          onClear: () {
            staffProvider.setSearchQuery('');
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
                  value: '${staffProvider.totalStaff}',
                  label: 'Nhân viên',
                  color: const Color(0xFF2196F3),
                  index: 0,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  icon: FontAwesomeIcons.hospital,
                  value: '${staffProvider.departments.length}',
                  label: 'Khoa/Phòng',
                  color: const Color(0xFF9C27B0),
                  index: 1,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  icon: FontAwesomeIcons.userTie,
                  value: '${staffProvider.departments.length}',
                  label: 'Lãnh đạo',
                  color: const Color(0xFFFF9800),
                  index: 2,
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
      child: Column(
        children: [
          FaIcon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
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

  Widget _buildEmptyState() {
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
              FontAwesomeIcons.magnifyingGlass,
              size: 32,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Không tìm thấy kết quả',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Thử tìm kiếm với từ khóa khác',
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
