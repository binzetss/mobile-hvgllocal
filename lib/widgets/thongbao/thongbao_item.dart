import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/thongbao_model.dart';

class ThongBaoItem extends StatelessWidget {
  final ThongBao thongBao;
  final VoidCallback? onTap;
  final VoidCallback? onDismiss;

  const ThongBaoItem({
    super.key,
    required this.thongBao,
    this.onTap,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(thongBao.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismiss?.call(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const FaIcon(
          FontAwesomeIcons.trash,
          color: Colors.white,
          size: 20,
        ),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: thongBao.isRead
                ? AppColors.backgroundSecondary.withValues(alpha: 0.5)
                : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: thongBao.isRead
                  ? Colors.transparent
                  : AppColors.primary.withValues(alpha: 0.2),
              width: 1,
            ),
            boxShadow: thongBao.isRead
                ? []
                : [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildIcon(),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            thongBao.title,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: thongBao.isRead
                                  ? FontWeight.w500
                                  : FontWeight.w600,
                              color: thongBao.isRead
                                  ? AppColors.textSecondary
                                  : AppColors.textPrimary,
                              letterSpacing: -0.2,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (thongBao.isNew)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            margin: const EdgeInsets.only(left: 8),
                            decoration: BoxDecoration(
                              color: AppColors.error.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'MỚI',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: AppColors.error,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                        if (!thongBao.isRead && !thongBao.isNew)
                          Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.only(left: 8),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      thongBao.content,
                      style: TextStyle(
                        fontSize: 13,
                        color: thongBao.isRead
                            ? AppColors.textSecondary.withValues(alpha: 0.7)
                            : AppColors.textSecondary,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _formatTime(thongBao.time),
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary.withValues(alpha: 0.6),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    final config = _getIconConfig();
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            config.color.withValues(alpha: 0.15),
            config.color.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: config.color.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Center(
        child: FaIcon(
          config.icon,
          size: 18,
          color: config.color,
        ),
      ),
    );
  }

  _IconConfig _getIconConfig() {
    switch (thongBao.type) {
      case 'chamcong':
        return _IconConfig(
          icon: FontAwesomeIcons.fingerprint,
          color: const Color(0xFF10B981),
        );
      case 'luong':
        return _IconConfig(
          icon: FontAwesomeIcons.wallet,
          color: const Color(0xFFF59E0B),
        );
      case 'vanban':
        return _IconConfig(
          icon: FontAwesomeIcons.fileLines,
          color: const Color(0xFF3B82F6),
        );
      case 'hethong':
        return _IconConfig(
          icon: FontAwesomeIcons.gear,
          color: const Color(0xFF8B5CF6),
        );
      case 'sukien':
        return _IconConfig(
          icon: FontAwesomeIcons.calendar,
          color: const Color(0xFFEC4899),
        );
      default:
        return _IconConfig(
          icon: FontAwesomeIcons.bell,
          color: AppColors.primary,
        );
    }
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inMinutes < 1) {
      return 'Vừa xong';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes} phút trước';
    } else if (diff.inHours < 24) {
      return '${diff.inHours} giờ trước';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} ngày trước';
    } else {
      return '${time.day}/${time.month}/${time.year}';
    }
  }
}

class _IconConfig {
  final IconData icon;
  final Color color;

  _IconConfig({required this.icon, required this.color});
}
