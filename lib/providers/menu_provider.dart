import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/routes/app_routes.dart';
import '../widgets/layout/hvgl_menu_sheet.dart';
import '../pages/hoso/hoso_page.dart';
import '../pages/luong/luong_page.dart';
import '../pages/lichtruc/lichtruc_page.dart';
import '../providers/xacthuc_provider.dart';
import '../data/services/data_preload_service.dart';

class MenuProvider extends ChangeNotifier {
  void openMenu(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return HvglMenuSheet(
          onAction: (action) => _handleAction(context, action),
        );
      },
    );
  }

  void _handleAction(BuildContext context, HvglMenuAction action) {
    Navigator.of(context).pop();
    switch (action) {
      case HvglMenuAction.salary:
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const LuongPage()),
        );
        break;
      case HvglMenuAction.documents:
        Navigator.of(context).pushNamed(AppRoutes.documents);
        break;
      case HvglMenuAction.dutySchedule:
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const LichtructPage()),
        );
        break;
      case HvglMenuAction.clinicSchedule:
        break;
      case HvglMenuAction.staff:
        Navigator.of(context).pushNamed(AppRoutes.staff);
        break;
      case HvglMenuAction.notifications:
        break;
      case HvglMenuAction.training:
        break;
      case HvglMenuAction.aboutHospital:
        Navigator.of(context).pushNamed(AppRoutes.about);
        break;
      case HvglMenuAction.profile:
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const HosoPage()),
        );
        break;
      case HvglMenuAction.settings:
        break;
      case HvglMenuAction.help:
        Navigator.of(context).pushNamed(AppRoutes.about);
        break;
      case HvglMenuAction.support:
        Navigator.of(context).pushNamed(AppRoutes.support);
        break;
      case HvglMenuAction.logout:
        // Clear cache của tất cả providers theo config
        DataPreloadService().clearAllCache(context);

        // Logout
        context.read<XacthucProvider>().logout();

        // Điều hướng về màn hình đăng nhập và xóa tất cả màn hình trước đó
        Navigator.of(context).pushNamedAndRemoveUntil(
          AppRoutes.login,
          (route) => false,
        );
        break;
    }
  }
}
