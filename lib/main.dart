import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hvgl/providers/facebook_provider.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_strings.dart';
import 'core/services/firebase_notification_service.dart';
import 'providers/providers.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  await FirebaseNotificationService().initialize();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ChamcongProvider()..init()),
        ChangeNotifierProvider(create: (_) => XacthucProvider()..init()),
        ChangeNotifierProvider(create: (_) => ThongBaoProvider()),
        ChangeNotifierProvider(create: (_) => VanbanProvider()),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => MenuProvider()),
        ChangeNotifierProvider(create: (_) => HosoProvider()),
        ChangeNotifierProvider(create: (_) => NhansuProvider()),
        ChangeNotifierProvider(create: (_) => BosungChamcongProvider()),
        ChangeNotifierProvider(create: (_) => LichkhamProvider()),
        ChangeNotifierProvider(create: (_) => FacebookProvider()),
        ChangeNotifierProvider(create: (_) => GopyKienProvider()),
        ChangeNotifierProvider(create: (_) => MealMenuProvider()),
        ChangeNotifierProvider(create: (_) => DaotaoProvider()),
      ],
      child: MaterialApp(
        title: AppStrings.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        onGenerateRoute: AppRoutes.onGenerateRoute,
      ),
    );
  }
}
