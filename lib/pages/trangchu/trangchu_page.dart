import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/navigation_provider.dart';
import '../../data/models/vanban_model.dart';
import '../vanban/vanban_chitiet_page.dart';
import '../../widgets/trangchu/trangchu_content.dart';
import '../../widgets/trangchu/trangchu_web_content.dart';
import '../../widgets/layout/custom_app_bar.dart';
import '../../widgets/layout/custom_bottom_nav_bar.dart';
import '../../widgets/layout/web_sidebar.dart';
import '../../widgets/layout/web_top_bar.dart';
import '../../widgets/layout/web_app_background.dart';
import '../vanban/vanban_page.dart';
import '../nhansu/nhansu_page.dart';
import '../chamcong/chamcong_page.dart';
import '../chamcong/qr_scanner_page.dart';
import '../chamcong/bosungcong_page.dart';
import '../chamcong/danhsach_bosungcong_page.dart';
import '../luong/luong_page.dart';
import '../lichtruc/lichtruc_page.dart';
import '../lichkham/lichkham_page.dart';
import '../daotao/daotao_page.dart';
import '../thongbao/thongbao_page.dart';
import '../gopykien/gopykien_page.dart';
import '../gioithieu/gioithieu_page.dart';
import '../hotro/hotro_page.dart';
import '../hoso/hoso_page.dart';
import '../caidat/caidat_canhan_page.dart';
import '../caidat/doimatkhau_page.dart';

class TrangchuPage extends StatelessWidget {
  const TrangchuPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = kIsWeb && MediaQuery.of(context).size.width >= 768;
    if (isDesktop) return const _WebTrangchuPage();
    return const _MobileTrangchuPage();
  }
}


class _MobileTrangchuPage extends StatelessWidget {
  const _MobileTrangchuPage();

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationProvider>(
      builder: (context, navProvider, _) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
}

// ── Web layout (sidebar + content) ───────────────────────────────────────────

class _WebTrangchuPage extends StatelessWidget {
  const _WebTrangchuPage();

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationProvider>(
      builder: (context, navProvider, _) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              // Animated gradient background
              const WebAppBackground(),
              // Main layout (sidebar + content)
              Row(
                children: [
                  const WebSidebar(),
                  Expanded(
                    child: Column(
                      children: [
                        const WebTopBar(),
                        Expanded(
                          child: Builder(
                            builder: (bCtx) => Theme(
                              data: Theme.of(bCtx).copyWith(
                                scaffoldBackgroundColor: Colors.transparent,
                              ),
                              child: navProvider.webCurrentPage != null
                                  ? _buildWebSecondaryPage(
                                      navProvider.webCurrentPage!,
                                      detail: navProvider.webDetailDoc,
                                    )
                                  : _buildWebBody(navProvider.currentIndex),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}


Widget _buildWebSecondaryPage(String pageKey, {VanbanModel? detail}) {
  switch (pageKey) {
    case 'luong':          return const LuongPage();
    case 'lichtruc':       return const LichtructPage();
    case 'lichkham':       return const LichkhamPage();
    case 'daotao':         return const DaotaoPage();
    case 'thongbao':       return const ThongBaoPage();
    case 'gopykien':       return const GopyKienPage();
    case 'gioithieu':      return const GioithieuPage();
    case 'hotro':          return const HotroPage();
    case 'profile':        return const HosoPage();
    case 'caidatcanhan':   return const CaidatCanhanPage();
    case 'doimatkhau':     return const DoimatkhauPage();
    case 'bosungcong':     return const BosungcongPage();
    case 'danhsach_bosungcong': return const DanhsachBosungcongPage();
    case 'vanban_chitiet':
      return detail != null
          ? VanbanChitietPage(document: detail)
          : const SizedBox.shrink();
    default:                       return const SizedBox.shrink();
  }
}

// ── Web nav body builder (index 0 dùng dashboard riêng) ──────────────────────

Widget _buildWebBody(int currentIndex) {
  if (currentIndex == 0) return const TrangchuWebContent();
  return _buildBody(currentIndex);
}

// ── Main nav body builder ─────────────────────────────────────────────────────

Widget _buildBody(int currentIndex) {
  switch (currentIndex) {
    case 0:  return const TrangchuContent();
    case 1:  return const VanbanPage();
    case 2:  return const QrScannerPage();
    case 3:  return const ChamcongPage();
    case 4:  return const NhansuPage();
    default: return const TrangchuContent();
  }
}
