class ApiEndpoints {
  ApiEndpoints._();
  static const String baseUrl = 'https://hvoffice.bvhvgl.com/api';
  static const String imageBaseUrl = 'https://image.bvhvgl.com/images/AppNoiBo';
  static const String docsBaseUrl = 'https://docs.bvhvgl.com';
  static const String lichKhamBaseUrl = 'https://lichphongkham.bvhvgl.com/api';
  static const String login = '$baseUrl/Login';
  static const String logout = '$baseUrl/Logout';
  static const String vanBanNoiBo = '$baseUrl/VanBanNoiBo';
  static const String danhSachNhanVien = '$baseUrl/DanhSachNhanVien';
  static const String lichLamViec = '$lichKhamBaseUrl/lichlamviec';
  static const String daoTao = '$baseUrl/DaoTao';
  static const String lopDaoTao = '$baseUrl/LopDaoTao';
  static const String dangKyDaoTao = '$baseUrl/DangKyDaoTao';
  static const String huyDangKyDaoTao = '$baseUrl/HuyDangKyDaoTao';
  static const String doiMatKhau = '$baseUrl/DoiMatKhau';
  static const String anhDaiDien = '$baseUrl/AnhDaiDien';
  static const String thucDon = '$baseUrl/ThucDon';
  static const String dangKyCom = '$baseUrl/DangKyCom';
  static const String huyDangKyCom = '$baseUrl/HuyDangKyCom';
  static const String chamCong = '$baseUrl/ChamCong';
  static const String chamTruc = '$baseUrl/ChamTruc';
  static const String fcmToken = '$baseUrl/FcmToken';
  static const String sendNotification = '$baseUrl/SendNotification';
  static const String logoHeader = '$imageBaseUrl/logodautrang.png';
  static const String logo = '$imageBaseUrl/logodautrang.png';
  static const String buildingLogin = '$imageBaseUrl/buildinglogin.png';
}
