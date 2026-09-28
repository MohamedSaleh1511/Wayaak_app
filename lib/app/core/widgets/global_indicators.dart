import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wayaak/app/data/constants/constants.dart';

class GlobalIndicators extends StatelessWidget {
  final int length;
  final int selectedIndex;

  const GlobalIndicators(
      {super.key, required this.length, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        length,
        (index) => AnimatedContainer(
          margin: const EdgeInsets.symmetric(horizontal: 3),
          duration: const Duration(milliseconds: 500),
          width: selectedIndex == index ? 35 : 15,
          height: 6,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: selectedIndex == index
                ? Get.theme.primaryColor
                : Constants.grey,
          ),
        ),
      ),
    );
  }
}
