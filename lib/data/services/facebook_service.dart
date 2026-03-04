import '../models/facebook_post_model.dart';

class FacebookService {

  Future<FacebookPostModel?> getLatestPost() async {
    try {

      await Future.delayed(const Duration(milliseconds: 800));

      return _getMockLatestPost();
    } catch (e) {
      throw Exception('Không thể tải bài viết Facebook: $e');
    }
  }

  Future<List<FacebookPostModel>> getPosts({int limit = 5}) async {
    try {
      await Future.delayed(const Duration(milliseconds: 1000));

      return _getMockPosts().take(limit).toList();
    } catch (e) {
      throw Exception('Không thể tải danh sách bài viết Facebook: $e');
    }
  }

  FacebookPostModel _getMockLatestPost() {
    return FacebookPostModel(
      id: '1',
      message: '🌈 THÔNG BÁO\n'
          'CHUYÊN GIA BỆNH VIỆN CHỢ RẪY ĐẾN HỖ TRỢ NÂNG CAO NĂNG LỰC CHUYÊN MÔN TRONG LĨNH VỰC NGOẠI TIÊU HÓA\n\n'
          'Nhằm nâng cao chất lượng chuyên môn và cập nhật các kỹ thuật điều trị hiện đại, ngày 28/01/2026, TS.BS Trần Phùng Dũng Tiến – Trưởng khoa Ngoại Tiêu hóa và ThS.BS Tiêu Loan Quang Lâm – Khoa Ngoại Tiêu hóa, Bệnh viện Chợ Rẫy sẽ đến hỗ trợ nâng cao năng lực chuyên môn trong lĩnh vực Ngoại Tiêu hóa tại Bệnh viện Hùng Vương Gia Lai.\n\n'
          'Trong khuôn khổ chương trình, các chuyên gia Bệnh viện Chợ Rẫy sẽ trực tiếp tham gia thực hiện và hướng dẫn kỹ thuật phẫu thuật nội soi cắt bán phần dưới dạ dày, nạo hạch D2 do ung thư cùng đội ngũ y bác sĩ khoa Ngoại Tổng hợp – Bệnh viện Hùng Vương Gia Lai.\n\n'
          'Hoạt động hỗ trợ chuyên môn này sẽ góp phần chuyển giao kỹ thuật, nâng cao năng lực chuyên môn cho đội ngũ y bác sĩ, đồng thời giúp người bệnh tại tỉnh Gia Lai và khu vực lân cận được tiếp cận các kỹ thuật điều trị ung thư tiêu hóa chuyên sâu ngay tại địa phương, góp phần nâng cao hiệu quả điều trị và chất lượng chăm sóc người bệnh.\n\n'
          '----------------------\n'
          '🌈BỆNH VIỆN HÙNG VƯƠNG GIA LAI\n'
          '📍Địa chỉ: 236A Lê Duẩn, Phường Hội Phú, Tỉnh Gia Lai\n'
          '☎ Tổng đài CSKH: 1800 8015 (Miễn cước)\n'
          '📞 Hotline cấp cứu 24/24: 0914 555 115\n'
          '🌐 Website: https://hvgl.vn',
      images: [
        'https://image.bvhvgl.com/images/AppNoiBo/baivietfb.jpg',
        'https://image.bvhvgl.com/images/AppNoiBo/baiviet2.jpg',
        'https://image.bvhvgl.com/images/AppNoiBo/baiviet3.jpg',
      ],
      pageAvatar: 'https://image.bvhvgl.com/images/AppNoiBo/logofb.jpg',
      createdTime: DateTime.now().subtract(const Duration(hours: 2)),
      permalink: 'https://www.facebook.com/benhvienhungvuonggialai',
      likesCount: 156,
      commentsCount: 23,
      sharesCount: 18,
    );
  }

