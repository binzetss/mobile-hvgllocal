import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/extensions/theme_extensions.dart';

class GioithieuBaomat extends StatelessWidget {
  const GioithieuBaomat({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFEF4444).withValues(alpha: 0.35),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFEF4444).withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Container(
            width: double.infinity,
            padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
            ),
            child: Row(
              children: [
                const FaIcon(
                  FontAwesomeIcons.shieldHalved,
                  size: 16,
                  color: Colors.white,
                ),
                const SizedBox(width: 10),
                const Text(
                  'CHÍNH SÁCH BẢO MẬT',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'BẮT BUỘC',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _BaomatSection(
                  number: '01',
                  title: 'Cam kết bảo mật thông tin',
                  content:
                      'Mọi thông tin tiếp cận qua ứng dụng — bao gồm dữ liệu bệnh nhân, thông tin lương, lịch làm việc và văn bản nội bộ — đều là tài sản mật của Bệnh viện Hùng Vượng Gia Lai. Tất cả nhân viên có nghĩa vụ bảo vệ và không được tiết lộ dưới bất kỳ hình thức nào.',
                ),
                const SizedBox(height: 16),
                const _BaomatSection(
                  number: '02',
                  title: 'Nghiêm cấm các hành vi sau',
                  bullets: [
                    'Chia sẻ, chụp màn hình hoặc quay video nội dung ứng dụng ra bên ngoài',
                    'Gửi, đăng tải thông tin nội bộ lên mạng xã hội, email cá nhân hoặc bất kỳ kênh nào không được bệnh viện ủy quyền',
                    'Cho mượn tài khoản hoặc truy cập vào tài khoản của người khác',
                    'Lưu trữ dữ liệu bệnh nhân, tài liệu mật trên thiết bị cá nhân không được mã hóa',
                    'Sử dụng thông tin nội bộ cho mục đích cá nhân hoặc ngoài phạm vi công việc',
                  ],
                ),
                const SizedBox(height: 16),
                const _BaomatSection(
                  number: '03',
                  title: 'Hậu quả khi vi phạm',
                  bullets: [
                    'Xử lý kỷ luật theo quy chế nội bộ của bệnh viện, từ cảnh cáo đến buộc thôi việc',
                    'Truy cứu trách nhiệm hành chính hoặc pháp lý theo quy định pháp luật hiện hành',
                    'Thu hồi ngay lập tức toàn bộ quyền truy cập ứng dụng và hệ thống',
                  ],
                ),
                const SizedBox(height: 16),

                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEF4444).withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: const Color(0xFFEF4444).withValues(alpha: 0.25),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 1),
                        child: FaIcon(
                          FontAwesomeIcons.triangleExclamation,
                          size: 14,
                          color: Color(0xFFEF4444),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Lưu ý quan trọng: Mỗi tài khoản được cấp riêng cho từng cá nhân và toàn bộ hoạt động đều được hệ thống ghi lại. Bạn chịu trách nhiệm hoàn toàn trước pháp luật và nhà trường về mọi hành vi thực hiện dưới tài khoản của mình.',
                          style: TextStyle(
                            fontSize: 13,
                            height: 1.55,
                            color: const Color(0xFFEF4444),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
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

class _BaomatSection extends StatelessWidget {
  final String number;
  final String title;
  final String content;
  final List<String> bullets;

  const _BaomatSection({
    required this.number,
    required this.title,
    this.content = '',
    this.bullets = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: const Color(0xFFEF4444),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Center(
                child: Text(
                  number,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: context.textPrimary,
                ),
              ),
            ),
          ],
        ),

        if (content.isNotEmpty) ...[
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 34),
            child: Text(
              content,
              style: TextStyle(
                fontSize: 13,
                height: 1.55,
                color: context.textSecondary,
              ),
            ),
          ),
        ],

        if (bullets.isNotEmpty) ...[
          const SizedBox(height: 8),
          ...bullets.map(
            (b) => Padding(
              padding: const EdgeInsets.only(left: 34, bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 4,
                    height: 4,
                    margin: const EdgeInsets.only(top: 6),
                    decoration: const BoxDecoration(
                      color: Color(0xFFEF4444),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      b,
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.5,
                        color: context.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}
