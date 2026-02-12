import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/vanban_provider.dart';
import '../../providers/lichkham_provider.dart';
import '../../providers/thongbao_provider.dart';

class PreloadProviderConfig {
  final String name;
  final Future<void> Function(BuildContext context) preload;
  final void Function(BuildContext context) clearCache;

  PreloadProviderConfig({
    required this.name,
    required this.preload,
    required this.clearCache,
  });
}
final List<PreloadProviderConfig> preloadProviders = [
  PreloadProviderConfig(
    name: 'Thông báo',
    preload: (context) => context.read<ThongBaoProvider>().init(),
    clearCache: (context) => context.read<ThongBaoProvider>().clearCache(),
  ),

  PreloadProviderConfig(
    name: 'Văn bản nội bộ',
    preload: (context) => context.read<VanbanProvider>().init(),
    clearCache: (context) => context.read<VanbanProvider>().clearCache(),
  ),

  PreloadProviderConfig(
    name: 'Lịch khám bệnh',
    preload: (context) => context.read<LichkhamProvider>().init(),
    clearCache: (context) => context.read<LichkhamProvider>().clearCache(),
  ),
];
