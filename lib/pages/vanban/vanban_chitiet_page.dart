import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/vanban_model.dart';
import '../../providers/vanban_chitiet_provider.dart';
import '../../widgets/common/common_app_bar.dart';
import '../../widgets/vanban_chitiet/vanban_header_card.dart';
import '../../widgets/vanban_chitiet/the_thongtin.dart';
import '../../widgets/vanban_chitiet/nut_hanhdong.dart';
import 'vanban_chitiet_hanhdong.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class VanbanChitietPage extends StatelessWidget {
  final VanbanModel document;

  const VanbanChitietPage({super.key, required this.document});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => VanbanChitietProvider(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: const CommonAppBar(title: 'Chi Tiết Văn Bản'),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              VanbanHeaderCard(document: document),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          size: 16,
                          color: AppColors.textSecondary.withValues(alpha: 0.8),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          VanbanChitietActions.formatDate(document.uploadedAt),
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary.withValues(alpha: 0.9),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Icon(
                          Icons.tag_rounded,
                          size: 16,
                          color: AppColors.textSecondary.withValues(alpha: 0.8),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'ID: ${document.fileId}',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary.withValues(alpha: 0.9),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    if (document.soKiHieu.isNotEmpty) ...[
                      InfoCard(
                        icon: FontAwesomeIcons.fileSignature,
                        label: 'Số ký hiệu',
                        value: document.soKiHieu,
                      ),
                      const SizedBox(height: 12),
                    ],
                    InfoCard(
                      icon: FontAwesomeIcons.folderOpen,
                      label: 'Danh mục',
                      value: document.categoryName,
                    ),
                    const SizedBox(height: 24),
                    Consumer<VanbanChitietProvider>(
                      builder: (context, provider, child) {
                        return ActionButtons(
                          onOpenPdf: () =>
                              VanbanChitietActions.handleOpenPdf(context, document),
                          onDownloadPdf: () =>
                              VanbanChitietActions.handleDownloadPdf(context, document),
                          isLoadingView: provider.isLoadingView,
                          isLoadingDownload: provider.isLoadingDownload,
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
