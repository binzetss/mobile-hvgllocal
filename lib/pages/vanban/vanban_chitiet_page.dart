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
import '../../widgets/vanban/pdf_iframe_widget.dart';
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

class _MobileLayout extends StatefulWidget {
  final VanbanModel document;
  const _MobileLayout({required this.document});

  @override
  State<_MobileLayout> createState() => _MobileLayoutState();
}

class _MobileLayoutState extends State<_MobileLayout> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        VanbanChitietActions.handleOpenPdf(context, widget.document);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const CommonAppBar(title: 'Chi Tiết Văn Bản'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            VanbanHeaderCard(document: widget.document),
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
                        VanbanChitietActions.formatDate(widget.document.uploadedAt),
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
                        'ID: ${widget.document.fileId}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: context.textSecondary.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  if (widget.document.soKiHieu.isNotEmpty) ...[
                    InfoCard(
                      icon: FontAwesomeIcons.fileSignature,
                      label: 'Số ký hiệu',
                      value: widget.document.soKiHieu,
                    ),
                    const SizedBox(height: 12),
                  ],
                  InfoCard(
                    icon: FontAwesomeIcons.folderOpen,
                    label: 'Danh mục',
                    value: widget.document.categoryName,
                  ),
                  const SizedBox(height: 24),
                  Consumer<VanbanChitietProvider>(
                    builder: (context, provider, _) {
                      return ActionButtons(
                        onOpenPdf: () =>
                            VanbanChitietActions.handleOpenPdf(context, widget.document),
                        onDownloadPdf: () =>
                            VanbanChitietActions.handleDownloadPdf(context, widget.document),
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

class _WebLayout extends StatefulWidget {
  final VanbanModel document;
  const _WebLayout({required this.document});

  @override
  State<_WebLayout> createState() => _WebLayoutState();
}

class _WebLayoutState extends State<_WebLayout> {
  String? _pdfUrl;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadPdfUrl());
  }

  Future<void> _loadPdfUrl() async {
    try {
      final provider =
          Provider.of<VanbanChitietProvider>(context, listen: false);
      final filePath = widget.document.filePath;
      final absoluteUrl = VanbanChitietActions.toAbsoluteUrl(filePath);
      final uri = Uri.parse(absoluteUrl);
      final inlineUri = uri.replace(queryParameters: {
        ...uri.queryParameters,
        'inline': 'true',
      });
      final url = await provider.getAuthenticatedUrl(inlineUri.toString());
      if (mounted) setState(() { _pdfUrl = url; _isLoading = false; });
    } catch (e) {
      if (mounted) setState(() { _error = e.toString(); _isLoading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          _Breadcrumb(
            document: widget.document,
            trailing: Tooltip(
              message: 'Tải xuống',
              child: InkWell(
                onTap: () => VanbanChitietActions.handleDownloadPdf(
                    context, widget.document),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: context.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.download_rounded,
                          size: 16, color: context.primaryColor),
                      const SizedBox(width: 6),
                      Text(
                        'Tải xuống',
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
            ),
          ),
          _WebDocInfoBar(document: widget.document),
          Expanded(child: _buildPdfArea(context)),
        ],
      ),
    );
  }

  Widget _buildPdfArea(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline_rounded,
                size: 48, color: context.textSecondary),
            const SizedBox(height: 12),
            Text(
              'Không thể tải tài liệu',
              style: TextStyle(color: context.textSecondary),
            ),
          ],
        ),
      );
    }
    return PdfIframeWidget(url: _pdfUrl!);
  }
}

class _WebDocInfoBar extends StatelessWidget {
  final VanbanModel document;
  const _WebDocInfoBar({required this.document});

  Color _categoryColor() {
    const colors = [
      AppColors.primary,
      Color(0xFF8E44AD),
      AppColors.warning,
      AppColors.error,
      Color(0xFF16A085),
      AppColors.success,
      Color(0xFFE67E22),
      Color(0xFF3498DB),
    ];
    if (document.categoryId > 0 && document.categoryId <= colors.length) {
      return colors[document.categoryId - 1];
    }
    return AppColors.primary;
  }

  @override
  Widget build(BuildContext context) {
    final color = _categoryColor();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withValues(alpha: 0.85)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Row(
        children: [

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.22),
              borderRadius: BorderRadius.circular(7),
              border: Border.all(
                  color: Colors.white.withValues(alpha: 0.3), width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.folder_rounded,
                    size: 12, color: Colors.white),
                const SizedBox(width: 5),
                Text(
                  document.categoryName,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          if (document.isNew) ...[
            const SizedBox(width: 8),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)]),
                borderRadius: BorderRadius.circular(7),
              ),
              child: const Text(
                'MỚI',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
          const SizedBox(width: 16),

          Expanded(
            child: Text(
              document.fileName,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: -0.2,
                shadows: [
                  Shadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(0, 1))
                ],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          const SizedBox(width: 20),
          Icon(Icons.calendar_today_rounded,
              size: 13, color: Colors.white.withValues(alpha: 0.8)),
          const SizedBox(width: 5),
          Text(
            VanbanChitietActions.formatDate(document.publishedDate),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
          if (document.soKiHieu.isNotEmpty) ...[
            const SizedBox(width: 16),
            Icon(Icons.tag_rounded,
                size: 13, color: Colors.white.withValues(alpha: 0.8)),
            const SizedBox(width: 4),
            Text(
              document.soKiHieu,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.white.withValues(alpha: 0.9),
              ),
            ),
          ],
          if (document.isPdfFile) ...[
            const SizedBox(width: 16),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.22),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3), width: 1),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FaIcon(FontAwesomeIcons.filePdf,
                      size: 11, color: Colors.white),
                  SizedBox(width: 5),
                  Text(
                    'PDF',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Breadcrumb extends StatelessWidget {
  final VanbanModel document;
  final Widget? trailing;
  const _Breadcrumb({required this.document, this.trailing});

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
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
