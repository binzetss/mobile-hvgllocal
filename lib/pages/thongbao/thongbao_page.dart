import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/thongbao_provider.dart';
import '../../widgets/common/common_app_bar.dart';
import '../../widgets/thongbao/thongbao_filter_chips.dart';
import '../../widgets/thongbao/thongbao_item.dart';
import '../../widgets/thongbao/thongbao_empty.dart';
import '../../widgets/thongbao/thongbao_detail_modal.dart';

class ThongBaoPage extends StatefulWidget {
  const ThongBaoPage({super.key});

  @override
  State<ThongBaoPage> createState() => _ThongBaoPageState();
}

class _ThongBaoPageState extends State<ThongBaoPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<ThongBaoProvider>();
      if (!provider.isInitialized) {
        provider.init();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const _ThongBaoContent();
  }
}

class _ThongBaoContent extends StatelessWidget {
  const _ThongBaoContent();

  @override
  Widget build(BuildContext context) {
    return Consumer<ThongBaoProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: CommonAppBar(
            title: 'Thông báo',
            actions: provider.unreadCount > 0
                ? [
                    IconButton(
                      onPressed: () => provider.markAllAsRead(),
                      icon: const FaIcon(
                        FontAwesomeIcons.checkDouble,
                        size: 18,
                        color: Colors.white,
                      ),
                      tooltip: 'Đọc tất cả',
                    ),
                  ]
                : null,
          ),
          body: Column(
            children: [
              const SizedBox(height: 16),
              ThongBaoFilterChips(
                currentFilter: provider.currentFilter,
                onFilterChanged: provider.setFilter,
                unreadCount: provider.unreadCount,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: _buildContent(context, provider),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, ThongBaoProvider provider) {
    if (provider.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (provider.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Có lỗi xảy ra',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => provider.loadNotifications(),
              child: const Text('Thử lại'),
            ),
          ],
        ),
      );
    }

    final list = provider.notifications;

    if (list.isEmpty) {
      return ThongBaoEmpty(
        message: provider.currentFilter == 'unread'
            ? 'Bạn đã đọc tất cả thông báo'
            : null,
      );
    }

    return RefreshIndicator(
      onRefresh: () => provider.loadNotifications(),
      color: AppColors.primary,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
        itemCount: list.length,
        itemBuilder: (context, index) {
          final thongBao = list[index];
          return ThongBaoItem(
            thongBao: thongBao,
            onTap: () {
              if (!thongBao.isRead) {
                provider.markAsRead(thongBao.id);
              }
              _showDetail(context, thongBao, provider);
            },
            onDismiss: () => provider.deleteNotification(thongBao.id),
          );
        },
      ),
    );
  }

  void _showDetail(BuildContext context, thongBao, ThongBaoProvider provider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => ThongBaoDetailModal(
        thongBao: thongBao,
        provider: provider,
      ),
    );
  }
}
