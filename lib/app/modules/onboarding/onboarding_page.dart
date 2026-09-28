import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wayaak/app/core/widgets/global_button.dart';
import 'package:wayaak/app/core/widgets/global_indicators.dart';
import 'package:wayaak/app/modules/onboarding/onboarding_controller.dart';
import 'package:wayaak/app/routes/app_routes.dart';

class OnboardingPage extends GetView<OnboardingController> {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () {
          return Center(
            child: Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    scrollDirection: Axis.horizontal,
                    controller: controller.pageController,
                    physics: const BouncingScrollPhysics(),
                    itemCount: controller.onBoardingPages.length,
                    itemBuilder: (context, index) =>
                        controller.onBoardingPages[index],
                    onPageChanged: (value) =>
                        controller.currentPage.value = value,
                  ),
                ),
                GlobalIndicators(
                    length: controller.onBoardingPages.length,
                    selectedIndex: controller.currentPage.value),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GlobalButton(
                    onTap: (controller.currentPage.value == 2)
                        ? () {
                            controller.appServices.setIsFirstTime(false);
                            Get.offAllNamed(Routes.welcome);
                          }
                        : () {
                            controller.pageController.nextPage(
                              duration: const Duration(milliseconds: 600),
                              curve: Curves.easeInOut,
                            );
                          },
                    text: (controller.currentPage.value == 2)
                        ? 'Get Started'
                        : 'Next',
                    color: Get.theme.primaryColor,
                    width: Get.width,
                  ),
                ),
                const SizedBox(height: 5),
                if (controller.currentPage.value != 2) ...{
                  GlobalButton(
                    onTap: () {
                      controller.pageController.animateToPage(
                        2,
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.easeInOut,
                      );
                    },
                    text: 'Skip',
                    color: Colors.white,
                    textColor: Get.theme.primaryColor,
                  ),
                } else ...{
                  const SizedBox(height: 50),
                },
                const SizedBox(height: 5),
              ],
            ),
          );
        },
      ),
    );
  }
}
