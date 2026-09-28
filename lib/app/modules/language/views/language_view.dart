import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:wayaak/app/core/widgets/global_appbar.dart';
import 'package:wayaak/app/data/extensions/extensions.dart';
import 'package:wayaak/app/data/providers/shared_prefs.dart';

import '../controllers/language_controller.dart';

class LanguageView extends GetView<LanguageController> {
  const LanguageView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GlobalAppbar(title: 'language setting'.tr),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  controller.changeLang('en').then((v) {
                    Get.updateLocale(const Locale('en'));
                    SharedPrefsHelper.storeLanguage('en');
                  });
                },
                child: Row(
                  children: [
                    Image.asset('assets/images/USA.png'),
                    const SizedBox(width: 10),
                    Expanded(
                      child: 'English'.tr.bodyMedium(color: Colors.black),
                    ),
                    if (Get.locale == const Locale('en'))
                      'check'.iconColored(color: Get.theme.primaryColor),
                  ],
                ).decorate(padding: 16),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () {
                  controller.changeLang('ar').then((v) {
                    Get.updateLocale(const Locale('ar'));
                    SharedPrefsHelper.storeLanguage('ar');
                  });
                },
                child: Row(
                  children: [
                    Image.asset('assets/images/egypt.png'),
                    const SizedBox(width: 10),
                    Expanded(
                      child: 'Arabic'.tr.bodyMedium(color: Colors.black),
                    ),
                    if (Get.locale == const Locale('ar'))
                      'check'.iconColored(color: Get.theme.primaryColor),
                  ],
                ).decorate(padding: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
