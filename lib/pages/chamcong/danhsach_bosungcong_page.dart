import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/bosung_chamcong_provider.dart';
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
    return Scaffold(
      backgroundColor: AppColors.background,
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
