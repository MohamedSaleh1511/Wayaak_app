import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wayaak/app/core/widgets/global_button.dart';
import 'package:wayaak/app/data/constants/constants.dart';
import 'package:wayaak/app/data/extensions/extensions.dart';
import 'package:wayaak/app/modules/onboarding/onboarding_controller.dart';
import 'package:wayaak/app/routes/app_routes.dart';

class WelcomePage extends GetView<OnboardingController> {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Obx(() {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/welcome.png'),
                const SizedBox(height: 35),
                "select your language".title(color: Colors.black),
                const SizedBox(height: 20),
                InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => controller.localeEn.value = true,
                  child: Container(
                    width: Get.width,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: (controller.localeEn.value)
                          ? Border.all(
                              color: Get.theme.primaryColor, width: 1.5)
                          : Border.all(color: Constants.grey, width: 1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: "English".button(),
                  ),
                ),
                const SizedBox(height: 10),
                InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => controller.localeEn.value = false,
                  child: Container(
                    width: Get.width,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: (controller.localeEn.value)
                          ? Border.all(color: Constants.grey, width: 1)
                          : Border.all(
                              color: Get.theme.primaryColor, width: 1.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: "Arabic".button(),
                  ),
                ),
                const SizedBox(height: 30),
                GlobalButton(
                  width: Get.width,
                  onTap: () {
                    if (controller.localeEn.value) {
                      Get.updateLocale(const Locale('en'));
                    } else {
                      Get.updateLocale(const Locale('ar'));
                    }
                    Get.offAllNamed(Routes.login);
                  },
                  text: 'Select',
                  color: Get.theme.primaryColor,
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
