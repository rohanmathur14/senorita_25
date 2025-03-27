import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:senoritaApp/api_config/dependency_injection.dart';
import 'package:senoritaApp/firebase_api/PushNotificationService.dart';
import 'package:senoritaApp/utils/notification_service.dart';
import 'package:senoritaApp/utils/theme.dart';
import 'package:senoritaApp/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ScreenRoutes/apppages.dart';
import 'ScreenRoutes/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  getFCMToken();
  PushNotificationService pushNotificationService = PushNotificationService();
  await pushNotificationService.initialize();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await FlutterDownloader.initialize(
      debug:
          true, // optional: set to false to disable printing logs to console (default: true)
      ignoreSsl:
          true // option: set to false to disable working with http links (default: false)
      );
  runApp(const MyApp());
  // DependencyInjection.init();
  configLoading();
}

getFCMToken() async {
  FirebaseMessaging.instance.requestPermission();
  FirebaseMessaging.instance.getAPNSToken();
  FirebaseMessaging.instance.getToken().then((token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('fcmToken', token!);
  });
}

Future<void> backgroundHandler(RemoteMessage message) async {
  print('Handling a background message ${message.messageId}');
}

@override
class MyApp extends StatefulWidget {
  const MyApp({key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final NotificationService notificationService = NotificationService();

  @override
  Widget build(BuildContext context) {
    // notificationService.initialize();
    return GestureDetector(
      onTap: () {
        Utils.hideKeyboard();
      },
      child: GetMaterialApp(
        title: 'Senorita',
        navigatorKey: navigatorKey,
        theme: lightThemeData(context),
        scrollBehavior: const ScrollBehavior(),
        darkTheme: darkThemeData(context),
        themeMode: ThemeMode.light,
        debugShowCheckedModeBanner: false,
        getPages: AppPages.pages,
        initialRoute: AppRoutes.splash,
        builder: EasyLoading.init(),
      ),
    );
  }
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
}
