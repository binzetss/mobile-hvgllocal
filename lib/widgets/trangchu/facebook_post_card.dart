import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/constants/app_colors.dart';
import '../../core/extensions/theme_extensions.dart';
import '../../providers/facebook_provider.dart';
import '../../data/models/facebook_post_model.dart';
import '../common/app_dialogs.dart';

class FacebookPostCard extends StatefulWidget {
  const FacebookPostCard({super.key});

  @override
  State<FacebookPostCard> createState() => _FacebookPostCardState();
}

class _FacebookPostCardState extends State<FacebookPostCard> {
  int _currentPostIndex = 0;
  int _slideDirection = 1;
  final Map<int, bool> _expandedMap = {};
  double _dragStartX = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FacebookProvider>().fetchPosts(limit: 3);
    });
  }

  void _goToPost(int index, int direction) {
    setState(() {
      _slideDirection = direction;
      _currentPostIndex = index;
    });
  }

  Future<void> _openPost(String? permalink) async {
    if (permalink == null) return;
    final uri = Uri.parse(permalink);
    try {
      // Không dùng canLaunchUrl vì hay trả false sai trên iOS
      final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched && mounted) {
        showErrorDialog(context,
            message: 'Không thể mở link Facebook.\nVui lòng kiểm tra lại kết nối mạng.');
      }
    } catch (_) {
      // Fallback: mở bằng trình duyệt mặc định
      try {
        await launchUrl(uri, mode: LaunchMode.platformDefault);
      } catch (e) {
        if (mounted) {
          showErrorDialog(context,
              message: 'Không thể mở link Facebook.\nVui lòng kiểm tra lại kết nối mạng.');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FacebookProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) return _buildLoadingCard();
        if (provider.hasError) return _buildErrorCard(provider.errorMessage);
        if (provider.posts.isEmpty) return const SizedBox.shrink();

        final posts = provider.posts;
        final safeIndex = _currentPostIndex.clamp(0, posts.length - 1);

        return _buildCard(posts, safeIndex);
      },
    );
  }

  Widget _buildCard(List<FacebookPostModel> posts, int postIndex) {
    final isDark = context.isDark;
    final post = posts[postIndex];

    return Container(
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: context.borderColor.withValues(alpha: isDark ? 1.0 : 0.3),
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.0 : 0.06),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.1),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Row(
              children: [

                _buildAvatar(post.pageAvatar),
                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'BV Hùng Vương Gia Lai',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.3,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1877F2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'Bảng tin',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        post.timeAgo,
                        style: TextStyle(
                          fontSize: 12,
                          color: context.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

                if (posts.length > 1) _buildPostDots(posts.length, postIndex),
              ],
            ),
          ),

          GestureDetector(
            onHorizontalDragStart: (d) => _dragStartX = d.globalPosition.dx,
            onHorizontalDragEnd: (d) {
              final delta = d.globalPosition.dx - _dragStartX;
              if (delta.abs() < 40) return;
              if (delta < 0 && postIndex < posts.length - 1) {
                _goToPost(postIndex + 1, 1);
              } else if (delta > 0 && postIndex > 0) {
                _goToPost(postIndex - 1, -1);
              }
            },
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 280),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              transitionBuilder: (child, animation) {
                final offsetTween = Tween<Offset>(
                  begin: Offset(_slideDirection * 0.15, 0),
                  end: Offset.zero,
                );
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: offsetTween.animate(animation),
                    child: child,
                  ),
                );
              },
              child: KeyedSubtree(
                key: ValueKey(postIndex),
                child: _buildPostBody(post, postIndex),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(String? avatarUrl) {
    return Stack(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFF1877F2).withValues(alpha: 0.3),
              width: 2,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: avatarUrl != null
                ? CachedNetworkImage(
                    imageUrl: avatarUrl,
                    fit: BoxFit.cover,
                    placeholder: (_, _) => _avatarPlaceholder(),
                    errorWidget: (_, _, _) => _avatarPlaceholder(),
                  )
                : _avatarPlaceholder(),
          ),
        ),
        Positioned(
          bottom: -2,
          right: -2,
          child: Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: const Color(0xFF1877F2),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 1.5),
            ),
            child: const FaIcon(
              FontAwesomeIcons.facebook,
              size: 9,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _avatarPlaceholder() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1877F2), Color(0xFF0C5AC2)],
        ),
      ),
      child: const Center(
        child: FaIcon(FontAwesomeIcons.hospital, size: 18, color: Colors.white),
      ),
    );
  }

  Widget _buildPostDots(int count, int currentIndex) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (i) {
        final active = i == currentIndex;
        return GestureDetector(
          onTap: () => _goToPost(i, i > currentIndex ? 1 : -1),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.symmetric(horizontal: 3),
            width: active ? 20 : 7,
            height: 7,
            decoration: BoxDecoration(
              color: active
                  ? const Color(0xFF1877F2)
                  : context.borderColor,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildPostBody(FacebookPostModel post, int postIndex) {
    final isDark = context.isDark;
    final isExpanded = _expandedMap[postIndex] ?? false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        if (post.images.isNotEmpty) ...[
          const SizedBox(height: 14),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _buildImageGrid(post.images),
          ),
        ],

        Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: context.surfaceColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: context.borderColor.withValues(alpha: isDark ? 1.0 : 0.4),
                width: 0.5,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isExpanded ? post.message : post.shortMessage,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    fontWeight: FontWeight.w400,
                    letterSpacing: -0.2,
                  ),
                ),
                if (post.message.length > 150) ...[
                  const SizedBox(height: 6),
                  GestureDetector(
                    onTap: () => setState(
                        () => _expandedMap[postIndex] = !isExpanded),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          isExpanded ? 'Thu gọn' : 'Xem thêm',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1877F2),
                          ),
                        ),
                        const SizedBox(width: 4),
                        FaIcon(
                          isExpanded
                              ? FontAwesomeIcons.chevronUp
                              : FontAwesomeIcons.chevronDown,
                          size: 11,
                          color: const Color(0xFF1877F2),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
          child: Row(
            children: [
              _buildStat(FontAwesomeIcons.thumbsUp, post.likesCount ?? 0,
                  const Color(0xFF1877F2)),
              const SizedBox(width: 16),
              _buildStat(FontAwesomeIcons.comment, post.commentsCount ?? 0,
                  context.textSecondary),
              const SizedBox(width: 16),
              _buildStat(FontAwesomeIcons.share, post.sharesCount ?? 0,
                  context.textSecondary),
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _openPost(post.permalink),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1877F2), Color(0xFF0C5AC2)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF1877F2).withValues(alpha: 0.30),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FaIcon(FontAwesomeIcons.arrowUpRightFromSquare,
                        size: 13, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'Xem bài viết trên Facebook',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImageGrid(List<String> images) {
    const radius = Radius.circular(12);

    if (images.length == 1) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: _img(images[0]),
        ),
      );
    }

    if (images.length == 2) {
      return SizedBox(
        height: kIsWeb ? 340 : 200,
        child: Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                    topLeft: radius, bottomLeft: radius),
                child: _img(images[0]),
              ),
            ),
            const SizedBox(width: 2),
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                    topRight: radius, bottomRight: radius),
                child: _img(images[1]),
              ),
            ),
          ],
        ),
      );
    }

    if (images.length == 3) {
      return SizedBox(
        height: kIsWeb ? 400 : 240,
        child: Row(
          children: [

            Expanded(
              flex: 2,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                    topLeft: radius, bottomLeft: radius),
                child: _img(images[0]),
              ),
            ),
            const SizedBox(width: 2),

            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius:
                          const BorderRadius.only(topRight: radius),
                      child: _img(images[1]),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Expanded(
                    child: ClipRRect(
                      borderRadius:
                          const BorderRadius.only(bottomRight: radius),
                      child: _img(images[2]),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    final extra = images.length - 4;
    return SizedBox(
      height: kIsWeb ? 400 : 240,
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(topLeft: radius),
                    child: _img(images[0]),
                  ),
                ),
                const SizedBox(width: 2),
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(topRight: radius),
                    child: _img(images[1]),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 2),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius:
                        const BorderRadius.only(bottomLeft: radius),
                    child: _img(images[2]),
                  ),
                ),
                const SizedBox(width: 2),
                Expanded(
                  child: ClipRRect(
                    borderRadius:
                        const BorderRadius.only(bottomRight: radius),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        _img(images[3]),
                        if (extra > 0)
                          Container(
                            color: Colors.black.withValues(alpha: 0.55),
                            child: Center(
                              child: Text(
                                '+$extra',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _img(String url) {
    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      placeholder: (_, _) => Container(color: context.surfaceColor),
      errorWidget: (_, _, _) => Container(
        color: context.surfaceColor,
        child: Center(
          child: FaIcon(FontAwesomeIcons.image,
              color: context.textSecondary, size: 28),
        ),
      ),
    );
  }

  Widget _buildStat(IconData icon, int count, Color color) {
    return Row(
      children: [
        FaIcon(icon, size: 12, color: color),
        const SizedBox(width: 5),
        Text(
          count.toString(),
          style: TextStyle(
              fontSize: 12, fontWeight: FontWeight.w600, color: color),
        ),
      ],
    );
  }

  Widget _buildLoadingCard() {
    final isDark = context.isDark;
    final base = isDark ? const Color(0xFF2C2C2E) : AppColors.backgroundSecondary;
    final hi = isDark ? const Color(0xFF3A3A3C) : Colors.white;
    final bar = isDark ? const Color(0xFF2C2C2E) : Colors.white;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: context.borderColor.withValues(alpha: isDark ? 1.0 : 0.3),
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Shimmer.fromColors(
        baseColor: base,
        highlightColor: hi,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                        color: bar, borderRadius: BorderRadius.circular(12))),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          width: 160,
                          height: 14,
                          decoration: BoxDecoration(
                              color: bar,
                              borderRadius: BorderRadius.circular(4))),
                      const SizedBox(height: 6),
                      Container(
                          width: 80,
                          height: 11,
                          decoration: BoxDecoration(
                              color: bar,
                              borderRadius: BorderRadius.circular(4))),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                    color: bar, borderRadius: BorderRadius.circular(12))),
            const SizedBox(height: 14),
            Container(
                width: double.infinity,
                height: 80,
                decoration: BoxDecoration(
                    color: context.surfaceColor,
                    borderRadius: BorderRadius.circular(12))),
            const SizedBox(height: 12),
            Row(children: [
              Container(
                  width: 60,
                  height: 18,
                  decoration: BoxDecoration(
                      color: bar, borderRadius: BorderRadius.circular(4))),
              const SizedBox(width: 12),
              Container(
                  width: 60,
                  height: 18,
                  decoration: BoxDecoration(
                      color: bar, borderRadius: BorderRadius.circular(4))),
              const SizedBox(width: 12),
              Container(
                  width: 60,
                  height: 18,
                  decoration: BoxDecoration(
                      color: bar, borderRadius: BorderRadius.circular(4))),
            ]),
            const SizedBox(height: 14),
            Container(
                width: double.infinity,
                height: 44,
                decoration: BoxDecoration(
                    color: bar, borderRadius: BorderRadius.circular(12))),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorCard(String? msg) {
    final isDark = context.isDark;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: context.borderColor.withValues(alpha: isDark ? 1.0 : 0.3),
          width: 0.5,
        ),
      ),
      child: Column(
        children: [
          const FaIcon(FontAwesomeIcons.triangleExclamation,
              size: 24, color: AppColors.error),
          const SizedBox(height: 12),
          Text(
            msg ?? 'Không thể tải bài viết',
            style: TextStyle(fontSize: 12, color: context.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