  List<FacebookPostModel> _getMockPosts() {
    return [
      FacebookPostModel(
        id: '1',
        message: '🏥 THÔNG BÁO LỊCH LÀM VIỆC TẾT NGUYÊN ĐÁN 2026\n\n'
            'Kính gửi Quý bệnh nhân và gia đình,\n\n'
            'Bệnh viện Hùng Vương Gia Lai xin thông báo lịch làm việc trong dịp Tết Nguyên đán Bính Ngọ 2026:\n\n'
            '📅 Nghỉ Tết: 27/01 - 02/02/2026\n'
            '✅ Khoa Cấp cứu: Trực 24/7\n'
            '✅ Khoa Sản: Trực 24/7\n'
            '✅ Khoa Nhi: Trực 24/7\n\n'
            'Chúc Quý vị và gia đình một năm mới an khang, thịnh vượng! 🎊',
        fullPicture: 'https://scontent.fsgn2-6.fna.fbcdn.net/v/t39.30808-6/470960698_1115539073935395_1881037859844862086_n.jpg?_nc_cat=109&ccb=1-7&_nc_sid=127cfc&_nc_eui2=AeFyVxOW0p_qmNZKH0tGjEtOkPx0gqYPZ-KQ_HSCpg9n4h9SILhOvEwUP8u5nrLi2P4XKX_eYrxULdGx88e_pMJG&_nc_ohc=tULRqI0SX-UQ7kNvgGVK6P8&_nc_zt=23&_nc_ht=scontent.fsgn2-6.fna&_nc_gid=AsNXLvIbKYOFnU4aUwbhQNc&oh=00_AYDnzKuFsaXl4BN-rLKNGKK1TT9xXHzfXQ2tZoGLq9Pd-Q&oe=67A96BA6',
        createdTime: DateTime.now().subtract(const Duration(hours: 5)),
        permalink: 'https://www.facebook.com/benhvienhungvuonggialai/posts/123456789',
        likesCount: 245,
        commentsCount: 18,
        sharesCount: 32,
      ),
      FacebookPostModel(
        id: '2',
        message: '👨‍⚕️ CHƯƠNG TRÌNH KHÁM SỨC KHỎE ĐỊNH KỲ CHO CÁN BỘ CÔNG NHÂN VIÊN\n\n'
            'Bệnh viện Hùng Vương Gia Lai triển khai chương trình khám sức khỏe định kỳ năm 2026 với:\n\n'
            '✅ Gói khám tổng quát\n'
            '✅ Xét nghiệm máu, nước tiểu\n'
            '✅ Chụp X-quang phổi\n'
            '✅ Siêu âm bụng tổng quát\n\n'
            'Liên hệ: 0260.3871.788 để đăng ký!',
        fullPicture: 'https://scontent.fsgn2-3.fna.fbcdn.net/v/t39.30808-6/470922099_1115539110602058_8732878577518622177_n.jpg?_nc_cat=101&ccb=1-7&_nc_sid=127cfc&_nc_eui2=AeF4vePVYxYM_ULmWLl4fI1sn5cYWWv6s6SflxhZa_qzpOrwzMy8UPK2AW46MSDvC6qp19rnpNt8cVq3oU1bqxsq&_nc_ohc=IUnfQdD0YIMQ7kNvgEwXm9E&_nc_zt=23&_nc_ht=scontent.fsgn2-3.fna&_nc_gid=ArdExWgcw0cPzmqfPxpS8C9&oh=00_AYCJswH8NMoaeTQECNGzXOIxL5oFFqU-SQJy06LXS6cCgw&oe=67A97C49',
        createdTime: DateTime.now().subtract(const Duration(days: 1)),
        permalink: 'https://www.facebook.com/benhvienhungvuonggialai/posts/123456788',
        likesCount: 189,
        commentsCount: 25,
        sharesCount: 15,
      ),
      FacebookPostModel(
        id: '3',
        message: '🎉 CHÚC MỪNG NGÀY THÀNH LẬP BỆNH VIỆN\n\n'
            'Nhân dịp kỷ niệm 15 năm thành lập, Bệnh viện Hùng Vương Gia Lai xin gửi lời cảm ơn sâu sắc đến toàn thể cán bộ nhân viên, Quý bệnh nhân và gia đình đã luôn tin tưởng và đồng hành cùng chúng tôi.\n\n'
            'Chúng tôi cam kết sẽ không ngừng nỗ lực để mang đến dịch vụ y tế chất lượng cao nhất! 💙',
        fullPicture: null,
        createdTime: DateTime.now().subtract(const Duration(days: 2)),
        permalink: 'https://www.facebook.com/benhvienhungvuonggialai/posts/123456787',
        likesCount: 512,
        commentsCount: 67,
        sharesCount: 45,
      ),
      FacebookPostModel(
        id: '4',
        message: '💉 TIÊM CHỦNG VACCINE COVID-19 MŨI BỔ SUNG\n\n'
            'Bệnh viện đang tiếp tục triển khai tiêm chủng vaccine COVID-19 mũi bổ sung cho:\n'
            '- Người trên 18 tuổi\n'
            '- Đã tiêm đủ 2 mũi cơ bản sau 6 tháng\n\n'
            'Mang theo CMND/CCCD và sổ tiêm chủng khi đến tiêm.',
        fullPicture: 'https://scontent.fsgn2-3.fna.fbcdn.net/v/t39.30808-6/470922099_1115539110602058_8732878577518622177_n.jpg?_nc_cat=101&ccb=1-7&_nc_sid=127cfc&_nc_eui2=AeF4vePVYxYM_ULmWLl4fI1sn5cYWWv6s6SflxhZa_qzpOrwzMy8UPK2AW46MSDvC6qp19rnpNt8cVq3oU1bqxsq&_nc_ohc=IUnfQdD0YIMQ7kNvgEwXm9E&_nc_zt=23&_nc_ht=scontent.fsgn2-3.fna&_nc_gid=ArdExWgcw0cPzmqfPxpS8C9&oh=00_AYCJswH8NMoaeTQECNGzXOIxL5oFFqU-SQJy06LXS6cCgw&oe=67A97C49',
        createdTime: DateTime.now().subtract(const Duration(days: 3)),
        permalink: 'https://www.facebook.com/benhvienhungvuonggialai/posts/123456786',
        likesCount: 156,
        commentsCount: 12,
        sharesCount: 28,
      ),
      FacebookPostModel(
        id: '5',
        message: '🌟 TUYỂN DỤNG NHÂN SỰ Y TẾ\n\n'
            'Bệnh viện Hùng Vương Gia Lai đang tìm kiếm:\n'
            '- Bác sĩ chuyên khoa Nội\n'
            '- Điều dưỡng viên\n'
            '- Kỹ thuật viên X-quang\n\n'
            'Hồ sơ gửi về: tuyendung@bvhvgl.com\n'
            'Hạn nộp: 31/01/2026',
        fullPicture: null,
        createdTime: DateTime.now().subtract(const Duration(days: 5)),
        permalink: 'https://www.facebook.com/benhvienhungvuonggialai/posts/123456785',
        likesCount: 89,
        commentsCount: 34,
        sharesCount: 56,
      ),
    ];
  }
}
