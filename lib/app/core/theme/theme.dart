import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:wayaak/app/data/constants/constants.dart';

final ThemeData light = ThemeData(
  fontFamily: Get.locale == const Locale('ar') ? 'Tajawal' : 'Montserrat',
  primaryColor: Constants.primary,
  colorScheme: const ColorScheme.light().copyWith(
    primary: Constants.primary,
    secondary: Constants.secondary,
    error: Constants.accent,
    surfaceTint: Colors.transparent,
  ),
  scaffoldBackgroundColor: Colors.white,
  shadowColor: const Color.fromRGBO(6, 43, 45, 0.1),
  appBarTheme: AppBarTheme(
    elevation: 3,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    backgroundColor: Colors.white,
    shadowColor: const Color.fromRGBO(39, 63, 219, 0.09),
  ),
  checkboxTheme: CheckboxThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(3),
    ),
    side: const BorderSide(width: 1.5, color: Colors.black),
  ),
);

class Ui {
  static void successGetBar({required String message}) {
    try {
      // Use ScaffoldMessenger which is more reliable than GetX snackbar
      Future(() async {
        try {
          await Future.delayed(const Duration(milliseconds: 50));
          if (Get.context != null) {
            ScaffoldMessenger.of(Get.context!).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    // Indicator line
                    Container(
                      width: 4,
                      height: 42,
                      decoration: BoxDecoration(
                        color: Colors.greenAccent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Icon
                    const Icon(
                      Icons.check_circle_rounded,
                      color: Colors.white,
                      size: 26,
                    ),
                    const SizedBox(width: 12),

                    // Message
                    Expanded(
                      child: Text(
                        message,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                backgroundColor: const Color(0xFF1E7F43),
                duration: const Duration(seconds: 3),
                behavior: SnackBarBehavior.floating,
                margin:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            );
          }
        } catch (e) {
          debugPrint('Error showing success snackbar: $e');
        }
      });
    } catch (e) {
      debugPrint('Error in successGetBar: $e');
    }
  }

  static void errorGetBar({required String message}) {
    try {
      // Use ScaffoldMessenger which is more reliable than GetX snackbar
      Future(() async {
        try {
          await Future.delayed(const Duration(milliseconds: 50));
          if (Get.context != null) {
            ScaffoldMessenger.of(Get.context!).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    // Indicator line
                    Container(
                      width: 4,
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Icon
                    const Icon(
                      Icons.error_outline_rounded,
                      color: Colors.redAccent,
                      size: 28,
                    ),
                    const SizedBox(width: 12),

                    // Message
                    Expanded(
                      child: Text(
                        message,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
                backgroundColor: Colors.black.withOpacity(0.75),
                duration: const Duration(seconds: 3),
                behavior: SnackBarBehavior.floating,
                margin:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
            );
          }
        } catch (e) {
          debugPrint('Error showing error snackbar: $e');
        }
      });
    } catch (e) {
      debugPrint('Error in errorGetBar: $e');
    }
  }

  static void loadingDialog() {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        insetAnimationCurve: Curves.bounceInOut,
        insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Loading'.tr,
                style: Get.textTheme.bodyLarge!.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  fontFamily: Get.locale == const Locale('ar')
                      ? 'Tajawal'
                      : 'Montserrat',
                ),
              ),
              const SizedBox(width: 5),
              Lottie.asset('assets/lotties/dots-loader.json', width: 80),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
      transitionCurve: Curves.easeInOutBack,
    );
  }
}
