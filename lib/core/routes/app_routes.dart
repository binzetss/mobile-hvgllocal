import 'package:flutter/material.dart';
import '../../pages/splash/splash_page.dart';
import '../../pages/dangnhap/dangnhap_page.dart';
import '../../pages/vanban/vanban_page.dart';
import '../../pages/trangchu/trangchu_page.dart';
import '../../pages/hoso/hoso_page.dart';
import '../../pages/nhansu/nhansu_page.dart';
import '../../pages/gioithieu/gioithieu_page.dart';
import '../../pages/hotro/hotro_page.dart';
import '../../pages/caidat/doimatkhau_page.dart';
import '../../pages/lichkham/lichkham_page.dart';
import '../../pages/gopykien/gopykien_page.dart';
import '../../pages/daotao/daotao_page.dart';
import '../animations/page_transitions.dart';

class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String login = '/login';
  static const String home = '/home';
  static const String documents = '/documents';
  static const String profile = '/profile';
  static const String staff = '/staff';
  static const String about = '/about';
  static const String support = '/support';
  static const String changePassword = '/change-password';
  static const String clinicSchedule = '/clinic-schedule';
  static const String gopykien = '/gopykien';
  static const String daotao = '/daotao';

  static Map<String, WidgetBuilder> get routes => {
        splash: (context) => const SplashPage(),
        login: (context) => const DangnhapPage(),
        home: (context) => const TrangchuPage(),
        documents: (context) => const VanbanPage(),
        profile: (context) => const HosoPage(),
        staff: (context) => const NhansuPage(),
        about: (context) => const GioithieuPage(),
        support: (context) => const HotroPage(),
        changePassword: (context) => const DoimatkhauPage(),
        clinicSchedule: (context) => const LichkhamPage(),
        gopykien: (context) => const GopyKienPage(),
        daotao: (context) => const DaotaoPage(),
      };

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return AppPageTransitions.fadeTransition(const SplashPage());
      case login:
        return AppPageTransitions.fadeTransition(const DangnhapPage());
      case home:
        return AppPageTransitions.heroZoomTransition(const TrangchuPage());
      case documents:
        return AppPageTransitions.slideRightTransition(const VanbanPage());
      case profile:
        return AppPageTransitions.slideRightTransition(const HosoPage());
      case staff:
        return AppPageTransitions.slideRightTransition(const NhansuPage());
      case about:
        return AppPageTransitions.slideRightTransition(const GioithieuPage());
      case support:
        return AppPageTransitions.slideRightTransition(const HotroPage());
      case changePassword:
        return AppPageTransitions.slideRightTransition(const DoimatkhauPage());
      case clinicSchedule:
        return AppPageTransitions.slideRightTransition(const LichkhamPage());
      case gopykien:
        return AppPageTransitions.slideRightTransition(const GopyKienPage());
      case daotao:
        return AppPageTransitions.slideRightTransition(const DaotaoPage());
      default:
        return AppPageTransitions.fadeTransition(const DangnhapPage());
    }
  }
}
