import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/constants/app_colors.dart';
import '../../core/extensions/theme_extensions.dart';
import '../../widgets/common/common_app_bar.dart';
import '../../widgets/gioithieu/gioithieu_header.dart';
import '../../widgets/gioithieu/gioithieu_section.dart';
import '../../widgets/gioithieu/gioithieu_footer.dart';
import '../../widgets/gioithieu/gioithieu_baomat.dart';

class GioithieuPage extends StatelessWidget {
  const GioithieuPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = kIsWeb && MediaQuery.of(context).size.width >= 768;
    if (isDesktop) return const _WebGioithieuPage();
    return const _MobileGioithieuPage();
  }
}

class _MobileGioithieuPage extends StatelessWidget {
  const _MobileGioithieuPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.bgColor,
      appBar: const CommonAppBar(title: 'Giới Thiệu'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const GioithieuHeader(),
            const SizedBox(height: 32),
            const GioithieuSection(
              icon: FontAwesomeIcons.circleInfo,
              title: 'Giới thiệu ứng dụng',
              content:
                  'Ứng dụng nội bộ bệnh viện được phát triển nhằm hỗ trợ công tác quản lý, vận hành và trao đổi thông tin trong hệ thống bệnh viện, góp phần nâng cao hiệu quả làm việc và chất lượng chăm sóc người bệnh.',
            ),
            const SizedBox(height: 16),
            const GioithieuSection(
              icon: FontAwesomeIcons.flag,
              title: 'Mục tiêu phát triển',
              content:
                  'Ứng dụng được xây dựng trên cơ sở tuân thủ đầy đủ các quy định, quy trình và tiêu chuẩn của bệnh viện, đảm bảo tính bảo mật, an toàn và chính xác của thông tin.',
            ),
            const SizedBox(height: 16),
            const GioithieuSection(
              icon: FontAwesomeIcons.lightbulb,
              title: 'Cải tiến & đóng góp',
              content:
                  'Trong quá trình sử dụng, ứng dụng luôn tiếp nhận ý kiến đóng góp từ người dùng để liên tục cải tiến, tối ưu và đáp ứng tốt hơn nhu cầu thực tế.',
            ),
            const SizedBox(height: 16),
            GioithieuSection(
              icon: FontAwesomeIcons.users,
              title: 'Nhóm phát triển',
              contentWidget: const Text.rich(
                TextSpan(
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    height: 1.6,
                    letterSpacing: -0.2,
                  ),
                  children: [
                    TextSpan(
                        text:
                            'Sản phẩm được xây dựng dưới sự chỉ đạo của Trưởng Phòng'),
                    TextSpan(
                      text: ' Trần Nam Giang (Dekisugi)',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    TextSpan(text: ' cùng các thành viên phát triển: '),
                    TextSpan(
                      text: 'Nguyễn Viết Phú (Suneo)',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    TextSpan(text: ', '),
                    TextSpan(
                      text: 'Lê Anh Quân (Nobita)',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    TextSpan(text: ', '),
                    TextSpan(
                      text: 'Bùi Vạn Đạt (Chaien)',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    TextSpan(text: '.'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const GioithieuBaomat(),
            const SizedBox(height: 24),
            const GioithieuFooter(),
          ],
        ),
      ),
    );
  }
}

class _WebGioithieuPage extends StatelessWidget {
  const _WebGioithieuPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [

          Container(
            height: 64,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              color: context.cardColor,
              border:
                  Border(bottom: BorderSide(color: context.borderColor)),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: FaIcon(
                      FontAwesomeIcons.circleInfo,
                      size: 16,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Giới thiệu & Hỗ trợ',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: context.textPrimary,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                SizedBox(
                  width: 360,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: const Column(
                      children: [
                        GioithieuHeader(),
                        SizedBox(height: 24),
                        GioithieuBaomat(),
                        SizedBox(height: 24),
                        GioithieuFooter(),
                      ],
                    ),
                  ),
                ),

                VerticalDivider(width: 1, color: context.borderColor),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Thông tin ứng dụng',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: context.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 16),

                        const IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: GioithieuSection(
                                  icon: FontAwesomeIcons.circleInfo,
                                  title: 'Giới thiệu ứng dụng',
                                  content:
                                      'Ứng dụng nội bộ bệnh viện được phát triển nhằm hỗ trợ công tác quản lý, vận hành và trao đổi thông tin trong hệ thống bệnh viện, góp phần nâng cao hiệu quả làm việc và chất lượng chăm sóc người bệnh.',
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: GioithieuSection(
                                  icon: FontAwesomeIcons.flag,
                                  title: 'Mục tiêu phát triển',
                                  content:
                                      'Ứng dụng được xây dựng trên cơ sở tuân thủ đầy đủ các quy định, quy trình và tiêu chuẩn của bệnh viện, đảm bảo tính bảo mật, an toàn và chính xác của thông tin.',
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Expanded(
                                child: GioithieuSection(
                                  icon: FontAwesomeIcons.lightbulb,
                                  title: 'Cải tiến & đóng góp',
                                  content:
                                      'Trong quá trình sử dụng, ứng dụng luôn tiếp nhận ý kiến đóng góp từ người dùng để liên tục cải tiến, tối ưu và đáp ứng tốt hơn nhu cầu thực tế.',
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: GioithieuSection(
                                  icon: FontAwesomeIcons.users,
                                  title: 'Nhóm phát triển',
                                  contentWidget: const Text.rich(
                                    TextSpan(
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                        height: 1.6,
                                        letterSpacing: -0.2,
                                      ),
                                      children: [
                                        TextSpan(
                                            text:
                                                'Sản phẩm được xây dựng dưới sự chỉ đạo của Trưởng Phòng'),
                                        TextSpan(
                                          text:
                                              ' Trần Nam Giang (Dekisugi)',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700),
                                        ),
                                        TextSpan(
                                            text:
                                                ' cùng các thành viên phát triển: '),
                                        TextSpan(
                                          text: 'Nguyễn Viết Phú (Suneo)',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700),
                                        ),
                                        TextSpan(text: ', '),
                                        TextSpan(
                                          text: 'Lê Anh Quân (Nobita)',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700),
                                        ),
                                        TextSpan(text: ', '),
                                        TextSpan(
                                          text: 'Bùi Vạn Đạt (Chaien)',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700),
                                        ),
                                        TextSpan(text: '.'),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
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
}
