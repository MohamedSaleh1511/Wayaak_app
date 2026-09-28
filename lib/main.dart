import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:wayaak/app/core/helpers/notification_helper.dart';
import 'package:wayaak/app/core/theme/theme.dart';
import 'package:wayaak/app/data/services/app_services.dart';
import 'package:wayaak/app/data/services/socket_service.dart';
import 'package:wayaak/app/data/services/translation_service.dart';
import 'package:wayaak/firebase_options.dart';
import 'package:upgrader/upgrader.dart';

import 'app/routes/app_pages.dart';

Future<void> initServices() async {
  Get.log('starting services ...');
  final apps = Firebase.apps;
  if (apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } else {
    //  Already initialized, no action needed
  }
  await Get.putAsync<SocketServices>(() async => SocketServices());
  await Get.putAsync<AppServices>(() async => AppServices());
  await Get.putAsync<TranslationService>(() => TranslationService().init());
  NotificationSettings settings =
      await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  await NotificationsHelper.init();
  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    log('User granted permission');
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    log('User granted provisional permission');
  } else {
    log('User declined or has not accepted permission');
  }

  Get.log('All services started...');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initServices();
  FirebaseMessaging.onMessage.listen(
    (event) {
      if (Get.find<AppServices>().notificationsOn.value) {
        NotificationsHelper.show(event);
      }
    },
  );
  FirebaseMessaging.onBackgroundMessage(notificationsBackgroundHandler);
  FirebaseMessaging.onMessageOpenedApp
      .listen(NotificationsHelper.handleNotificationCallback);
  final String? deviceCountryCode = Get.deviceLocale?.countryCode;
  final String deviceLanguageCode = Get.deviceLocale?.languageCode ?? 'ar';

  final upgrader = Upgrader(
    countryCode: deviceCountryCode ??
        'SA', // Dynamically checks the device's App Store region
    languageCode: deviceLanguageCode,
  );

  runApp(UpgradeAlert(upgrader: upgrader, child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final translationServices = Get.find<TranslationService>();
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wyaak',
      theme: light,
      localizationsDelegates: const [
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: translationServices.supportedLocales(),
      translationsKeys: translationServices.translations,
      locale: Get.locale ?? Locale(Get.deviceLocale!.languageCode),
      fallbackLocale: translationServices.fallbackLocale,
      initialRoute: AppPages.initial,
      defaultTransition: Transition.cupertino,
      getPages: AppPages.routes,
    );
  }
}
