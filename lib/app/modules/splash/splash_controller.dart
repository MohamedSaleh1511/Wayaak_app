import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:wayaak/app/data/services/app_services.dart';
import 'package:wayaak/app/routes/app_routes.dart';

class SplashController extends GetxController {
  final AppServices _appServices = Get.find<AppServices>();

  @override
  void onInit() {
    super.onInit();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.white,
      ),
    );
  }

  @override
  void onReady() {
    super.onReady();

    Timer(const Duration(milliseconds: 2500), () {
      if (_appServices.isFirstTime.value) {
        Get.offAllNamed(Routes.onboarding);
      } else {
        if (_appServices.accessToken.value.isEmpty) {
          Get.offAllNamed(Routes.login);
        } else {
          Get.offAllNamed(Routes.main);
        }
      }
    });
  }
}
