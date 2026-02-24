class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = 'https://hvoffice.bvhvgl.com/api';
  static const String imageBaseUrl = 'https://image.bvhvgl.com/images/AppNoiBo';
  static const String docsBaseUrl = 'https://docs.bvhvgl.com';
  static const String lichKhamBaseUrl = 'https://lichphongkham.bvhvgl.com/api';

  static const String login = '$baseUrl/Login';
  static const String vanBanNoiBo = '$baseUrl/VanBanNoiBo';
  static const String danhSachNhanVien = '$baseUrl/DanhSachNhanVien';
  static const String lichLamViec = '$lichKhamBaseUrl/lichlamviec';
  static const String daoTao = '$baseUrl/DaoTao';
  static const String lopDaoTao = '$baseUrl/LopDaoTao';
  static const String dangKyDaoTao = '$baseUrl/DangKyDaoTao';
  static const String huyDangKyDaoTao = '$baseUrl/HuyDangKyDaoTao';
  static const String logoHeader = '$imageBaseUrl/logodautrang.png';
  static const String logo = '$imageBaseUrl/logodautrang.png';
  static const String buildingLogin = '$imageBaseUrl/buildinglogin.png';
}
