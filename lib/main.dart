import 'dart:io';

import 'package:beacorder_user_table/screen/user/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'providers/cart_provider.dart';
import 'providers/menu_provider.dart';
import 'providers/store_provider.dart';
import 'screen/main_screen.dart';
import 'screen/common/menu_detail.dart';
import 'screen/home/store_main.dart';
import 'service/api_service.dart';
import 'service/ble_service.dart';
import 'models/store_dto.dart';

String? fcmToken;

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackGroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  String? title = message.data['title'];
  String? body = message.data['body'];

  print('백그라운드 실행');
  FlutterLocalNotificationsPlugin().show(
    0,
    title,
    body,
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'high_importance_channel',
        'high_importance_notification',
        importance: Importance.max,
      ),
    ),
  );
}

void initializeNotification() async {
  final flutterLocalNotificationplugin = FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationplugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(const AndroidNotificationChannel(
        'high_importance_channel',
        'high_importance_notification',
        importance: Importance.max,
      ));

  await flutterLocalNotificationplugin.initialize(
    const InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/ic_launcher"),
    ),
  );

  final token = await FirebaseMessaging.instance.getToken();
  fcmToken = token;
  // print('Token :  $token');
}

void showFirebaseMessage(RemoteMessage message) {
  String? title = message.data['title'];
  String? body = message.data['body'];

  FlutterLocalNotificationsPlugin().show(
    0,
    title,
    body,
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'high_importance_channel',
        'high_importance_notification',
        importance: Importance.max,
      ),
    ),
  );
}

void main() async {
  await dotenv.load(fileName: "assets/setting.env");

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackGroundHandler);
  initializeNotification();
  KakaoSdk.init(nativeAppKey: dotenv.env['KAKAO_NATIVE_APP_KEY']!);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => StoreProvider()),
        ChangeNotifierProvider(create: (context) => MenuProvider()),
        ChangeNotifierProvider(create: (context) => CartProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.cyan,
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: Colors.cyan,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white70,
          ),
        ),
        home: LoginScreen(),
        routes: {
          '/main': (context) => MainScreen(),
          '/menu_detail': (context) => MenuDetailScreen(),
          '/store_main': (context) => StoreMainScreen(),
          '/login': (context) => LoginScreen(),
        },
      ),
    );
  }
}
