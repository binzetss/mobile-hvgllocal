import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/navigation_provider.dart';
import '../../widgets/trangchu/trangchu_content.dart';
import '../../widgets/layout/custom_app_bar.dart';
import '../../widgets/layout/custom_bottom_nav_bar.dart';
import '../vanban/vanban_page.dart';
import '../nhansu/nhansu_page.dart';
import '../chamcong/chamcong_page.dart';
import '../chamcong/qr_scanner_page.dart';

class TrangchuPage extends StatelessWidget {
  const TrangchuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationProvider>(
      builder: (context, navProvider, _) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: navProvider.currentIndex == 2
              ? null
              : const CustomAppBar(notificationCount: 1),
          body: _buildBody(navProvider.currentIndex),
          bottomNavigationBar: CustomBottomNavBar(
            currentIndex: navProvider.currentIndex,
            onTap: navProvider.setIndex,
          ),
        );
      },
    );
  }

  Widget _buildBody(int currentIndex) {
    switch (currentIndex) {
      case 0:
        return const TrangchuContent();
      case 1:
        return const VanbanPage();
      case 2:
        return const QrScannerPage();
      case 3:
        return const ChamcongPage();
      case 4:
        return const NhansuPage();
      default:
        return const TrangchuContent();
    }
  }
}
