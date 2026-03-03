import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/extensions/theme_extensions.dart';
import '../../data/models/vanban_model.dart';
import '../../providers/navigation_provider.dart';
import '../../providers/vanban_chitiet_provider.dart';
import '../../widgets/common/common_app_bar.dart';
import '../../widgets/vanban_chitiet/vanban_header_card.dart';
import '../../widgets/vanban_chitiet/the_thongtin.dart';
import '../../widgets/vanban_chitiet/nut_hanhdong.dart';
import 'vanban_chitiet_hanhdong.dart';

class VanbanChitietPage extends StatelessWidget {
  final VanbanModel document;

  const VanbanChitietPage({super.key, required this.document});

  @override
  Widget build(BuildContext context) {
    final isDesktop = kIsWeb && MediaQuery.of(context).size.width >= 768;
    return ChangeNotifierProvider(
      create: (_) => VanbanChitietProvider(),
      child: isDesktop
          ? _WebLayout(document: document)
          : _MobileLayout(document: document),
    );
  }
}

// ── Mobile (existing layout) ──────────────────────────────────────────────────

class _MobileLayout extends StatelessWidget {
  final VanbanModel document;
  const _MobileLayout({required this.document});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                        color: context.textSecondary.withValues(alpha: 0.8),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        VanbanChitietActions.formatDate(document.uploadedAt),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: context.textSecondary.withValues(alpha: 0.9),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(
                        Icons.tag_rounded,
                        size: 16,
                        color: context.textSecondary.withValues(alpha: 0.8),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'ID: ${document.fileId}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: context.textSecondary.withValues(alpha: 0.9),
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
                    builder: (context, provider, _) {
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
    );
  }
}

// ── Web layout ────────────────────────────────────────────────────────────────

class _WebLayout extends StatelessWidget {
  final VanbanModel document;
  const _WebLayout({required this.document});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Breadcrumb bar
          _Breadcrumb(document: document),
          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(28, 20, 28, 28),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left column: header + metadata
                  Expanded(
                    flex: 6,
                    child: Column(
                      children: [
                        VanbanHeaderCard(document: document),
                        const SizedBox(height: 20),
                        _WebMetaCard(document: document),
                        if (document.hasMultipleFiles) ...[
                          const SizedBox(height: 16),
                          _WebFilesCard(document: document),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 24),
                  // Right column: action panel
                  SizedBox(
                    width: 300,
                    child: _WebActionPanel(document: document),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Breadcrumb ────────────────────────────────────────────────────────────────

class _Breadcrumb extends StatelessWidget {
  final VanbanModel document;
  const _Breadcrumb({required this.document});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
      decoration: BoxDecoration(
        color: context.cardColor.withValues(alpha: isDark ? 0.6 : 0.85),
        border: Border(
          bottom: BorderSide(color: context.borderColor.withValues(alpha: 0.4)),
        ),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () => context.read<NavigationProvider>().setIndex(1),
            borderRadius: BorderRadius.circular(6),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.arrow_back_ios_rounded,
                      size: 13, color: context.primaryColor),
                  const SizedBox(width: 4),
                  Text(
                    'Văn bản',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: context.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Icon(Icons.chevron_right_rounded,
                size: 16, color: context.textSecondary),
          ),
          Expanded(
            child: Text(
              document.fileName,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: context.textSecondary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Web Meta Card ─────────────────────────────────────────────────────────────

class _WebMetaCard extends StatelessWidget {
  final VanbanModel document;
  const _WebMetaCard({required this.document});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: context.borderColor.withValues(alpha: isDark ? 1.0 : 0.4),
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: context.primaryColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.info_outline_rounded,
                    size: 16, color: context.primaryColor),
              ),
              const SizedBox(width: 12),
              Text(
                'Thông tin tài liệu',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: context.textPrimary,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _MetaRow(
            icon: Icons.calendar_today_rounded,
            label: 'Ngày đăng',
            value: VanbanChitietActions.formatDate(document.uploadedAt),
          ),
          _divider(context),
          _MetaRow(
            icon: Icons.fingerprint_rounded,
            label: 'Mã tài liệu',
            value: 'ID ${document.fileId}',
          ),
          _divider(context),
          _MetaRow(
            icon: Icons.folder_rounded,
            label: 'Danh mục',
            value: document.categoryName,
          ),
          if (document.soKiHieu.isNotEmpty) ...[
            _divider(context),
            _MetaRow(
              icon: Icons.tag_rounded,
              label: 'Số ký hiệu',
              value: document.soKiHieu,
            ),
          ],
          _divider(context),
          _MetaRow(
            icon: Icons.insert_drive_file_rounded,
            label: 'Loại file',
            value: document.fileExtension.toUpperCase(),
            valueIsChip: true,
          ),
        ],
      ),
    );
  }

  Widget _divider(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Divider(
          height: 1,
          color: context.borderColor.withValues(alpha: 0.5)),
    );
  }
}

class _MetaRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool valueIsChip;

  const _MetaRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueIsChip = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon,
            size: 16, color: context.textSecondary.withValues(alpha: 0.7)),
        const SizedBox(width: 12),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: context.textSecondary,
          ),
        ),
        const Spacer(),
        if (valueIsChip)
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              value,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: context.primaryColor,
              ),
            ),
          )
        else
          Flexible(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: context.textPrimary,
              ),
              textAlign: TextAlign.right,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
      ],
    );
  }
}

// ── Web Additional Files Card ─────────────────────────────────────────────────

class _WebFilesCard extends StatelessWidget {
  final VanbanModel document;
  const _WebFilesCard({required this.document});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final files = document.additionalFiles!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: context.borderColor.withValues(alpha: isDark ? 1.0 : 0.4),
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF16A085).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.attach_file_rounded,
                    size: 16, color: Color(0xFF16A085)),
              ),
              const SizedBox(width: 12),
              Text(
                'File đính kèm (${files.length})',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: context.textPrimary,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...files.asMap().entries.map((e) {
            final name = e.value.split('/').last;
            final ext = name.contains('.')
                ? name.split('.').last.toUpperCase()
                : 'FILE';
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      ext,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: context.primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      name,
                      style: TextStyle(
                          fontSize: 13, color: context.textPrimary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ── Web Action Panel ──────────────────────────────────────────────────────────

class _WebActionPanel extends StatelessWidget {
  final VanbanModel document;
  const _WebActionPanel({required this.document});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: context.borderColor.withValues(alpha: isDark ? 1.0 : 0.4),
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Panel header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1877F2), Color(0xFF42A5F5)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.description_rounded,
                    size: 16, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Text(
                'Thao tác',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: context.textPrimary,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // File preview chip
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: context.surfaceColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: context.borderColor.withValues(alpha: 0.5)),
            ),
            child: Row(
              children: [
                FaIcon(FontAwesomeIcons.filePdf,
                    size: 20, color: AppColors.error),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        document.fileName,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: context.textPrimary,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        document.fileExtension.toUpperCase(),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: context.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Action buttons
          Consumer<VanbanChitietProvider>(
            builder: (context, provider, _) {
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
          if (document.hasMultipleFiles) ...[
            const SizedBox(height: 16),
            Divider(
                color: context.borderColor.withValues(alpha: 0.5)),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.attach_file_rounded,
                    size: 14, color: context.textSecondary),
                const SizedBox(width: 6),
                Text(
                  '${document.additionalFiles!.length + 1} file đính kèm',
                  style: TextStyle(
                      fontSize: 12, color: context.textSecondary),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
