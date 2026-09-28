import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wayaak/app/core/widgets/global_appbar.dart';
import 'package:wayaak/app/core/widgets/global_button.dart';
import 'package:wayaak/app/data/extensions/extensions.dart';
import 'package:wayaak/app/modules/auth/controllers/auth_controller.dart';
import 'package:wayaak/app/routes/app_routes.dart';

class ChooseUserType extends GetView<AuthController> {
  const ChooseUserType({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GlobalAppbar(title: "Choose User Type".tr),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Obx(() {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ...List.generate(
                  2,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: RadioListTile<int>(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 20),
                      value: index,
                      groupValue: controller.userTypeVal.value,
                      onChanged: (value) {
                        if (value != null) {
                          controller.userTypeVal.value = value;
                        }
                      },
                      secondary: index == 0
                          ? "user".iconColored(size: 80)
                          : "store".iconColored(size: 80),
                      title: (index == 0 ? "User".tr : "Store".tr).titleSmall(),
                      controlAffinity: ListTileControlAffinity.trailing,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side:
                            const BorderSide(color: Colors.black12, width: 1.6),
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                GlobalButton(
                  onTap: () {
                    Get.toNamed(Routes.signup);
                  },
                  text: "Continue".tr,
                  width: Get.width,
                ),
                const SafeArea(child: SizedBox()),
              ],
            );
          }),
        ),
      ),
    );
  }
}
