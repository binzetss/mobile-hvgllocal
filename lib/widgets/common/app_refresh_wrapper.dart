import 'package:flutter/material.dart';
import '../../core/extensions/theme_extensions.dart';

/// Widget tái sử dụng cho chức năng kéo xuống để làm mới (swipe to refresh).
///
/// Dùng ở tầng Page, truyền [onRefresh] từ provider vào.
/// Widget không chứa bất kỳ logic nghiệp vụ nào.
class AppRefreshWrapper extends StatelessWidget {
  final Widget child;
  final Future<void> Function() onRefresh;

  const AppRefreshWrapper({
    super.key,
    required this.child,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      color: context.primaryColor,
      backgroundColor: context.cardColor,
      displacement: 40,
      child: child,
    );
  }
}
