import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../widgets/common/common_app_bar.dart';
import '../../widgets/lichkham/lichkham_header.dart';
import '../../widgets/lichkham/lichkham_filters.dart';
import '../../widgets/lichkham/lichkham_room_card.dart';
import '../../widgets/lichkham/lichkham_empty_state.dart';
import '../../widgets/lichkham/lichkham_shimmer.dart';
import '../../providers/lichkham_provider.dart';

class LichkhamPage extends StatefulWidget {
  const LichkhamPage({super.key});

  @override
  State<LichkhamPage> createState() => _LichkhamPageState();
}

class _LichkhamPageState extends State<LichkhamPage> {
  @override
  void initState() {
    super.initState();
    // Data đã được preload sau login, chỉ init nếu chưa có data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<LichkhamProvider>();
      if (!provider.isInitialized) {
        provider.init();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: const CommonAppBar(title: 'Lịch khám bệnh'),
      body: Consumer<LichkhamProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const LichkhamShimmer();
          }

          return RefreshIndicator(
            onRefresh: provider.refresh,
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: const LichkhamHeader()
                      .animate()
                      .fadeIn(duration: const Duration(milliseconds: 20))
                      .slideY(
                        begin: -0.1,
                        end: 0,
                        duration: const Duration(milliseconds: 20),
                        curve: Curves.easeOutCubic,
                      ),
                ),
                SliverToBoxAdapter(
                  child: const LichkhamFilters()
                      .animate()
                      .fadeIn(
                        delay: const Duration(milliseconds: 20),
                        duration: const Duration(milliseconds: 20),
                      )
                      .slideY(
                        begin: -0.05,
                        end: 0,
                        delay: const Duration(milliseconds: 20),
                        duration: const Duration(milliseconds: 20),
                        curve: Curves.easeOutCubic,
                      ),
                ),
                _buildScheduleList(provider),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildScheduleList(LichkhamProvider provider) {
    final grouped = provider.getGroupedSchedules();

    if (grouped.isEmpty) {
      return SliverFillRemaining(child: const LichkhamEmptyState());
    }

    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final room = grouped.keys.elementAt(index);
            final schedules = grouped[room]!;
            return LichkhamRoomCard(
              roomName: room,
              schedules: schedules,
            )
                .animate()
                .fadeIn(
                  delay: Duration(milliseconds: 200 + (50 * index)),
                  duration: const Duration(milliseconds: 400),
                )
                .slideY(
                  begin: 0.05,
                  end: 0,
                  delay: Duration(milliseconds: 200 + (50 * index)),
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOutCubic,
                );
          },
          childCount: grouped.length,
        ),
      ),
    );
  }
}
