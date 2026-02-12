import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/vanban_provider.dart';
import '../../data/models/vanban_model.dart';
import '../../core/constants/app_colors.dart';
import '../../widgets/common/common_search_bar.dart';
import '../../widgets/vanban/vanban_loc_danhmuc.dart';
import '../../widgets/vanban/vanban_danh_sach.dart';
import 'vanban_chitiet_page.dart';

class VanbanPage extends StatefulWidget {
  const VanbanPage({super.key});

  @override
  State<VanbanPage> createState() => _VanbanPageState();
}

class _VanbanPageState extends State<VanbanPage> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<VanbanProvider>();
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
      backgroundColor: AppColors.background,
      body: Consumer<VanbanProvider>(
        builder: (context, provider, _) {
          return CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: CommonSearchBar(
                  controller: _searchController,
                  hintText: 'Tìm kiếm văn bản...',
                  searchQuery: provider.searchQuery,
                  onChanged: (value) => provider.searchDocuments(value),
                  onClear: () => provider.clearSearch(),
                ),
              ),
              const SliverToBoxAdapter(
                child: VanbanCategoryFilter(),
              ),
              VanbanDocumentsList(
                onDocumentTap: _navigateToDetail,
              ),
            ],
          );
        },
      ),
    );
  }

  void _navigateToDetail(VanbanModel document) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VanbanChitietPage(document: document),
      ),
    );
  }
}
