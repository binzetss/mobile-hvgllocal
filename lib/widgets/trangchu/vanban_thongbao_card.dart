import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/extensions/theme_extensions.dart';
import '../../providers/vanban_provider.dart';
import '../../providers/navigation_provider.dart';
import '../../data/models/vanban_model.dart';
import '../../pages/vanban/vanban_chitiet_page.dart';

class VanbanThongbaoCard extends StatefulWidget {
  const VanbanThongbaoCard({super.key});

  @override
  State<VanbanThongbaoCard> createState() => _VanbanThongbaoCardState();
}

class _VanbanThongbaoCardState extends State<VanbanThongbaoCard> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<VanbanProvider>().init();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<VanbanProvider>(
      builder: (context, provider, _) {
        final isDesktop = kIsWeb && MediaQuery.of(context).size.width >= 768;
        final latestDocs = provider.documents.take(isDesktop ? 8 : 2).toList();

        if (latestDocs.isEmpty) {
          return const SizedBox.shrink();
        }

        final isDark = context.isDark;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: context.cardColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: context.borderColor.withValues(alpha: isDark ? 1.0 : 0.3),
              width: 0.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: AppColors.primaryGradient,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const FaIcon(
                      FontAwesomeIcons.newspaper,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Văn bản - Thông báo',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.3,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Thông tin mới nhất',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (provider.newDocumentsCount > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.error.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: AppColors.error.withValues(alpha: 0.3),
                          width: 0.5,
                        ),
                      ),
                      child: Text(
                        '${provider.newDocumentsCount} mới',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppColors.error,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 14),
              ...latestDocs.asMap().entries.map((entry) {
                final index = entry.key;
                final doc = entry.value;
                return Column(
                  children: [
                    if (index > 0) const SizedBox(height: 12),
                    if (index > 0) const Divider(height: 1),
                    if (index > 0) const SizedBox(height: 12),
                    _DocumentItem(document: doc),
                  ],
                );
              }),
            ],
          ),
        );
      },
    );
  }
}

class _DocumentItem extends StatelessWidget {
  final VanbanModel document;

  const _DocumentItem({required this.document});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        final isDesktop = kIsWeb && MediaQuery.of(context).size.width >= 768;
        if (isDesktop) {
          context.read<NavigationProvider>().setWebVanbanDetail(document);
          return;
        }
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VanbanChitietPage(document: document),
          ),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: _getCategoryColor().withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  document.categoryName,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: _getCategoryColor(),
                    letterSpacing: 0.1,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              if (document.isNew)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Text(
                    'MỚI',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: AppColors.error,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            document.fileName,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: context.primaryColor,
              height: 1.4,
              letterSpacing: -0.3,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              FaIcon(
                FontAwesomeIcons.clock,
                size: 11,
                color: context.textSecondary,
              ),
              const SizedBox(width: 6),
              Text(
                _formatDate(document.uploadedAt),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: context.textSecondary.withValues(alpha: 0.8),
                  letterSpacing: -0.2,
                ),
              ),
              if (document.soKiHieu.isNotEmpty) ...[
                const SizedBox(width: 12),
                FaIcon(
                  FontAwesomeIcons.hashtag,
                  size: 10,
                  color: context.textSecondary,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    document.soKiHieu,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: context.textSecondary.withValues(alpha: 0.7),
                      letterSpacing: -0.1,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor() {
    final colors = [
      AppColors.primary,
      const Color(0xFF8E44AD),
      AppColors.warning,
      AppColors.error,
      const Color(0xFF16A085),
      AppColors.success,
      const Color(0xFFE67E22),
      const Color(0xFF3498DB),
    ];

    if (document.categoryId > 0 && document.categoryId <= colors.length) {
      return colors[document.categoryId - 1];
    }

    return AppColors.textSecondary;
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final compareDate = DateTime(date.year, date.month, date.day);

    if (today == compareDate) {
      return 'Hôm nay ${_formatTime(date)}';
    } else {
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    }
  }

  String _formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
