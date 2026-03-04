import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/constants/app_colors.dart';
import '../../core/extensions/theme_extensions.dart';
import '../../core/utils/token_manager.dart';

class HosoHeader extends StatelessWidget {
  final String name;
  final String birthYear;
  final String gender;
  final String? avatarUrl;
  final File? localAvatarFile;
  final bool isUploading;
  final VoidCallback? onAvatarTap;

  const HosoHeader({
    super.key,
    required this.name,
    required this.birthYear,
    required this.gender,
    this.avatarUrl,
    this.localAvatarFile,
    this.isUploading = false,
    this.onAvatarTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            context.primaryColor.withValues(alpha: 0.08),
            context.primaryColor.withValues(alpha: 0.02),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: context.primaryColor.withValues(alpha: 0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: context.primaryColor.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildAvatar(context),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildChip(context, FontAwesomeIcons.cakeCandles, birthYear),
                    const SizedBox(width: 8),
                    _buildChip(
                      context,
                      gender.toLowerCase().contains('nam')
                          ? FontAwesomeIcons.mars
                          : FontAwesomeIcons.venus,
                      gender,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    return GestureDetector(
      onTap: isUploading ? null : onAvatarTap,
      child: Stack(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: AppColors.primaryGradient,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: context.primaryColor.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipOval(child: _buildAvatarContent()),
          ),

          if (isUploading)
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black.withValues(alpha: 0.45),
              ),
              child: const Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                  ),
                ),
              ),
            ),

          if (!isUploading)
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: context.primaryColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
                child: const Center(
                  child: FaIcon(
                    FontAwesomeIcons.camera,
                    size: 11,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAvatarContent() {
    if (localAvatarFile != null) {
      return Image.file(
        localAvatarFile!,
        width: 72,
        height: 72,
        fit: BoxFit.cover,
        errorBuilder: (ctx, err, st) => _defaultIcon(),
      );
    }
    if (avatarUrl != null && avatarUrl!.isNotEmpty) {
      final token = TokenManager().getCachedToken();
      return CachedNetworkImage(
        imageUrl: avatarUrl!,
        httpHeaders: token != null ? {'Authorization': 'Bearer $token'} : {},
        width: 72,
        height: 72,
        fit: BoxFit.cover,
        placeholder: (ctx, url) => _defaultIcon(),
        errorWidget: (ctx, url, err) => _defaultIcon(),
      );
    }
    return _defaultIcon();
  }

  Widget _defaultIcon() {
    return const Center(
      child: FaIcon(
        FontAwesomeIcons.userTie,
        color: Colors.white,
        size: 30,
      ),
    );
  }

  Widget _buildChip(BuildContext context, IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: context.primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(icon, size: 11, color: context.primaryColor),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: context.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
