import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/daotao_provider.dart';
import '../../data/models/daotao_model.dart';
import '../../widgets/common/common_app_bar.dart';
import '../../widgets/common/common_search_bar.dart';
import '../../widgets/daotao/daotao_header_stats.dart';
import '../../widgets/daotao/daotao_loc_trangthai.dart';
import '../../widgets/daotao/daotao_ketqua_boloc.dart';
import '../../widgets/daotao/daotao_danh_sach.dart';
import 'daotao_chitiet_page.dart';

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
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: const CommonAppBar(title: 'Đào Tạo'),
      body: Consumer<DaotaoProvider>(
        builder: (context, provider, _) {
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
            
              DaotaoDanhSach(
                onItemTap: _navigateToDetail,
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: 20),
              ),
            ],
          );
        },
      ),
    );
  }

  void _navigateToDetail(DaotaoModel lopDaoTao) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DaotaoChitietPage(lopDaoTao: lopDaoTao),
      ),
    );
  }
}
