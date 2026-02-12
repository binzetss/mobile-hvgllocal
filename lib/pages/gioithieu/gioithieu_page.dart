import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/constants/app_colors.dart';
import '../../widgets/common/common_app_bar.dart';
import '../../widgets/gioithieu/gioithieu_header.dart';
import '../../widgets/gioithieu/gioithieu_section.dart';
import '../../widgets/gioithieu/gioithieu_footer.dart';

class GioithieuPage extends StatelessWidget {
  const GioithieuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
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
              contentWidget: RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textPrimary,
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
            const GioithieuFooter(),
          ],
        ),
      ),
    );
  }
}
