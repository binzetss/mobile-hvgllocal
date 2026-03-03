import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../core/extensions/theme_extensions.dart';
import '../../providers/navigation_provider.dart';
import '../../providers/thongbao_provider.dart';

class WebTopBar extends StatelessWidget implements PreferredSizeWidget {
  const WebTopBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(64);

  static const _mainTitles = {
    0: 'Trang chủ',
    1: 'Văn bản',
    3: 'Chấm công',
    4: 'Nhân sự',
  };

  static const _secondaryTitles = {
    'luong':        'Thông tin lương',
    'lichtruc':     'Lịch trực',
    'lichkham':     'Lịch khám',
    'daotao':       'Đào tạo',
    'thongbao':     'Thông báo',
    'gopykien':     'Góp ý & đánh giá',
    'gioithieu':    'Giới thiệu & Hỗ trợ',
    'profile':      'Hồ sơ cá nhân',
    'caidatcanhan':   'Cài đặt cá nhân',
    'doimatkhau':     'Đổi mật khẩu',
    'vanban_chitiet':      'Chi Tiết Văn Bản',
    'bosungcong':          'Bổ Sung Công',
    'danhsach_bosungcong': 'Danh Sách Bổ Sung Công',
  };

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationProvider>(
      builder: (context, nav, _) {
        final title = nav.webCurrentPage != null
            ? _secondaryTitles[nav.webCurrentPage!] ?? 'HVGL'
            : _mainTitles[nav.currentIndex] ?? 'HVGL';

        return Container(
          height: 64,
          decoration: BoxDecoration(
            color: context.cardColor,
            border: Border(
              bottom: BorderSide(color: context.borderColor, width: 1),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: context.textPrimary,
                  letterSpacing: -0.3,
                ),
              ),
              const Spacer(),
              _NotificationButton(),
            ],
          ),
        );
      },
    );
  }
}

class _NotificationButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThongBaoProvider>(
      builder: (context, thongBao, _) {
        final hasUnread = thongBao.unreadCount > 0;
        return InkWell(
          onTap: () => context.read<NavigationProvider>().setWebCurrentPage('thongbao'),
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: context.surfaceColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                FaIcon(
                  FontAwesomeIcons.bell,
                  size: 16,
                  color: context.textSecondary,
                ),
                if (hasUnread)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFFEF4444),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
