import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/common/common_app_bar.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/xemdanhgia_model.dart';
import '../../data/services/xemdanhgia_service.dart';
import '../../providers/xacthuc_provider.dart';
import '../../widgets/xemdanhgia/xemdanhgia_summary_card.dart';
import '../../widgets/xemdanhgia/xemdanhgia_filter_bar.dart';
import '../../widgets/xemdanhgia/xemdanhgia_card.dart';

class XemDanhGiaPage extends StatefulWidget {
  const XemDanhGiaPage({super.key});

  @override
  State<XemDanhGiaPage> createState() => _XemDanhGiaPageState();
}

class _XemDanhGiaPageState extends State<XemDanhGiaPage> {
  late Future<List<XemDanhGiaModel>> _future;
  String _selectedCategory = 'Tất cả';

  @override
  void initState() {
    super.initState();
    _future = XemDanhGiaService().getDanhGia();
  }

  List<XemDanhGiaModel> _filtered(List<XemDanhGiaModel> all) {
    if (_selectedCategory == 'Tất cả') return all;
    return all.where((e) => e.danhMuc == _selectedCategory).toList();
  }

  static const _allowedIds = {
    '00008', '00055', '00949', '00571', '00130', '00873',
  };

  @override
  Widget build(BuildContext context) {
    final userMaSo =
        context.read<XacthucProvider>().user?.maSo ?? '';
    final canSeeReviewer = _allowedIds.contains(userMaSo);

    return Scaffold(
      appBar: const CommonAppBar(title: 'Xem Đánh Giá'),
      body: FutureBuilder<List<XemDanhGiaModel>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Chưa có đánh giá nào.'));
          }
          final all = snapshot.data!;
          final filtered = _filtered(all);

          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: XemDanhGiaSummaryCard(list: all),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: XemDanhGiaFilterBar(
                    allItems: all,
                    selectedCategory: _selectedCategory,
                    onSelected: (cat) =>
                        setState(() => _selectedCategory = cat),
                  ),
                ),
              ),
              filtered.isEmpty
                  ? const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(40),
                        child: Center(
                          child: Text(
                            'Không có góp ý nào trong danh mục này.',
                            style: TextStyle(color: AppColors.textSecondary),
                          ),
                        ),
                      ),
                    )
                  : SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => XemDanhGiaCard(
                            item: filtered[index],
                            canSeeReviewer: canSeeReviewer,
                          ),
                          childCount: filtered.length,
                        ),
                      ),
                    ),
            ],
          );
        },
      ),
    );
  }
}
