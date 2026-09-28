import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wayaak/app/data/services/app_services.dart';
import 'package:wayaak/app/modules/onboarding/widgets/onboarding_view.dart';

class OnboardingController extends GetxController {
  final PageController pageController = PageController();
  final AppServices appServices = AppServices();
  RxInt currentPage = 0.obs;

  RxBool localeEn = true.obs;

  final List<Widget> onBoardingPages = [
    const OnboardingView(
      img: 'onboarding1',
      title: 'Order everything from anywhere',
      description:
          "Do you want to order something to anyone? Don't worry you can do it now!",
    ),
    const OnboardingView(
      img: 'onboarding2',
      title: 'Order everything from anywhere',
      description:
          "Do you want to order something to anyone? Don't worry you can do it now!",
    ),
    const OnboardingView(
      img: 'onboarding3',
      title: 'Order everything from anywhere',
      description:
          "Do you want to order something to anyone? Don't worry you can do it now!",
    ),
  ];
}
